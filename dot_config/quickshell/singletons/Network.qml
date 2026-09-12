pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string type: "none"
    property string interfaceTitle: ""
    property bool online: false

    property string download: "dl: 0 B/s"
    property string upload: "ul: 0 B/s"

    property string speed: Network.download + " " + Network.upload
    property bool toggler: false

    function getText(): string {
        if (Themes.iconMode) {
            return "\udb80\udc02";
        } else {
            if (root.type === "none") {
                return "No network";
            } else {
                return root.online ? root.toggler ? root.speed : "up: " + root.interfaceTitle : "down: network";
            }
        }
    }

    function refreshNetworkState(): void {
        Globals.logDebug("Refreshing network.");
        networkCheck.running = true;
    }

    function startIwctl(): void {
        startIwctl.running = true;
    }

    Process {
        id: networkCheck

        command: ["bash", "-c", "ip route show default | awk '{print $5}'"]

        stdout: StdioCollector {
            onStreamFinished: data => {
                root.interfaceTitle = this.text.trim();

                Globals.logEverything("Detected network interface: " + root.interfaceTitle);

                if (root.interfaceTitle.startsWith("wl")) {
                    root.type = "wifi";
                    root.online = true;
                } else if (root.interfaceTitle.startsWith("en")) {
                    root.type = "ethernet";
                    root.online = true;
                } else {
                    root.type = "none";
                    root.online = false;
                }
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

    Process {
        id: startIwctl

        command: ["kitty", "--title", "iwctl", "-e", "iwctl"]
    }

    Timer {
        interval: 3000

        running: true
        repeat: true

        onTriggered: {
            if (root.online && !fetchSpeed.running) {
                fetchSpeed.running = true;
            }
        }
    }

    Timer {
        interval: root.toggler ? 10000 : 5000

        running: true
        repeat: true

        onTriggered: root.toggler = !root.toggler
    }

    Component.onCompleted: root.refreshNetworkState()
}
