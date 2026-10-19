pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property var vpnConnections: []

    // Check if anything's running, return if so, otherwise nothing
    function getText(index: int): string {
        if (root.vpnConnections != undefined && root.vpnConnections.length > 0) {
            return root.vpnConnections[index].type;
        }
    }

    function fetchVPN(): void {
        Globals.logEverything("Fetching for VPN state...");
        fetchVPN.running = true;
    }

    Process {
        id: fetchVPN

        command: [`${Globals.basePath}/scripts/vpn.sh`, "fetch_vpn"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.vpnConnections = JSON.parse(this.text.trim());
                } catch (e) {
                    if (this.text.trim() != "") {
                        Globals.logError("VPN parse failed: " + e);
                    } else {
                        Globals.logDebug("No VPN active, so parser failed.");
                    }
                }
            }
        }
    }

    function connectVPN(provider: string, config: string): void {
        Globals.logDebug("Connecting " + config + " via " + provider + ".");
        vpnManager.command = ["pkexec", `${Globals.basePath}/scripts/vpn.sh`, "connect_vpn", provider, config];
        vpnManager.running = true;
    }

    function killVPN(provider: string, config: string): void {
        Globals.logDebug("Disconnecting " + config + " via " + provider + ".");
        vpnManager.command = ["pkexec", `${Globals.basePath}/scripts/vpn.sh`, "disconnect_vpn", provider, config];
        vpnManager.running = true;
    }

    Process {
        id: vpnManager

        stdout: StdioCollector {
            onStreamFinished: {
                root.fetchVPN();
            }
        }
    }

    Component.onCompleted: root.fetchVPN()
}
