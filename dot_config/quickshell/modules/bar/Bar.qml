import QtQuick
import Quickshell

import "../.."
import "../../colors"

Scope {
  id: root

  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData

      screen: modelData

      color: Globals.grays

      anchors.top: true
      margins.top: 10

      implicitHeight: 30
      implicitWidth: 1900

      Component.onCompleted: {
        Colors.reloadColors();
        Colors.reloadGrays();

        console.log("Globals.colors:", JSON.stringify(Globals.colors))
        console.log("Globals.grays:", JSON.stringify(Globals.grays))
      }

      Item {
        property real margin: 10

        anchors.verticalCenter: parent.verticalCenter

        Text {
          font.family: "Minecraft"

          color: Globals.grays

          x: parent.margin
          y: parent.margin

          anchors.verticalCenter: parent.verticalCenter
          text: "Test"
        }
      }
    }
  }
}
