pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool vpnActive: false
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

        command: [`${Globals.basePath}/scripts/vpn.sh`]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const parsed = JSON.parse(this.text.trim());

                    root.vpnConnections = parsed.connections;
                    root.vpnActive = parsed.active;
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

    function killVPN(provider: string, network: string): void {
        killVPN.command = ["bash", "-c", `pkexec /usr/sbin/pgrep -fi \"${provider}.*${network}\" | xargs -n 1 kill`];
        killVPN.running = true;
    }

    Process {
        id: killVPN

        stdout: StdioCollector {
            onStreamFinished: {
                root.fetchVPN();
            }
        }
    }

    Component.onCompleted: root.fetchVPN()
}
