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

                    onClick: () => VPN.toggleVPN(modelData.name)

                    KeyValueRow {
                        width: parent.width - Themes.paddingSize * 2
                        anchors.centerIn: parent

                        shade: vpnButton.shade

                        label: modelData.name
                        value: modelData.active ? "up" : "down"
                        description: modelData.type
                    }
                }
            }
        }
    }
}
