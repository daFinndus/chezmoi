import QtQuick

import qs.singletons
import qs.components

Widget {
    id: root

    text: "G: " + Hardware.loadGPU + "%" + " " + Hardware.tempGPU + "°C"
}
