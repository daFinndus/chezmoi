import QtQuick

import qs.singletons
import qs.components

Popup {
    id: root

    Timer {
        id: getBluetoothDevices

        running: root.visible
        repeat: true

        interval: 3000

        onTriggered: Bluetooth.fetchDevices()
    }

    contentComponent: Column {
        id: rootColumn

        width: 216

        Text {
            font.family: Themes.fontFamily
            font.pixelSize: Themes.fontSize * 0.7
            font.capitalization: Font.AllUppercase

            color: Themes.shade

            text: Bluetooth.adapters.length > 0 ? "Adapter: " + Bluetooth.adapters[0].address : "No adapter found"
        }

        Separator {}

        Text {
            font.family: Themes.fontFamily
            font.pixelSize: Themes.fontSize * 0.7
            font.capitalization: Font.AllUppercase

            color: Globals.withAlpha(Themes.shade, 0.25)

            topPadding: 2
            bottomPadding: 2

            text: Bluetooth.adapters.length > 0 ? "Powered: " + Bluetooth.adapters[0].powered : "No idea"
        }

        Text {
            font.family: Themes.fontFamily
            font.pixelSize: Themes.fontSize * 0.7
            font.capitalization: Font.AllUppercase

            color: Globals.withAlpha(Themes.shade, 0.25)

            topPadding: 2
            bottomPadding: 2

            text: Bluetooth.adapters.length > 0 ? "Pairable: " + Bluetooth.adapters[0].pairable : "No idea"
        }

        Text {
            font.family: Themes.fontFamily
            font.pixelSize: Themes.fontSize * 0.7
            font.capitalization: Font.AllUppercase

            color: Globals.withAlpha(Themes.shade, 0.25)

            topPadding: 2
            bottomPadding: 2

            text: Bluetooth.adapters.length > 0 ? "Discoverable: " + Bluetooth.adapters[0].discoverable : "No idea"
        }

        Column {
            width: rootColumn.width

            visible: Bluetooth.devices.filter(device => device.connected).length > 0

            Separator {}

            Section {
                title: "Connected"
                object: Bluetooth.devices.filter(device => device.connected)
            }
        }

        Column {
            width: rootColumn.width

            visible: Bluetooth.devices.filter(device => !device.connected).length > 0

            Separator {}

            Section {
                title: "Discovered"
                object: Bluetooth.devices.filter(device => !device.connected)
            }
        }
    }

    component Section: Column {
        id: section

        required property string title
        required property var object

        Text {
            font.family: Themes.fontFamily
            font.pixelSize: Themes.fontSize * 0.7
            font.capitalization: Font.AllUppercase

            color: Themes.shade

            bottomPadding: Themes.paddingSize

            text: section.title
        }

        Column {
            spacing: Themes.paddingSize

            Repeater {
                id: repeater

                model: section.object
                delegate: Button {
                    required property var modelData

                    width: rootColumn.width
                    height: 32

                    text: modelData.name
                    active: modelData.connected

                    onClick: () => Bluetooth.connectDevice(modelData.address)
                }
            }
        }
    }
}
