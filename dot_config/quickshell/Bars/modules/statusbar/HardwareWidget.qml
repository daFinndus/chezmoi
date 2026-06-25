import QtQuick
import Quickshell

import qs.singletons

Text {
    font.pixelSize: Globals.fontSize / 1.25

    leftPadding: 8
    rightPadding: 8

    text: Hardware.loadCPU
    color: "#ffffff"
}
