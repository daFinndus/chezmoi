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

            color: Qt.rgba(Themes.shade.r, Themes.shade.b, Themes.shade.g, 0.25)

            topPadding: 2
            bottomPadding: 2

            text: Bluetooth.adapters.length > 0 ? "Powered: " + Bluetooth.adapters[0].powered : "No idea"
        }

        Text {
            font.family: Themes.fontFamily
            font.pixelSize: Themes.fontSize * 0.7
            font.capitalization: Font.AllUppercase

            color: Qt.rgba(Themes.shade.r, Themes.shade.b, Themes.shade.g, 0.25)

            topPadding: 2
            bottomPadding: 2

            text: Bluetooth.adapters.length > 0 ? "Pairable: " + Bluetooth.adapters[0].pairable : "No idea"
        }

        Text {
            font.family: Themes.fontFamily
            font.pixelSize: Themes.fontSize * 0.7
            font.capitalization: Font.AllUppercase

            color: Qt.rgba(Themes.shade.r, Themes.shade.b, Themes.shade.g, 0.25)

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
                delegate: Device {
                    required property var modelData

                    text: modelData.name
                    onClick: () => Bluetooth.connectDevice(modelData.address)

                    connected: modelData.connected
                }
            }
        }
    }

    component Device: Rectangle {
        id: device

        required property string text
        required property var onClick

        required property bool connected

        onConnectedChanged: device.setColor(mouseArea.containsMouse)

        property color background: device.connected ? Themes.shade : Themes.background
        property color shade: device.connected ? Themes.background : Themes.shade

        // This is for giving color based on default color, active state, and hover
        function setColor(inverted: bool): void {
            if (!device.connected) {
                if (inverted) {
                    device.background = Themes.shade;
                    device.shade = Themes.background;
                    device.border.width = 0;
                } else {
                    device.background = Themes.background;
                    device.shade = Themes.shade;
                    device.border.width = 1;
                }
            }
        }

        width: rootColumn.width
        height: 32

        color: device.background

        border.color: Themes.shade
        border.width: device.connected ? 0 : 1

        MouseArea {
            id: mouseArea

            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor

            hoverEnabled: true
            onHoveredChanged: device.setColor(mouseArea.containsMouse)

            onClicked: device.onClick()
        }

        Text {
            font.family: Themes.fontFamily
            font.pixelSize: Themes.fontSize * 0.7

            text: device.text
            color: device.shade

            anchors.centerIn: parent

            Behavior on color {
                ColorAnimation {
                    duration: Themes.animationDuration
                    easing.type: Easing.OutCubic
                }
            }
        }
    }
}
