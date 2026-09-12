import QtQuick
import Quickshell
import QtQuick.Layouts

import qs.singletons
import qs.components

Popup {
    id: root

    contentComponent: Column {
        id: rootColumn

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
                visible: Network.address != ""

                type: "IP Address"
                value: Network.address
            }

            OneLiner {
                visible: Network.gateway != ""

                type: "Gateway"
                value: Network.gateway
            }

            OneLiner {
                visible: Network.dns != ""

                type: "DNS"
                value: Network.dns
            }

            Separator {}

            OneLiner {
                type: "Download"
                value: Network.download
            }

            OneLiner {
                type: "Upload"
                value: Network.upload
            }
        }
    }

    component OneLiner: RowLayout {
        id: rowLayout

        required property string type
        required property string value

        width: parent.width

        Text {
            font.family: Themes.fontFamily
            font.pixelSize: Themes.fontSize * 0.7
            font.capitalization: Font.AllUppercase

            color: Themes.shade

            text: rowLayout.type
        }

        Item {
            Layout.fillWidth: true
        }

        Text {
            font.family: Themes.fontFamily
            font.pixelSize: Themes.fontSize * 0.7

            color: Themes.shade

            text: rowLayout.value
        }
    }
}
