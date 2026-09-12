pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    readonly property string date: Qt.formatDateTime(clock.date, "dd.MM.yyyy")
    readonly property string day: Qt.formatDateTime(clock.date, "dddd hh:mm")

    readonly property string fullTime: Qt.formatDateTime(clock.date, Globals.fullTime)
    readonly property string shortTime: Qt.formatDateTime(clock.date, Globals.shortTime)

    SystemClock {
        id: clock

        precision: SystemClock.Minutes
    }
}
