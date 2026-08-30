pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Bluetooth

Singleton {
    id: root

    property var adapter: Bluetooth.defaultAdapter
    property bool enabled: root.adapter != null ? root.adapter.enabled : null

    property var deviceSelected: root.deviceCount > 0 ? Bluetooth.devices.values[root.deviceIndex] : null
    property int deviceCount: root.devices.values.length
    property int deviceIndex: 0
    property var devices: Bluetooth.devices

    function getText(containsMouse = false): string {
        if (containsMouse) {
            if (root.deviceCount <= 0) {
                return "No devices";
            } else {
                return root.deviceSelected.deviceName + ": " + root.deviceSelected.state;
            }
        } else {
            return "Bluetooth: " + (root.enabled ? "Active" : "Disabled");
        }
    }

    function toggleDevice() {
        var address = root.deviceSelected.address;
        var action = root.deviceSelected.connected ? "disconnect" : "connect";

        bluetoothAction.command = [`${Globals.barsPath}/scripts/bluetooth.sh`, `${address}`, `${action}`];
        bluetoothAction.running = true;
    }

    Process {
        id: bluetoothAction
    }

    function toggleBluetooth() {
        changeBluetooth.command = ["bluetoothctl", "power", root.enabled ? "off" : "on"];
        changeBluetooth.running = true;
    }

    Process {
        id: changeBluetooth
    }
}
