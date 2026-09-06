import QtQuick

import qs.singletons
import qs.bars.components

Widget {
    id: root

    text: "/home: " + Hardware.homeDisk + "%"
}
