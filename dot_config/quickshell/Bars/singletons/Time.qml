pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property string date: Qt.formatDateTime(clock.date, "yyyy-MM-dd")

    readonly property string fullTime: Qt.formatDateTime(clock.date, Globals.fullTime)
    readonly property string shortTime: Qt.formatDateTime(clock.date, Globals.shortTime)

    SystemClock {
        id: clock

        precision: SystemClock.Minutes
    }
}
