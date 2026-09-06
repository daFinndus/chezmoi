import QtQuick

import qs.singletons
import qs.bars.modules.components

Widget {
    id: root

    text: VPN.getText(index)

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
}
