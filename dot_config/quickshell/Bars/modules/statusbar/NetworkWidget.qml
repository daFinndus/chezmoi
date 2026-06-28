import QtQuick
import Quickshell

import qs.singletons
import qs.modules.components

Entry {
    id: root

    hintergrund: Colors.background
    farbe: Network.online ? Colors.color1 : Colors.color6
    inhalt: Network.online ? toggler ? speed : "up: " + Network.hardware : "down: " + Network.hardware

    property string speed: Network.download + " " + Network.upload
    property bool toggler: false

    Timer {
        interval: 6000

        running: true
        repeat: true

        onTriggered: toggler = !toggler
    }
}
