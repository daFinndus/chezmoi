import QtQuick

import qs.singletons
import qs.components

Popup {
    id: root

    contentComponent: Column {
        id: rootColumn

        width: 172

        Row {
            width: rootColumn.width

            KeyValueRow {
                label: "Battery"
                description: Battery.status
                value: Battery.percentage + "%"
            }
        }
    }
}
