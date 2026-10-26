import QtQuick
import Quickshell.Io

import qs.singletons
import qs.components

Popup {
    id: root

    contentComponent: Rectangle {
        id: rect

        color: "transparent"

        implicitWidth: column.width
        implicitHeight: column.height

        Column {
            id: column

            spacing: Themes.paddingSize

            Repeater {
                model: VPN.vpnConnections
                delegate: Button {
                    id: vpnButton

                    required property var modelData

                    active: modelData.active

                    width: 256
                    height: 32

                    onClick: () => modelData.active ? VPN.killVPN(modelData.provider, modelData.config) : VPN.connectVPN(modelData.provider, modelData.config)

                    KeyValueRow {
                        width: parent.width - Themes.paddingSize * 2
                        anchors.centerIn: parent

                        shade: vpnButton.shade

                        label: modelData.provider
                        value: modelData.active ? (modelData.address != "" ? modelData.address : "up") : "down"
                        description: modelData.network
                    }
                }
            }
        }
    }
}
