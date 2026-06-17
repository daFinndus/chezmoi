pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string type: "none"
    property string hardware: ""
    property bool online: false

    Component.onCompleted: {
        networkCheck.running = true;
    }

    function refreshNetworkState() {
        networkCheck.running = true;
    }

    Process {
        id: networkCheck

        command: ["bash", "-c", "ip route show default | awk '{print $5}'"]

        stdout: StdioCollector {
            onStreamFinished: data => {
                hardware = this.text.trim();

                console.log("Detected network interface:", hardware);

                if (hardware.startsWith("wl")) {
                    type = "wifi";
                    online = true;
                } else if (hardware.startsWith("en")) {
                    type = "ethernet";
                    online = true;
                } else {
                    type = "none";
                    online = false;
                }
            }
        }
    }

    Timer {
        id: debounceTimer
        interval: 800
        repeat: false

        onTriggered: {
            refreshNetworkState();
        }
    }

    Process {
        id: events
        command: ["ip", "monitor", "link"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                console.log("Network event detected:", data);

                debounceTimer.start();
            }
        }
    }
}
