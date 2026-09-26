import QtQuick
import Quickshell
import QtQuick.Layouts

import qs.singletons
import qs.components

Popup {
    id: root

    onVisibleChanged: if (!root.visible) {
        Network.stopWirelessNetworkScan();
    }

    contentComponent: Column {
        id: rootColumn

        property bool displaySpeedInBits: true

        width: 256
        spacing: Themes.paddingSize

        OneLiner {
            type: "Interface"
            value: (Network.onlineState ? "Online: " : "Offline: ") + Network.interfaceTitle
        }

        OneLiner {
            type: "Type"
            value: Network.interfaceType
        }

        Column {
            width: rootColumn.width
            visible: Network.onlineState

            spacing: Themes.paddingSize

            Separator {}

            OneLiner {
                type: "IP Address"
                value: Network.ipAddress
            }

            OneLiner {
                type: "Gateway"
                value: Network.gatewayAddress
            }

            OneLiner {
                type: "DNS"
                value: Network.dnsAddress
            }

            Row {
                id: dnsRow

                topPadding: 4
                spacing: 8

                DnsButton {
                    dnsTitle: "Cloudflare"
                    dnsAddress: "1.1.1.1"
                }

                DnsButton {
                    dnsTitle: "Google"
                    dnsAddress: "8.8.8.8"
                }

                DnsButton {
                    dnsTitle: "Pi-hole"
                    dnsAddress: "192.168.178.73"
                }
            }

            Column {
                visible: Network.maximumUploadSpeed !== 0
                width: rootColumn.width

                spacing: Themes.paddingSize

                Separator {}

                SpeedSection {
                    title: "Download"

                    absoluteSpeed: Network.downloadSpeed
                    maximumSpeed: Network.maximumDownloadSpeed
                }

                SpeedSection {
                    title: "Upload"

                    absoluteSpeed: Network.uploadSpeed
                    maximumSpeed: Network.maximumUploadSpeed
                }

                Item {
                    width: rootColumn.width
                    height: 4
                }

                Row {
                    width: rootColumn.width
                    spacing: Themes.paddingSize

                    Button {
                        text: "Refetch ISP"

                        width: (rootColumn.width - Themes.paddingSize) / 2
                        height: 32

                        onClick: () => Network.fetchMaximumSpeeds()
                    }

                    Button {
                        text: rootColumn.displaySpeedInBits ? "Displaying Bits" : "Displaying Bytes"

                        width: (rootColumn.width - Themes.paddingSize) / 2
                        height: 32

                        onClick: () => rootColumn.displaySpeedInBits = !rootColumn.displaySpeedInBits
                    }
                }
            }

            Column {
                visible: Network.wirelessNetworks.length > 0

                width: rootColumn.width

                Separator {}

                Flickable {
                    id: flickableArea

                    property int visibleNetworks: 6

                    width: rootColumn.width
                    height: ((32 + Themes.paddingSize) * flickableArea.visibleNetworks)

                    contentWidth: rootColumn.width
                    contentHeight: wirelessNetworksColumn.height

                    clip: true

                    Column {
                        id: wirelessNetworksColumn

                        width: rootColumn.width

                        spacing: Themes.paddingSize
                        topPadding: Themes.paddingSize

                        Repeater {
                            model: Network.wirelessNetworks
                            delegate: WiFiButton {
                                required property var modelData
                            }
                        }
                    }

                    WheelHandler {
                        onWheel: event => {
                            flickableArea.contentY = Math.max(0, Math.min(flickableArea.contentHeight - flickableArea.height, flickableArea.contentY - event.angleDelta.y));
                        }
                    }
                }
            }
        }

        Timer {
            id: fetchWirelessNetworks

            running: root.visible
            repeat: true

            interval: 10000
            onTriggered: Network.fetchWirelessNetworks()
        }

        Component.onCompleted: Network.fetchWirelessNetworks()
    }

    component OneLiner: RowLayout {
        id: oneLiner

        required property string type
        required property string value

        width: parent.width
        visible: oneLiner.value != ""

        Text {
            font.family: Themes.fontFamily
            font.pixelSize: Themes.fontSize * 0.7
            font.capitalization: Font.AllUppercase

            color: Themes.shade

            text: oneLiner.type
        }

        Item {
            Layout.fillWidth: true
        }

        Text {
            font.family: Themes.fontFamily
            font.pixelSize: Themes.fontSize * 0.7

            color: Themes.shade

            text: oneLiner.value
        }
    }

    component SpeedSection: Column {
        id: speedSection

        property double margin: Themes.paddingSize
        property double barMargin: Themes.paddingSize * 2

        spacing: speedSection.margin

        // Speedbased information
        required property string title

        required property int absoluteSpeed
        required property int maximumSpeed

        width: rootColumn.width

        RowLayout {
            width: parent.width

            Text {
                color: Themes.shade

                font.family: Themes.fontFamily
                font.pixelSize: Themes.fontSize * 0.7

                text: speedSection.title
            }

            Item {
                Layout.fillWidth: true
            }

            Text {
                color: Themes.shade

                font.family: Themes.fontFamily
                font.pixelSize: Themes.fontSize * 0.7

                text: Globals.formatNetworkSpeed(speedSection.absoluteSpeed, rootColumn.displaySpeedInBits) + " of " + Globals.formatNetworkSpeed(speedSection.maximumSpeed, rootColumn.displaySpeedInBits)
            }
        }

        Bar {
            minimumValue: 0.0
            maximumValue: speedSection.maximumSpeed
            actualValue: speedSection.absoluteSpeed
        }
    }

    component DnsButton: Button {
        id: dnsButton

        required property string dnsTitle
        required property string dnsAddress

        width: (rootColumn.width / 3) - ((dnsRow.spacing * 2) / 3)
        height: 32

        text: dnsButton.dnsTitle
        active: Network.dnsAddress === dnsButton.dnsAddress
        onClick: () => Network.changeDNS(dnsButton.dnsAddress)
    }

    component WiFiButton: Rectangle {
        id: wifiButton

        width: rootColumn.width
        height: 32

        property color background: "transparent"
        property color shade: Themes.shade

        // This has to be done, so if the background values change
        // E.g. through file parsing, the values in the components are updated
        Connections {
            target: Themes

            function onShadeChanged() {
                Globals.setColor(wifiButton, wifiButton.active, mouseArea.containsMouse);
            }
        }

        property bool active: Network.activeWirelessNetwork === modelData.ssid.trim()

        onActiveChanged: Globals.setColor(wifiButton, wifiButton.active, mouseArea.containsMouse)

        // Border color is darker than text color
        border.color: Qt.rgba(wifiButton.shade.r, wifiButton.shade.g, wifiButton.shade.b, 0.25)
        border.width: 1

        radius: Themes.borderRadius

        color: wifiButton.background

        Behavior on color {
            ColorAnimation {
                duration: Themes.animationDuration
                easing.type: Easing.OutCubic
            }
        }

        RowLayout {
            width: parent.width
            height: 32

            spacing: Themes.paddingSize

            Text {
                font.family: Themes.fontFamily
                font.pixelSize: Themes.fontSize * 0.7

                text: modelData.ssid.trim()
                color: wifiButton.shade

                leftPadding: Themes.paddingSize

                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

                Behavior on color {
                    ColorAnimation {
                        duration: Themes.animationDuration
                        easing.type: Easing.OutCubic
                    }
                }
            }

            Text {
                font.family: Themes.fontFamily
                font.pixelSize: Themes.fontSize * 0.7

                text: (modelData.strength.trim() / 100) + " dBm"
                color: wifiButton.shade

                rightPadding: Themes.paddingSize

                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

                Behavior on color {
                    ColorAnimation {
                        duration: Themes.animationDuration
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }

        MouseArea {
            id: mouseArea

            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor

            hoverEnabled: true
            onHoveredChanged: Globals.setColor(wifiButton, wifiButton.active, mouseArea.containsMouse)

            onClicked: () => Network.connectWirelessNetwork(modelData.ssid.trim())
        }
    }
}
