import QtQuick
import Quickshell

import qs.singletons
import qs.modules.components

Entry {
    id: root

    hintergrund: Colors.color0
    farbe: Colors.color1
    inhalt: "R: " + Hardware.loadRAM
}
