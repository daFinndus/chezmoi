pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    // The available check is for widgets
    // The hasBattery is for keep checking for battery or nah
    property var battery: []
    onBatteryChanged: {
        if (root.battery.length > 0) {
            root.batteryAvailable = true;
        } else {
            root.batteryAvailable = false;
        }
    }

    property int selectedBattery: 0
    property bool batteryAvailable: false

    readonly property var batteryIcons: ["\udb80\udc8e", "\udb80\udc7a", "\udb80\udc7b", "\udb80\udc7c", "\udb80\udc7d", "\udb80\udc7e", "\udb80\udc7f", "\udb80\udc80", "\udb80\udc81", "\udb80\udc82", "\udb80\udc79"]
    readonly property string icon: {
        if (root.battery.length <= 0) {
            return "";
        } else if (root.battery[root.selectedBattery].status === "Charging") {
            return "\udb80\udc84";
        } else {
            return root.batteryIcons[Math.min(10, Math.floor(root.battery[root.selectedBattery].charge / 10))];
        }
    }

    readonly property string text: root.batteryAvailable ? `Battery at ${root.battery[root.selectedBattery].charge}%` : ""

    function refreshBattery(): void {
        getData.running = true;
    }

    Process {
        id: getData

        command: [`${Globals.basePath}/scripts/battery.sh`, "all"]

        stdout: StdioCollector {
            onStreamFinished: {
                if (this.text != "") {
                    root.battery = JSON.parse(this.text.trim());
                    Globals.logDebug("Battery length is now: " + root.battery.length);
                }
            }
        }
    }

    Process {
        id: batteryEvents

        running: root.batteryAvailable

        command: ["sudo", "tlp-stat", "-P"]

        stdout: SplitParser {
            onRead: root.refreshBattery()
        }
    }

    property int fetchInterval: 1000 * 30

    Timer {
        id: refreshBattery

        running: root.batteryAvailable
        repeat: true

        interval: root.fetchInterval

        onTriggered: root.refreshBattery()
    }

    Component.onCompleted: root.refreshBattery()
}
