import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import Quickshell.Wayland

import qs.components

PopupWindow {
    id: window

    anchor.window: desktop

    anchor.rect.x: 956
    anchor.rect.y: 1080 / 2

    Rect {
        farbe: "Test"
        inhalt: "Hallo"
    }
}
