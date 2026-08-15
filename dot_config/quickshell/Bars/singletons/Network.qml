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

    property string speed: Network.download + " " + Network.upload
    property bool toggler: false

    function getText() {
        if (root.type === "none") {
            return "No network";
        } else {
            return `Connected via ${root.type}`;
        }
    }

    function refreshNetworkState() {
        networkCheck.running = true;
    }

    function startIwctl() {
        startIwctl.running = true;
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

    Process {
        id: events
        command: ["ip", "monitor", "link"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                console.log("Network event detected:", data);

                debounceTimer.start();
                VPN.fetchVPN();
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

    Process {
        id: startIwctl

        command: ["kitty", "--title", "iwctl", "-e", "iwctl"]
    }

    Timer {
        id: debounceTimer
        interval: 800
        repeat: false

        onTriggered: {
            root.refreshNetworkState();
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

    Timer {
        interval: root.toggler ? 10000 : 5000

        running: true
        repeat: true

        onTriggered: root.toggler = !root.toggler
    }
}
