import QtQuick
import Quickshell

import qs.singletons
import qs.modules.components

Entry {
    id: root

    width: 80

    hintergrund: Colors.background
    farbe: Colors.color1
    inhalt: "C: " + Hardware.loadCPU + "%" + " " + Hardware.tempCPU + "°C"
}
