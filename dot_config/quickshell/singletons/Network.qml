pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string interfaceType: ""
    property string interfaceTitle: ""

    property bool onlineState: false

    property int downloadSpeed: 0
    property int maximumDownloadSpeed: 0
    property int uploadSpeed: 0
    property int maximumUploadSpeed: 0

    property string formattedSpeed: Network.download + " B/s " + Network.upload + " B/s"

    property string ipAddress: ""
    property string gatewayAddress: ""
    property string dnsAddress: ""

    property string activeWirelessNetwork: ""
    property var wirelessNetworks: []

    // This is used to toggle between display-states
    property bool displayToggler: false

    Timer {
        id: toggleDisplayToggler

        interval: root.displayToggler ? 10000 : 5000

        running: true
        repeat: true

        onTriggered: root.displayToggler = !root.displayToggler
    }

    function getText(): string {
        if (Themes.iconMode) {
            return "\udb80\udc02";
        } else {
            if (root.interfaceType === "") {
                return "No network";
            } else {
                return root.onlineState ? root.displayToggler ? root.formattedSpeed : "up: " + root.interfaceTitle : "down: network";
            }
        }
    }

    // =================== General network ====================
    //
    //
    //
    // Generall stuff like fetching states and so on
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
                Globals.logEverything("Network interface event detected: " + data);

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
                Globals.logEverything("Network address event detected: " + data);
                getAddress.running = true;
                getActiveWirelessNetwork.running = true;
                root.fetchMaximumSpeeds();
            }
        }
    }

    function fetchNetworkInformation() {
        getAddress.running = true;
        getGateway.running = true;
        getDNS.running = true;
    }

    function startIwctl(): void {
        startIwctl.running = true;
    }

    Process {
        id: startIwctl
        command: ["kitty", "--title", "iwctl", "-e", "iwctl"]
    }

    // =================== Wireless Networks ====================
    //
    //
    //
    // Fetching wireless networks, connect to wireless networks, stuff like that
    Process {
        id: getActiveWirelessNetwork
        command: ["bash", "-c", "iwctl station wlan0 show | grep 'Connected network' | awk '{print substr($0, 35, 80)}'"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.activeWirelessNetwork = this.text.trim();
            }
        }
    }

    function fetchWirelessNetworks() {
        getWirelessNetworks.running = true;
    }

    Process {
        id: getWirelessNetworks
        command: [`${Globals.basePath}/scripts/network.sh`, "wifi"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.wirelessNetworks = JSON.parse(this.text.trim());
                Globals.logEverything("Found " + root.wirelessNetworks.length + " wireless networks.");
                getActiveWirelessNetwork.running = true;
            }
        }
    }

    function stopWirelessNetworkScan() {
        Globals.logEverything("Turning iwctl scan off.");
        stopWirelessNetworkScan.running = true;
    }

    Process {
        id: stopWirelessNetworkScan
        command: ["iwctl", "device", "wlan0", "set-property", "scanning", "off"]
    }

    function connectWirelessNetwork(ssid: string) {
        chooseWirelessNetwork.command = ["kitty", "--title", "iwctl", "-e", "iwctl", "station", "wlan0", "connect", ssid];
        chooseWirelessNetwork.running = true;
    }

    Process {
        id: chooseWirelessNetwork

        stdout: StdioCollector {
            onStreamFinished: {
                getActiveWirelessNetwork.running = true;
            }
        }
    }

    // =================== Get network based information ====================
    //
    //
    //
    // Address fetching is prolly not precised
    Process {
        id: getAddress
        command: ["hostname", "-i"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.ipAddress = this.text.trim();
            }
        }
    }

    Process {
        id: getGateway
        command: ["bash", "-c", "ip route | grep default | awk '{print $3}'"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.gatewayAddress = this.text.trim();
            }
        }
    }

    Process {
        id: getDNS
        command: ["bash", "-c", `resolvectl dns ${root.interfaceTitle} | awk '{print $NF}'`]

        stdout: StdioCollector {
            onStreamFinished: {
                root.dnsAddress = this.text.trim();
            }
        }
    }

    function changeDNS(dnsAddress: string) {
        setDNS.command = ["bash", "-c", `resolvectl dns ${root.interfaceTitle} ${dnsAddress}`];
        setDNS.running = true;
    }

    Process {
        id: setDNS

        stdout: StdioCollector {
            onStreamFinished: {
                getDNS.running = true;
            }
        }
    }

    // =================== Network speed and more stats ====================
    //
    //
    //
    //
    function fetchMaximumSpeeds() {
        getMaximumSpeeds.running = true;
    }

    Process {
        id: getMaximumSpeeds
        command: ["bash", "-c", `speedtest-cli --json | jq -r`]

        stdout: StdioCollector {
            onStreamFinished: {
                const parsed = JSON.parse(this.text.trim());

                root.maximumDownloadSpeed = parsed.download;
                root.maximumUploadSpeed = parsed.upload;
            }
        }
    }

    Process {
        id: fetchSpeed
        command: [`${Globals.basePath}/scripts/network.sh`, "speed", root.interfaceTitle]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const parsed = JSON.parse(this.text.trim());

                    root.downloadSpeed = parsed.rx;
                    root.uploadSpeed = parsed.tx;
                } catch (e) {
                    Globals.logError("Net speed parse failed: " + this.text.trim());
                }
            }
        }
    }

    // This will return a string with a human readable format and size extension
    function formatNetworkSpeed(speed: int): string {
        var kilobit = 1024;
        var megabit = (kilobit ** 2);
        var gigabit = (megabit ** 2);

        if (speed >= gigabit) {
            return Math.round(speed / gigabit) + " Gbit/s";
        } else if (speed >= megabit) {
            return Math.round(speed / megabit) + " Mbit/s";
        } else if (speed >= kilobit) {
            return Math.round(speed / kilobit) + " kbit/s";
        } else {
            return speed + " bit/s";
        }
    }

    Timer {
        interval: 3000

        running: root.onlineState
        repeat: true

        onTriggered: fetchSpeed.running = true
    }

    Component.onCompleted: {
        root.refreshNetworkState();
        root.fetchMaximumSpeeds();
    }
}
