pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool vpnActive: false
    property var vpnConnections: []
    property string lastConnection: ""

    function fetchVPN() {
        fetchVPN.running = true;
    }

    Process {
        id: fetchVPN

        command: [`${Globals.configPath}/scripts/vpn.sh`]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const parsed = JSON.parse(this.text.trim());

                    root.vpnConnections = parsed.connections;
                    root.vpnActive = parsed.active;

                    Globals.logDebug("Found active VPN? " + parsed.active);

                    if (root.vpnActive) {
                        Globals.logDebug("Got " + root.vpnConnections.length + " VPNs!")

                        for (var connection in root.vpnConnections) {
                            Globals.logDebug("Connection: " + root.vpnConnections[connection].type);
                        }
                    }
                } catch (e) {
                    if (this.text.trim() != "") {
                        Globals.logError("VPN parse failed: " + e);
                    } else {
                        Globals.logDebug("No VPN active, so parser failed.")
                    }
                }
            }
        }
    }

    Timer {
        interval: 5000

        running: true
        repeat: true

        onTriggered: root.fetchVPN()
    }
}
