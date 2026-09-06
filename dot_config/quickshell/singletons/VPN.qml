pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool vpnActive: false
    property var vpnConnections: []
    property string lastConnection: "Tailscale: down"

    // Check if anything's running, return if so, otherwise nothing
    function getText(index: int): string {
        if (root.vpnConnections != undefined && root.vpnConnections.length > 0) {
            return root.vpnConnections[index].type;
        } else {
            return root.lastConnection;
        }
    }

    function fetchVPN(): void {
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

                    if (root.vpnActive) {
                        Globals.logDebug("Got " + root.vpnConnections.length + " VPNs!");

                        for (var connection in root.vpnConnections) {
                            Globals.logDebug("Connection: " + root.vpnConnections[connection].type);
                        }

                        root.lastConnection = root.vpnConnections[0].type;
                    }

                    Globals.logEverything("vpnActive is now: " + root.vpnActive);
                    Globals.logEverything("lastConnection is now: " + root.lastConnection);
                    Globals.logEverything("vpnConnections is now: " + root.vpnConnections);
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

    Component.onCompleted: root.fetchVPN()
}
