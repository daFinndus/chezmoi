import QtQuick

import qs.singletons
import qs.components

Popup {
    id: popup

    icon: Battery.icon

    visible: Battery.batteryAvailable
    onVisibleChanged: popup.visible ? Battery.fetchInterval = 3000 : Battery.fetchInterval = 1000 * 30

    contentComponent: Column {
        id: rootColumn

        width: 172
        spacing: Themes.paddingSize

        KeyValueRow {
            label: "Battery"
            value: Battery.batteryAvailable ? Battery.battery[Battery.selectedBattery].charge + "%" : ""
        }

        KeyValueRow {
            label: "Status"
            value: Battery.batteryAvailable ? Battery.battery[Battery.selectedBattery].status : ""
        }

        Separator {}

        KeyValueRow {
            label: "Power draw"
            value: Battery.batteryAvailable ? Battery.battery[Battery.selectedBattery].power_draw + " mW" : ""
        }

        Separator {}

        KeyValueRow {
            label: "Cyclecount"
            value: Battery.batteryAvailable ? Battery.battery[Battery.selectedBattery].cycle_count : ""
        }

        KeyValueRow {
            label: "Capacity"
            value: Battery.batteryAvailable ? Battery.battery[Battery.selectedBattery].capacity + "%" : ""
        }

        Separator {}

        KeyValueRow {
            label: "Start treshold"
            value: Battery.batteryAvailable ? Battery.battery[Battery.selectedBattery].start_thresh + "%" : ""
        }

        KeyValueRow {
            label: "End treshold"
            value: Battery.batteryAvailable ? Battery.battery[Battery.selectedBattery].end_thresh + "%" : ""
        }

        Separator {}

        KeyValueRow {
            label: "Available batteries"
            description: "Total amount"
            value: Battery.batteryAvailable ? Battery.battery.length : ""
        }
    }
}
