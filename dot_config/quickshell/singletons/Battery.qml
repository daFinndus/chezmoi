pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    // The available check is for widgets
    // The hasBattery is for keep checking for battery or nah
    property var battery: {}

    function getIcon(): string {
        if (root.battery[0].status === "Charging") {
            return "\udb80\udc84";
        } else if (root.battery[0].charge >= 100) {
            return "\udb80\udc79";
        } else if (root.battery[0].charge >= 90) {
            return "\udb80\udc82";
        } else if (root.battery[0].charge >= 80) {
            return "\udb80\udc81";
        } else if (root.battery[0].charge >= 70) {
            return "\udb80\udc80";
        } else if (root.battery[0].charge >= 60) {
            return "\udb80\udc7f";
        } else if (root.battery[0].charge >= 50) {
            return "\udb80\udc7e";
        } else if (root.battery[0].charge >= 40) {
            return "\udb80\udc7d";
        } else if (root.battery[0].charge >= 30) {
            return "\udb80\udc7c";
        } else if (root.battery[0].charge >= 20) {
            return "\udb80\udc7b";
        } else if (root.battery[0].charge >= 10) {
            return "\udb80\udc7a";
        } else if (root.battery[0].charge < 10) {
            return "\udb80\udc8e";
        }
    }

    function refreshBattery(): void {
        getData.running = true;
    }

    Process {
        id: getData

        command: [`${Globals.basePath}/scripts/battery.sh`, "all"]

        stdout: StdioCollector {
            onStreamFinished: {
                Globals.logDebug(this.text);
                root.battery = JSON.parse(this.text.trim());
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

        running: root.battery.length > 0
        repeat: true

        interval: 1000 * 60

        onTriggered: root.refreshBattery()
    }

    Component.onCompleted: root.refreshBattery()
}
