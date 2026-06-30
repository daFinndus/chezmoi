import QtQuick
import Quickshell

import qs.singletons
import qs.modules.components

Entry {
    id: root

    hintergrund: Colors.color1
    farbe: Colors.color0
    inhalt: "/: " + Hardware.rootDisk
}
