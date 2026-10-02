pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    // The available check is for widgets
    // The hasBattery is for keep checking for battery or nah
    property bool hasBattery: true

    property int percentage: 0
    property string battery: ""
    property string status: ""
    property string estimate: ""
    property bool loading: false

    // Will return rougly amount of remaining battery life
    function getEstimate(): string {
        if (root.estimate !== "") {
            return root.estimate;
        } else {
            return root.getText();
        }
    }

    function getText(): string {
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

    function getIcon(): string {
        if (root.percentage >= 100) {
            return "\udb80\udc79";
        } else if (root.percentage >= 90) {
            return "\udb80\udc82";
        } else if (root.percentage >= 80) {
            return "\udb80\udc81";
        } else if (root.percentage >= 70) {
            return "\udb80\udc80";
        } else if (root.percentage >= 60) {
            return "\udb80\udc7f";
        } else if (root.percentage >= 50) {
            return "\udb80\udc7e";
        } else if (root.percentage >= 40) {
            return "\udb80\udc7d";
        } else if (root.percentage >= 30) {
            return "\udb80\udc7c";
        } else if (root.percentage >= 20) {
            return "\udb80\udc7b";
        } else if (root.percentage >= 10) {
            return "\udb80\udc7a";
        } else if (root.percentage == 0) {
            return "\udb80\udc8e";
        }
    }

    function refreshBattery(): void {
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

                if (root.percentage != 0) {
                    Globals.logDebug("Battery detected!");
                    root.hasBattery = true;

                    if (root.status == "Charging" || root.status == "Full") {
                        root.loading = true;
                    } else {
                        root.loading = false;
                    }
                } else {
                    Globals.logDebug("No battery detected.");
                    // root.hasBattery = false;
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

        running: root.hasBattery
        repeat: true

        interval: 1000 * 60

        onTriggered: root.refreshBattery()
    }

    Component.onCompleted: root.refreshBattery()
}
