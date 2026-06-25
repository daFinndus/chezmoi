import QtQuick
import Quickshell

import qs.singletons

Text {
    font.pixelSize: Globals.fontSize / 1.25
    text: Hardware.loadCPU
    color: "#ffffff"
}
