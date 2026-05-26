import QtQuick
import Quickshell

import qs.singletons
import qs.modules.components

Rect {
    farbe: getColor()
    inhalt: getText()

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
}