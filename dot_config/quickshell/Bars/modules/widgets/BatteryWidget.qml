import QtQuick
import Quickshell.Io

import qs.singletons
import qs.modules.components

Rect {
    id: root

    property int percentage: 0
    property string battery: ""
    property string status: ""
    property string estimate: ""
    property bool loading: false

    inhalt: getText()
    farbe: getColor()

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            if (root.loading) {
                if (root.inhalt == root.getEstimate()) {
                    root.inhalt = root.battery + " at: " + root.percentage + "%";
                } else {
                    root.inhalt = root.getEstimate();
                }
            }
        }

        onEntered: {
            if (root.loading) {
                root.inhalt = root.battery + " at: " + root.percentage + "%";
            } else {
                root.inhalt = root.getEstimate();
            }
        }

        onExited: root.inhalt = root.getText()
    }

    function getEstimate() {
        console.log("Estimate is:", estimate);

        if (estimate !== "") {
            return estimate;
        } else {
            return getText();
        }
    }

    function getText() {
        if (loading) {
            if (status === "Charging") {
                return "Charging...";
            } else if (status === "Full") {
                return "Fully loaded";
            }
        } else {
            return battery + " at: " + percentage + "%";
        }
    }

    function getColor() {
        if (percentage >= 80) {
            return Colors.color1;
        } else if (percentage >= 50) {
            return Colors.color2;
        } else if (percentage >= 25) {
            return Colors.color3;
        } else if (percentage >= 5) {
            return Colors.color4;
        } else {
            return Colors.color5;
        }
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

                if (status == "Charging" || status == "Full") {
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
            onRead: data => {
                console.log("Battery event detected:", data);

                getData.running = true;
            }
        }
    }

    Component.onCompleted: {
        getData.running = true;
    }
}
