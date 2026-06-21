pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property string fullTime: Qt.formatDateTime(clock.date, Globals.fullTime)
    readonly property string shortTime: Qt.formatDateTime(clock.date, Globals.shortTime)

    SystemClock {
        id: clock

        precision: SystemClock.Minutes
    }

    property string date: ""

    Process {
        id: date

        command: ["bash", "-c", `timedatectl | grep "Local time" | awk '{print $4}'`]

        stdout: StdioCollector {
            onStreamFinished: {
                root.date = this.text.trim();
            }
        }
    }

    Component.onCompleted: {
        date.running = true;
    }
}
