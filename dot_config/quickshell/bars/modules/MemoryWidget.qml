import QtQuick

import qs.singletons
import qs.bars.modules.components

Widget {
    id: root

    text: "R: " + Hardware.loadRAM + "%"
}
