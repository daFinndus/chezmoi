import QtQuick

import qs.singletons
import qs.components

Popup {
    id: root

    contentComponent: Column {
        id: rootColumn

        width: 172
        spacing: Themes.paddingSize

        KeyValueRow {
            label: "Battery"
            value: Battery.battery[0].charge + "%"
        }

        KeyValueRow {
            label: "Status"
            value: Battery.battery[0].status
        }

        Separator {}

        KeyValueRow {
            label: "Cyclecount"
            value: Battery.battery[0].cycle_count
        }

        KeyValueRow {
            label: "Capacity"
            value: Battery.battery[0].capacity + "%"
        }

        Separator {}

        KeyValueRow {
            label: "Start treshold"
            value: Battery.battery[0].start_thresh + "%"
        }

        KeyValueRow {
            label: "End treshold"
            value: Battery.battery[0].end_thresh + "%"
        }

        Separator {}

        KeyValueRow {
            label: "Available batteries"
            description: "Total amount"
            value: Battery.battery.length
        }
    }
}
