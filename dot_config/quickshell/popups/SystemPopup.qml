import QtQuick
import QtQuick.Layouts

import qs.singletons
import qs.components

Popup {
    id: root

    contentComponent: Column {
        Row {
            padding: Themes.paddingSize

            Column {
                Text {
                    color: Colors.color7

                    font.family: Themes.fontFamily
                    font.pixelSize: Themes.fontSize

                    font.capitalization: Font.Capitalize

                    text: "System Monitor"
                }

                Text {
                    topPadding: 2

                    color: Colors.color7
                    opacity: 0.5

                    font.family: Themes.fontFamily
                    font.pixelSize: Themes.fontSize * 0.7

                    font.capitalization: Font.Capitalize

                    text: "Uptime: " + System.uptime
                }
            }

            spacing: 100

            Column {
                spacing: Themes.paddingSize

                Button {
                    onClickClosePopup: true

                    background: Colors.background
                    shade: Colors.color7

                    text: "\uf0ad btop"
                    command: "kitty --class kitty --title btop -e btop"
                }

                Button {
                    onClickClosePopup: true

                    background: Colors.background
                    shade: Colors.color7

                    text: "\udb83\uddf7 htop"
                    command: "kitty --class kitty --title btop -e htop"
                }
            }
        }

        // Horizontal separator
        Rectangle {
            width: parent.implicitWidth
            height: 1

            color: Colors.color7
        }

        RowLayout {
            id: cpuSection

            width: parent.implicitWidth

            Text {

                padding: Themes.paddingSize

                color: Colors.color7

                font.family: Themes.fontFamily
                font.pixelSize: Themes.fontSize * 0.7

                font.capitalization: Font.AllUppercase

                text: "CPU Load"
            }

            Item {
                Layout.fillWidth: true
            }

            Text {

                padding: Themes.paddingSize

                color: Colors.color7

                font.family: Themes.fontFamily
                font.pixelSize: Themes.fontSize * 0.7

                font.capitalization: Font.AllUppercase

                text: Hardware.loadCPU + "%"
            }
        }

        // Horizontal separator
        Rectangle {
            width: parent.implicitWidth
            height: 1

            color: Colors.color7
        }

        RowLayout {
            id: gpuSection

            width: parent.implicitWidth

            Text {

                padding: Themes.paddingSize

                color: Colors.color7

                font.family: Themes.fontFamily
                font.pixelSize: Themes.fontSize * 0.7

                font.capitalization: Font.AllUppercase

                text: "GPU Load"
            }

            Item {
                Layout.fillWidth: true
            }

            Text {

                padding: Themes.paddingSize

                color: Colors.color7

                font.family: Themes.fontFamily
                font.pixelSize: Themes.fontSize * 0.7

                font.capitalization: Font.AllUppercase

                text: Hardware.loadGPU + "%"
            }
        }

        // Horizontal separator
        Rectangle {
            width: parent.implicitWidth
            height: 1

            color: Colors.color7
        }

        RowLayout {
            id: ramSection

            width: parent.implicitWidth

            Text {

                padding: Themes.paddingSize

                color: Colors.color7

                font.family: Themes.fontFamily
                font.pixelSize: Themes.fontSize * 0.7

                font.capitalization: Font.AllUppercase

                text: "RAM Load"
            }

            Item {
                Layout.fillWidth: true
            }

            Text {

                padding: Themes.paddingSize

                color: Colors.color7

                font.family: Themes.fontFamily
                font.pixelSize: Themes.fontSize * 0.7

                font.capitalization: Font.AllUppercase

                text: Hardware.loadRAM + "%"
            }
        }
    }
}
