import QtQuick
import Quickshell

Scope {
  id: root

  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData

      anchors.top: true
      margins.top: 10

      color: "#000000"

      implicitHeight: 30
      implicitWidth: 1900

      Item {
        property real margin: 10

        anchors.verticalCenter: parent.verticalCenter

        Text {
          font.family: "Minecraft"

          color: "#ffffff"

          x: parent.margin
          y: parent.margin

          anchors.verticalCenter: parent.verticalCenter
          text: Time.time
        }
      }
    }
  }
}
