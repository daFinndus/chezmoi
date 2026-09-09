import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Wayland

import qs.singletons
import qs.components

Popup {
    id: root

    contentComponent: Column {
        id: rootColumn

        width: 256
        spacing: Themes.paddingSize

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: Themes.paddingSize

            Button {
                width: 32
                height: 32

                iconSize: 20

                text: "\udb81\udcae"
                command: "playerctl previous"
            }

            Button {
                width: 32
                height: 32

                iconSize: 20

                text: "\udb81\udc0e"
                command: "playerctl play-pause"
            }

            Button {
                width: 32
                height: 32

                iconSize: 20

                text: "\udb81\udcad"
                command: "playerctl next"
            }
        }

        Separator {}

        Column {
            spacing: Themes.paddingSize

            RowLayout {
                width: rootColumn.width

                Text {
                    font.family: Themes.fontFamily
                    font.pixelSize: Themes.fontSize * 0.7
                    font.capitalization: Font.AllUppercase

                    color: Themes.shade

                    text: "Output"
                }

                Item {
                    Layout.fillWidth: true
                }

                Text {
                    font.family: Themes.fontFamily
                    font.pixelSize: Themes.fontSize * 0.7
                    font.capitalization: Font.AllUppercase

                    color: Themes.shade

                    text: Volume.volume + "%"
                }
            }

            Slider {
                from: 0.0
                to: 100.0

                stepSize: 5.0

                value: Volume.volume

                onMoved: Volume.setVolume(value)
            }
        }
    }
}
