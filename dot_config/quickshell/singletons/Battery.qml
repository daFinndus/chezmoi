pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    // The available check is for widgets
    // The hasBattery is for keep checking for battery or nah
    property var battery: []

    property int selectedBattery: 0
    property bool batteryAvailable: true

    readonly property var batteryIcons: ["\udb80\udc8e", "\udb80\udc7a", "\udb80\udc7b", "\udb80\udc7c", "\udb80\udc7d", "\udb80\udc7e", "\udb80\udc7f", "\udb80\udc80", "\udb80\udc81", "\udb80\udc82", "\udb80\udc79"]
    readonly property string icon: {
        if (!root.current) {
            return "";
        } else if (root.current.status === "Charging") {
            return "\udb80\udc84";
        } else {
            return root.batteryIcons[Math.min(10, Math.floor(root.current.charge / 10))];
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
                if (this.text.length !== 0) {
                    root.battery = JSON.parse(this.text.trim());
                    Globals.logDebug("Battery length is now: " + root.battery.length);
                } else {
                    root.batteryAvailable = false;
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

    Timer {
        id: refreshBattery

        running: root.batteryAvailable
        repeat: true

        interval: 1000 * 30

        onTriggered: root.refreshBattery()
    }

    Component.onCompleted: root.refreshBattery()
}
