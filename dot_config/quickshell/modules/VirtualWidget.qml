import QtQuick

import qs.popups
import qs.singletons
import qs.components

Widget {
    id: root

    text: Themes.iconMode ? "\udb85\uddfc" : VPN.getText(index)

    opacity: VPN.vpnActive ? 1 : 0
    visible: root.opacity > 0

    property int index: 0

    Timer {
        interval: 1000 * 3
        running: true
        repeat: true

        onTriggered: {
            if ((root.index + 1 >= VPN.vpnConnections.length)) {
                root.index = 0;
            } else {
                root.index += 1;
            }
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: Themes.iconMode ? Globals.togglePopup(popup) : null
    }

    function togglePanel(): void {
        popup.available = !popup.available;
    }

    VirtualPopup {
        id: popup
        target: root
    }
}
