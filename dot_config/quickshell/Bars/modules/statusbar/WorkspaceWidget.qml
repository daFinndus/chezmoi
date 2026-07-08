import QtQuick
import Quickshell
import Quickshell.Hyprland

import qs.singletons

Rectangle {
    id: root

    width: row.implicitWidth
    height: statusbar.height

    color: Colors.color1

    Behavior on width {
        NumberAnimation {
            duration: Globals.animationDuration / 2
        }
    }

    Row {
        id: row

        anchors.fill: parent

        leftPadding: 4

        Repeater {
            model: Hyprland.workspaces

            delegate: Rectangle {
                property var workspace: modelData

                width: text.implicitWidth + 16
                height: Globals.barHeight

                anchors.verticalCenter: parent.verticalCenter

                color: "transparent"

                Text {
                    id: text

                    anchors.centerIn: parent

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent

                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onClicked: workspace.activate()
                    }

                    text: workspace.id

                    font.family: Globals.fontFamily
                    font.pixelSize: Globals.fontSize / 1.25

                    color: workspace.focused ? (mouseArea.containsMouse ? Colors.color3 : Colors.color6) : (mouseArea.containsMouse ? Colors.color3 : Colors.color0)

                    Behavior on color {
                        ColorAnimation {
                            duration: 500
                            easing.type: Easing.OutCubic
                        }
                    }
                }
            }
        }
    }
}
