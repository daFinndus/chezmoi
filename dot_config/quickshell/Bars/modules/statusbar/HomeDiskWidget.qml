import QtQuick
import Quickshell

import qs.singletons
import qs.modules.components

Entry {
    id: root

    hintergrund: Colors.background
    farbe: Colors.color1
    inhalt: "/home: " + Hardware.homeDisk
}
