import QtQuick

import qs.singletons
import qs.components

Popup {
    id: root

    contentComponent: Rectangle {
        id: rect

        color: Colors.background

        implicitWidth: text.width
        implicitHeight: text.height

        Text {
            id: text

            anchors.centerIn: parent

            text: "Network Widget"

            color: Colors.foreground

            font.family: Themes.fontFamily
            font.pixelSize: Themes.fontSize
        }
    }
}
