import QtQuick
import Quickshell

pragma Singleton

Singleton {
  id: root

  readonly property string config: Qt.resolvedUrl("/home/finn/.config/quickshell")
  readonly property var colors: Colors.colors.colors
}