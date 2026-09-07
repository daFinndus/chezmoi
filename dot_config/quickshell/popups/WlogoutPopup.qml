import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.singletons
import qs.components

Popup {
    id: root

    contentComponent: Column {
        Row {
            id: row

            padding: Themes.paddingSize

            AnimatedImage {
                source: root.visible ? `${Globals.basePath}/assets/pictures/lucy.gif` : ""

                antialiasing: false

                width: 72
                height: 72

                playing: root.visible
            }

            Column {
                anchors.verticalCenter: parent.verticalCenter

                leftPadding: Themes.paddingSize

                Text {
                    color: Colors.color7

                    font.family: Themes.fontFamily
                    font.pixelSize: Themes.fontSize * 0.9

                    font.capitalization: Font.Capitalize

                    text: "User: " + System.username
                }

                Text {
                    color: Colors.color7

                    font.family: Themes.fontFamily
                    font.pixelSize: Themes.fontSize * 0.9

                    font.capitalization: Font.Capitalize

                    text: "Hostname: " + System.hostname
                }

                Text {
                    color: Colors.color7

                    font.family: Themes.fontFamily
                    font.pixelSize: Themes.fontSize * 0.9

                    font.capitalization: Font.Capitalize

                    text: "Uptime: " + System.uptime
                }
            }
        }

        // Horizontal separator
        Rectangle {
            width: parent.implicitWidth
            height: 1

            color: Colors.color7
        }

        Grid {
            id: grid

            columns: 2

            padding: Themes.paddingSize
            spacing: Themes.paddingSize / 2

            Repeater {
                model: Wlogout.systemFunctions
                delegate: Rectangle {
                    required property var modelData

                    width: row.width / 2
                    height: 32

                    color: mouseArea.containsMouse ? Colors.color7 : "transparent"

                    border.color: Colors.color7

                    Behavior on color {
                        ColorAnimation {
                            duration: Themes.animationDuration
                            easing.type: Easing.OutCubic
                        }
                    }

                    MouseArea {
                        id: mouseArea

                        anchors.fill: parent

                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            root.available = false;
                            debounceSystemFunction.start();
                        }
                    }

                    // Wait until the wlogout menu disappears
                    // Then execute the function
                    // This is so animations are done before function execution
                    Timer {
                        id: debounceSystemFunction

                        running: false
                        interval: Themes.animationDuration

                        onTriggered: Wlogout.startSystemFunction(modelData.command)
                    }

                    Text {
                        id: text

                        font.family: Themes.fontFamily
                        font.pixelSize: Themes.fontSize

                        anchors.centerIn: parent
                        color: mouseArea.containsMouse ? Colors.color0 : Colors.color7

                        text: modelData.text

                        Behavior on color {
                            ColorAnimation {
                                duration: Themes.animationDuration
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                }
            }
        }
    }
}
