import QtQuick
import Quickshell
import Quickshell.Hyprland

import qs.singletons

Rectangle {
    property real padding: 8

    width: row.implicitWidth
    height: Globals.barHeight

    color: Colors.colors.background

    border.color: Colors.colors.gray
    border.width: Globals.borderWidth

    radius: 6

    Behavior on width {
        NumberAnimation {
            duration: 250
        }
    }

    Row {
        id: row

        leftPadding: parent.padding
        rightPadding: parent.padding
        
        anchors.fill: parent

        Repeater {
            model: Hyprland.workspaces

            delegate: Rectangle {
                property var workspace: modelData

                width: 32
                height: Globals.barHeight

                color: "transparent"

                Text {
                    anchors.centerIn: parent

                    text: workspace.id

                    font.family: Globals.fontFamily
                    font.pixelSize: Globals.fontSize

                    color: workspace.focused
                        ? (hover.hovered ? Colors.colors.gray : Colors.colors.cyan)
                        : (hover.hovered ? Colors.colors.gray : Colors.colors.lightgray)

                    Behavior on color {
                        ColorAnimation {
                            duration: 500
                            easing.type: Easing.OutCubic
                        }
                    }
                }

                HoverHandler {
                    id: hover
                    acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: workspace.activate()
                }

            }

        }

    }

}
