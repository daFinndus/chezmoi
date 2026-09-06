import QtQuick

import qs.singletons
import qs.bars.components

Widget {
    id: root

    text: "G: " + Hardware.loadGPU + "%" + " " + Hardware.tempGPU + "°C"
}
