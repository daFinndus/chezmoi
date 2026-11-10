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
            value: Battery.batteryDetected ? Battery.battery[root.selectedBattery].charge + "%" : ""
        }

        KeyValueRow {
            label: "Status"
            value: Battery.batteryDetected ? Battery.battery[root.selectedBattery].status : ""
        }

        Separator {}

        KeyValueRow {
            label: "Cyclecount"
            value: Battery.batteryDetected ? Battery.battery[root.selectedBattery].cycle_count : ""
        }

        KeyValueRow {
            label: "Capacity"
            value: Battery.batteryDetected ? Battery.battery[root.selectedBattery].capacity + "%" : ""
        }

        Separator {}

        KeyValueRow {
            label: "Start treshold"
            value: Battery.batteryDetected ? Battery.battery[root.selectedBattery].start_thresh + "%" : ""
        }

        KeyValueRow {
            label: "End treshold"
            value: Battery.batteryDetected ? Battery.battery[root.selectedBattery].end_thresh + "%" : ""
        }

        Separator {}

        KeyValueRow {
            label: "Available batteries"
            description: "Total amount"
            value: Battery.batteryDetected ? Battery.battery.length : ""
        }
    }
}
