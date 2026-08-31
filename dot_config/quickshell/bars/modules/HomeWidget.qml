import QtQuick

import qs.singletons
import qs.bars.modules.components

Widget {
    id: root

    visible: Homeassistant.available

    text: "T: " + Homeassistant.temperature + "°C" + " H: " + Homeassistant.humidity + "%"
}
