import QtQuick

import qs.singletons
import qs.components

Widget {
    id: root

    text: "C: " + Hardware.loadCPU + "%" + " " + Hardware.tempCPU + "°C"
}
