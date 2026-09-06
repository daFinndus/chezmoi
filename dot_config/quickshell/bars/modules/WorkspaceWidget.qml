import QtQuick
import Quickshell.Hyprland

import qs.singletons
import qs.bars.components

Widget {
    id: root

    property string accent: Colors.color7

    width: row.implicitWidth
    height: Themes.barHeight

    text: ""

    Row {
        id: row

        anchors.fill: parent

        padding: Themes.paddingSize * 0.5

        Repeater {
            model: Hyprland.workspaces

            delegate: Rectangle {
                property var workspace: modelData

                width: text.implicitWidth + 16
                height: Themes.barHeight

                anchors.verticalCenter: parent.verticalCenter

                color: "transparent"

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent

                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onClicked: workspace.activate()
                }

                Text {
                    id: text

                    anchors.centerIn: parent

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter

                    text: Themes.iconMode ? workspace.focused ? "\uf0c8" : workspace.id : workspace.id

                    font.family: Themes.fontFamily
                    font.pixelSize: Themes.fontSize

                    color: workspace.focused ? (mouseArea.containsMouse ? root.shade : root.accent) : (mouseArea.containsMouse ? Colors.color7 : root.shade)

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
