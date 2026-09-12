import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.singletons
import qs.components

Popup {
    id: root

    contentComponent: Column {
        spacing: Themes.paddingSize

        Row {
            id: row

            AnimatedImage {
                source: root.visible ? `${Globals.basePath}/assets/pictures/lucy.gif` : ""

                antialiasing: false

                width: 96
                height: 72

                playing: root.visible
            }

            Column {
                anchors.verticalCenter: parent.verticalCenter

                leftPadding: Themes.paddingSize

                Text {
                    color: Themes.shade

                    font.family: Themes.fontFamily
                    font.pixelSize: Themes.fontSize * 0.9

                    font.capitalization: Font.Capitalize

                    text: "User: " + System.username
                }

                Text {
                    color: Themes.shade

                    font.family: Themes.fontFamily
                    font.pixelSize: Themes.fontSize * 0.9

                    font.capitalization: Font.Capitalize

                    text: "Hostname: " + System.hostname
                }

                Text {
                    color: Themes.shade

                    font.family: Themes.fontFamily
                    font.pixelSize: Themes.fontSize * 0.9

                    font.capitalization: Font.Capitalize

                    text: "Uptime: " + System.uptime
                }
            }
        }

        Separator {
            margin: 0
        }

        Grid {
            id: grid

            columns: 2

            spacing: Themes.paddingSize / 2

            Repeater {
                model: Wlogout.systemFunctions
                delegate: Button {
                    required property var modelData

                    width: row.width / 2
                    height: 32

                    onClickClosePopup: true

                    text: modelData.text
                    onClick: modelData.command
                }
            }
        }
    }
}
