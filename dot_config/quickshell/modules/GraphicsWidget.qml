import QtQuick

import qs.singletons
import qs.components

Widget {
    id: root

    text: "G: " + Hardware.gpuLoad + "%" + " " + Hardware.gpuTemp + "°C"
}
