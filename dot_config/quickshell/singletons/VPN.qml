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

        command: [`${Globals.basePath}/scripts/vpn.sh`, "fetch"]

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

    function toggleVPN(name: string): void {
        toggleVPN.command = [`${Globals.basePath}/scripts/vpn.sh`, "toggle", name];
        toggleVPN.running = true;
    }

    Process {
        id: toggleVPN

        stdout: StdioCollector {
            onStreamFinished: {
                root.fetchVPN();
            }
        }
    }

    Component.onCompleted: root.fetchVPN()
}
