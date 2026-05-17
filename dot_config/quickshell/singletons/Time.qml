import QtQuick
import Quickshell
pragma Singleton

Singleton {
    id: root

    readonly property string fullTime: Qt.formatDateTime(clock.date, Globals.fullTime)
    readonly property string shortTime: Qt.formatDateTime(clock.date, Globals.shortTime)

    SystemClock {
        id: clock

        precision: SystemClock.Minutes
    }

}
