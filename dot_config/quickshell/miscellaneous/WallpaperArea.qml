import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

import qs.singletons

PanelWindow {
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    WlrLayershell.layer: WlrLayer.Background
    WlrLayershell.exclusiveZone: -1

    margins {
        top: Themes.paddingSize * 1.33 + Themes.barHeight
        right: Themes.paddingSize * 1.33
        bottom: Themes.paddingSize * 1.33
        left: Themes.paddingSize * 1.33
    }

    color: "transparent"

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: event => {
            if (event.button === Qt.LeftButton) {
                Selector.toggleMenu("wallpaper");
            } else if (event.button === Qt.RightButton) {
                Selector.toggleMenu("theme");
            }
        }
    }
}
