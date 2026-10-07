import QtQuick

import qs.singletons
import qs.components

Popup {
    id: root

    onVisibleChanged: {
        if (root.visible) {
            // Only fetch maximum speeds when not already fetched
            // Otherwise they have to be triggered actively
            if (!Network.fetchedISP) {
                Network.fetchMaximumSpeeds();
            }
        } else {
            Network.stopWirelessNetworkScan();
        }
    }

    contentComponent: Column {
        id: rootColumn

        property bool displaySpeedInBits: true

        width: 256
        spacing: Themes.paddingSize

        KeyValueRow {
            label: "Interface"
            value: Network.onlineState ? "Online: " + Network.interfaceTitle : "Offline"
        }

        KeyValueRow {
            label: "Type"
            value: Network.interfaceType
        }

        Column {
            width: rootColumn.width
            visible: Network.onlineState

            spacing: Themes.paddingSize

            Separator {}

            KeyValueRow {
                label: "IP Address"
                value: Network.ipAddress
            }

            KeyValueRow {
                label: "Gateway"
                value: Network.gatewayAddress
            }

            KeyValueRow {
                label: "DNS"
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

        KeyValueRow {
            label: speedSection.title
            value: Globals.formatNetworkSpeed(speedSection.absoluteSpeed, rootColumn.displaySpeedInBits) + " of " + Globals.formatNetworkSpeed(speedSection.maximumSpeed, rootColumn.displaySpeedInBits)
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

    component WiFiButton: Button {
        id: wifiButton

        width: rootColumn.width
        height: 32

        active: modelData.ssid.trim() === Network.activeWirelessNetwork

        onClick: () => Network.connectWirelessNetwork(modelData.ssid.trim())

        KeyValueRow {
            width: parent.width - Themes.paddingSize * 2
            anchors.centerIn: parent

            shade: wifiButton.shade

            label: modelData.ssid.trim()
            value: (modelData.strength.trim() / 100) + " dBm"

            description: "Security: " + modelData.security
        }
    }
}
