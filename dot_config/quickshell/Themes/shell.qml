import QtQuick
import Quickshell

import qs.modules

Scope {
    PanelWindow {
        id: desktop

        property int margin: 512

        color: "transparent"

        anchors.top: true
        margins.top: margin

        implicitHeight: themes.height
        implicitWidth: 956

        Themes {
            id: themes
        }
    }
}
