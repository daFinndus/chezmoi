import QtQuick
import Quickshell

import "colors"

pragma Singleton

Singleton {
  id: root

  readonly property string config: Qt.resolvedUrl(".")

  readonly property var colors: Colors.colors
  readonly property var grays: Colors.grays

  Component.onCompleted: {
    Colors.reloadColors();
    Colors.reloadGrays();

    console.log("Globals.colors:", JSON.stringify(Colors.colors))
    console.log("Globals.grays:", JSON.stringify(Colors.grays))
  }
}
