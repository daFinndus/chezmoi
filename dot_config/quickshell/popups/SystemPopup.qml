import QtQuick
import QtQuick.Layouts

import qs.singletons
import qs.components

Popup {
    id: root

    contentComponent: Column {
        id: rootColumn

        RowLayout {
            id: headerRow

            property int minimumWidth: 312

            width: Math.max(headerRow.minimumWidth, rootColumn.width)

            spacing: 32

            Column {
                Text {
                    color: Themes.shade

                    font.family: Themes.fontFamily
                    font.pixelSize: Themes.fontSize

                    font.capitalization: Font.Capitalize

                    text: "System Monitor"
                }

                Text {
                    topPadding: 4

                    color: Qt.rgba(Themes.shade.r, Themes.shade.g, Themes.shade.b, 0.75)

                    font.family: Themes.fontFamily
                    font.pixelSize: Themes.fontSize * 0.7

                    font.capitalization: Font.Capitalize

                    text: "Uptime: " + System.uptime
                }
            }

            Item {
                Layout.fillWidth: true  // pushes button to the right
            }

            Button {
                onClickClosePopup: true

                width: 72

                text: "\uf0ad btop"
                onClick: "kitty --class kitty --title btop -e btop"
            }
        }

        Separator {}

        Section {
            title: "CPU Usage"

            percentage: Hardware.cpuUsage
            temperature: Hardware.cpuTemp

            Grid {
                id: coreGrid

                property double margin: 4

                // This property specifies the cores per line
                property int coreLines: 4

                columns: Hardware.cpuCores.length / coreGrid.coreLines
                rows: coreGrid.coreLines

                columnSpacing: coreGrid.margin
                rowSpacing: Themes.paddingSize

                onWidthChanged: rootColumn.width = Math.max(headerRow.width, coreGrid.width)

                Repeater {
                    model: Hardware.cpuCores
                    delegate: Section {
                        required property var modelData

                        // margin will set margin of title and stat
                        // barMargin will set margin of the bar
                        margin: coreGrid.margin

                        width: Math.max((headerRow.minimumWidth / (Hardware.cpuCores.length / coreGrid.coreLines)), 56)

                        title: `C${modelData.core + 1}`
                        percentage: modelData.usage
                    }
                }
            }

            Text {
                topPadding: -2

                font.family: Themes.fontFamily
                font.pixelSize: Themes.fontSize * 0.65

                color: Qt.rgba(Themes.shade.r, Themes.shade.g, Themes.shade.b, 0.5)

                text: "Load: " + Hardware.cpuLoad
            }
        }

        Separator {}

        Section {
            title: "GPU Usage"
            percentage: Hardware.gpuLoad
            temperature: Hardware.gpuTemp
        }

        Separator {}

        Section {
            title: "RAM Usage"
            percentage: Hardware.ramLoad

            // This is for showing absolute data and swapspace
            RowLayout {
                width: parent.width

                Text {
                    topPadding: -2

                    font.family: Themes.fontFamily
                    font.pixelSize: Themes.fontSize * 0.65

                    color: Qt.rgba(Themes.shade.r, Themes.shade.g, Themes.shade.b, 0.5)

                    text: "Available: " + Math.round((Hardware.ramTotal - Hardware.ramUsed) / 1000) + "GB of " + Math.floor(Hardware.ramTotal / 1000) + "GB"
                }

                Item {
                    Layout.fillWidth: true
                }

                Text {
                    topPadding: -2

                    font.family: Themes.fontFamily
                    font.pixelSize: Themes.fontSize * 0.65

                    color: Qt.rgba(Themes.shade.r, Themes.shade.g, Themes.shade.b, 0.5)

                    text: "Swap: " + Math.round(Hardware.swapUsed / 1000) + "GB of " + Math.floor(Hardware.swapTotal / 1000) + "GB"
                }
            }
        }

        Separator {}

        Section {
            title: "Root Partition Space"
            percentage: Hardware.rootLoad

            Text {
                topPadding: -2

                font.family: Themes.fontFamily
                font.pixelSize: Themes.fontSize * 0.65

                color: Qt.rgba(Themes.shade.r, Themes.shade.g, Themes.shade.b, 0.5)

                text: Math.round(Hardware.rootUsed / 1000) + "GB / " + Math.floor(Hardware.rootTotal / 1000) + "GB"
            }
        }

        Separator {}

        Section {
            title: "Home Partition Space"
            percentage: Hardware.homeLoad

            Text {
                topPadding: -2

                font.family: Themes.fontFamily
                font.pixelSize: Themes.fontSize * 0.65

                color: Qt.rgba(Themes.shade.r, Themes.shade.g, Themes.shade.b, 0.5)

                text: Math.round(Hardware.homeUsed / 1000) + "GB / " + Math.floor(Hardware.homeTotal / 1000) + "GB"
            }
        }
    }

    // This is for the hardware components
    component Section: Column {
        id: section

        property double margin: Themes.paddingSize
        property double barMargin: Themes.paddingSize * 2

        spacing: section.margin

        // Hardware based information
        required property string title
        required property int percentage
        property int temperature: 0

        width: rootColumn.width

        RowLayout {
            id: rowLayout

            width: parent.width

            Text {
                color: Themes.shade

                font.family: Themes.fontFamily
                font.pixelSize: Themes.fontSize * 0.7

                text: section.title
            }

            Item {
                Layout.fillWidth: true
            }

            Text {
                color: Themes.shade

                font.family: Themes.fontFamily
                font.pixelSize: Themes.fontSize * 0.7

                text: section.temperature != "" ? section.percentage + "% at " + section.temperature + "°C" : section.percentage + "%"
            }
        }

        Bar {
            showDanger: true
            actualValue: parseFloat(section.percentage)
        }
    }
}
