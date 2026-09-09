import QtQuick

import qs.singletons
import qs.components

Popup {
    id: root

    contentComponent: Rectangle {
        id: rect

        color: Themes.background

        implicitWidth: text.width
        implicitHeight: text.height

        Text {
            id: text

            anchors.centerIn: parent

            text: "Bluetooth Widget"

            color: Themes.shade

            font.family: Themes.fontFamily
            font.pixelSize: Themes.fontSize
        }
    }
}
