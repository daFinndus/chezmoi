pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property var interfaces: []
    property bool fetchedISP: false

    property int downloadSpeed: 0
    property int maximumDownloadSpeed: 0

    onDownloadSpeedChanged: {
        if (root.downloadSpeed > root.maximumDownloadSpeed) {
            root.maximumDownloadSpeed = root.downloadSpeed;
        }
    }

    property int uploadSpeed: 0
    property int maximumUploadSpeed: 0

    onUploadSpeedChanged: {
        if (root.uploadSpeed > root.maximumUploadSpeed) {
            root.maximumUploadSpeed = root.uploadSpeed;
        }
    }

    property var wirelessNetworks: []

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

        command: [`${Globals.basePath}/scripts/network.sh`, "interfaces"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.interfaces = JSON.parse(this.text.trim());

                Globals.logEverything("Detected interfaces: " + root.interfaces.length);
            }
        }
    }

    Process {
        id: interfaceEvents
        command: ["nmcli", "connection", "monitor"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                Globals.logEverything("Network interface event detected: " + data);

                if (data.match(/^\d+:/)) {
                    root.refreshNetworkState();

                    if (data.includes("tun")) {
                        VPN.fetchVPN();
                    }
                }
            }
        }
    }

    // =================== Wireless Networks ====================
    //
    //
    //
    // Fetching wireless networks, connect to wireless networks, stuff like that
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
            }
        }
    }

    function disconnectWirelessNetwork(interface: string) {
        Globals.logEverything("Disconnecting interface: " + interface);

        changeWirelessNetwork.command = ["nmcli", "device", "disconnect", interface];
        changeWirelessNetwork.running = true;
    }

    function connectWirelessNetwork(ssid: string) {
        changeWirelessNetwork.command = ["kitty", "--title", "nmcli", "-e", "nmcli", "device", "wifi", "connect", ssid, "--ask"];
        changeWirelessNetwork.running = true;
    }

    Process {
        id: changeWirelessNetwork

        stdout: StdioCollector {
            onStreamFinished: {
                if (this.text.trim().includes("successfully")) {
                    Globals.logDebug("Successfully changed wifi.");
                    root.refreshNetworkState();
                    root.fetchWirelessNetworks();
                } else {
                    Globals.logError("Error in changing wifi.");
                    Globals.logError("Error: " + this.text.trim());
                }
            }
        }
    }

    // =================== Get network based information ====================
    //
    //
    //
    // Address fetching is prolly not precised
    function changeDNS(dnsAddress: string) {
        setDNS.command = ["nmcli", "connection", "modify", root.interfaces[0]?.device, "+ipv4.dns", dnsAddress];
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

                root.fetchedISP = true;
            }
        }
    }

    Process {
        id: fetchSpeed
        command: [`${Globals.basePath}/scripts/network.sh`, "speed", root.interfaces[0]?.device]

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

    Timer {
        interval: 3000

        running: Network.interfaces.length > 0
        repeat: true

        onTriggered: fetchSpeed.running = true
    }

    Component.onCompleted: {
        root.refreshNetworkState();
    }
}
