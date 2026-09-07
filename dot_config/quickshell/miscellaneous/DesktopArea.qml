import QtQuick
import Quickshell
import Quickshell.Io

import qs.singletons

PanelWindow {
    id: desktop

    implicitWidth: Screen.width
    implicitHeight: Screen.height - Themes.barHeight

    color: "transparent"

    visible: Globals.activePopup !== null

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        onClicked: {
            Globals.logDebug("Clicked desktop mouse area!");
            Globals.closePopup();
        }
    }
}
