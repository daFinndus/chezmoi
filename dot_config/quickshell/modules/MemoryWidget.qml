import QtQuick

import qs.singletons
import qs.components

Widget {
    id: root

    text: "R: " + Hardware.ramLoad + "%"
}
