import QtQuick
import Quickshell

pragma Singleton

Singleton {
  id: root

  readonly property string time: Qt.formatDateTime(
    clock.date,
    "d. MMMM 'on a' dddd - hh:mm AP"
  )

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }
}
