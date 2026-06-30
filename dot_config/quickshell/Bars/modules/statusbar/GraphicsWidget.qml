import QtQuick
import Quickshell

import qs.singletons
import qs.modules.components

Entry {
    id: root

    width: 80

    hintergrund: Colors.color1
    farbe: Colors.color0
    inhalt: "G: " + Hardware.loadGPU + " " + Hardware.tempGPU
}
