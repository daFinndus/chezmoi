import QtQuick
import Quickshell

import qs.singletons

Rectangle {
    property real padding: 16

    width: text.width + padding * 2
    height: Globals.barHeight

    color: Colors.colors.background

    border.color: Colors.colors.gray
    border.width: Globals.borderWidth

    radius: 6

    Behavior on width {
        NumberAnimation {
            duration: 250
        }
    }

    function getColor() {
        if (Network.online) {
            return Colors.colors.green
        } else {
            return Colors.colors.red
        }
    }

    function getText() {
        if (Network.type === "none") {
            return "No network"
        } else {
            return `Connected via ${Network.type}`
        }
    }

    Text {
        id: text

        font.family: Globals.fontFamily
        font.pixelSize: Globals.fontSize

        color: getColor()

        x: parent.padding
        y: parent.padding

        anchors.centerIn: parent

        text: getText()
    }
}