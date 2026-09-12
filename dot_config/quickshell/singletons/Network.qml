pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string interfaceType: ""
    property string interfaceTitle: ""

    property bool onlineState: false

    property string download: "dl: 0 B/s"
    property string upload: "ul: 0 B/s"
    property string speed: Network.download + " " + Network.upload

    property string address: ""
    property string gateway: ""
    property string dns: ""

    property bool toggler: false

    function getText(): string {
        if (Themes.iconMode) {
            return "\udb80\udc02";
        } else {
            if (root.interfaceType === "") {
                return "No network";
            } else {
                return root.onlineState ? root.toggler ? root.speed : "up: " + root.interfaceTitle : "down: network";
            }
        }
    }

    function refreshNetworkState(): void {
        Globals.logDebug("Refreshing network.");
        networkCheck.running = true;
    }

    Process {
        id: networkCheck

        command: ["bash", "-c", "ip route show default | awk '{print $5}'"]

        stdout: StdioCollector {
            onStreamFinished: data => {
                root.interfaceTitle = this.text.trim();

                Globals.logEverything("Detected network interface: " + root.interfaceTitle);

                if (root.interfaceTitle.startsWith("wl")) {
                    root.interfaceType = "wifi";
                    root.onlineState = true;
                } else if (root.interfaceTitle.startsWith("en")) {
                    root.interfaceType = "ethernet";
                    root.onlineState = true;
                } else {
                    root.interfaceType = "none";
                    root.onlineState = false;
                }

                root.fetchNetworkInformation();
            }
        }
    }

    Process {
        id: interfaceEvents
        command: ["ip", "monitor", "link"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                Globals.logDebug("Network interface event detected: " + data);

                if (data.match(/^\d+:/)) {
                    root.refreshNetworkState();

                    if (data.includes("tun0")) {
                        VPN.fetchVPN();
                    }
                }
            }
        }
    }

    Process {
        id: addressEvents
        command: ["ip", "monitor", "address"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                Globals.logDebug("Network address event detected: " + data);
                getAddress.running = true;
            }
        }
    }

    function fetchNetworkInformation() {
        getAddress.running = true;
        getGateway.running = true;
        getDNS.running = true;
    }

    // Address fetching is prolly not precised
    Process {
        id: getAddress
        command: ["hostname", "-i"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.address = this.text.trim();
            }
        }
    }

    Process {
        id: getGateway
        command: ["bash", "-c", "ip route | grep default | awk '{print $3}'"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.gateway = this.text.trim();
            }
        }
    }

    Process {
        id: getDNS
        command: ["bash", "-c", `resolvectl dns ${root.interfaceTitle} | awk '{print $NF}'`]

        stdout: StdioCollector {
            onStreamFinished: {
                Globals.logDebug("Just ran: " + getDNS.command);
                Globals.logDebug("Output is: " + this.text.trim());
                root.dns = this.text.trim();
            }
        }
    }

    Process {
        id: fetchSpeed

        command: [`${Globals.basePath}/scripts/hardware.sh`, "net", root.interfaceTitle]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const parsed = JSON.parse(this.text.trim());

                    root.download = "dl: " + parsed.rx;
                    root.upload = "ul: " + parsed.tx;
                } catch (e) {
                    Globals.logError("Net speed parse failed: " + this.text.trim());
                }
            }
        }
    }

    function startIwctl(): void {
        startIwctl.running = true;
    }

    Process {
        id: startIwctl
        command: ["kitty", "--title", "iwctl", "-e", "iwctl"]
    }

    Timer {
        interval: 3000

        running: root.onlineState
        repeat: true

        onTriggered: fetchSpeed.running = true
    }

    Timer {
        id: toggleToggler

        interval: root.toggler ? 10000 : 5000

        running: true
        repeat: true

        onTriggered: root.toggler = !root.toggler
    }

    Component.onCompleted: root.refreshNetworkState()
}
