import QtQuick
import Quickshell

import qs.singletons

Text {
    font.pixelSize: Globals.fontSize / 1.25
    text: Network.online ? "up: " + Network.hardware : "down: " + Network.hardware
    color: Network.online ? "#00ff00" : "#ff0000"
}
