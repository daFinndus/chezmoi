import QtQuick
import Quickshell

import qs.singletons
import qs.modules.components

Entry {
    id: root

    hintergrund: Colors.color1
    farbe: Colors.color0
    inhalt: VPN.vpnActive ? VPN.vpnConnections[index].type : VPN.lastConnection

    opacity: VPN.vpnActive ? 1 : 0
    visible: opacity > 0

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
}
