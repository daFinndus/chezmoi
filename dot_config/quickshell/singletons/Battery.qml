pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool available: false

    property int percentage: 0
    property string battery: ""
    property string status: ""
    property string estimate: ""
    property bool loading: false

    function getEstimate() {
        if (root.estimate !== "") {
            return root.estimate;
        } else {
            return root.getText();
        }
    }

    function getText() {
        if (root.loading) {
            if (root.status === "Charging") {
                return "Charging...";
            } else if (root.status === "Full") {
                return "Fully loaded";
            }
        } else {
            return root.battery + " at: " + root.percentage + "%";
        }
    }

    function refreshBattery() {
        getData.running = true;
    }

    Process {
        id: getData

        command: ["acpi"]

        stdout: StdioCollector {
            onStreamFinished: {
                const parts = this.text.split(",");
                const teile = parts[0].split(":");

                root.battery = teile[0].trim();
                root.status = teile[1].trim();
                root.percentage = parts[1].replace("%", "").trim();
                root.estimate = parts[2]?.trim() || "";

                if (root.status == "Charging" || root.status == "Full") {
                    root.loading = true;
                } else {
                    root.loading = false;
                }
            }
        }
    }

    Process {
        id: batteryEvents

        running: true

        command: ["inotifywait", "-m", "/sys/class/power_supply/BAT0/capacity"]

        stdout: SplitParser {
            onRead: root.refreshBattery()
        }
    }

    Timer {
        id: refreshBattery

        running: true
        repeat: true

        interval: 1000 * 60

        onTriggered: root.refreshBattery()
    }
}
