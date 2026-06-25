pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string type: "none"
    property string hardware: ""
    property bool online: false

    property string download: "dl: 0 B/s"
    property string upload: "ul: 0 B/s"

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

    Process {
        id: fetchSpeed

        command: [`${Globals.configPath}/scripts/hardware.sh`, "net", root.hardware]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const parsed = JSON.parse(this.text.trim());

                    root.download = "dl: " + parsed.rx;
                    root.upload = "ul: " + parsed.tx;
                } catch (e) {
                    console.error("Net speed parse failed:", this.text.trim());
                }
            }
        }
    }

    Timer {
        interval: 3000

        running: true
        repeat: true

        onTriggered: {
            if (root.online && root.hardware !== "" && !fetchSpeed.running) {
                fetchSpeed.running = true;
            }
        }
    }
}
