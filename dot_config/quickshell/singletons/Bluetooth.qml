pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property var adapters: []
    property bool adapterScanning: false
    property bool adapterEnabled: root.adapter != null ? root.adapter.enabled : false

    property int deviceIndex: 0
    property var devices: []

    // This is only used in non-icon themes
    function getText(): string {
        return root.devices.length <= 0 ? "No devices" : root.devices[root.deviceIndex].name + ": " + root.devices[root.deviceIndex].battery;
    }

    // Universal bluetooth function handler
    Process {
        id: bluetoothAction

        stdout: StdioCollector {
            onStreamFinished: {
                Globals.logDebug("Just ran: " + bluetoothAction.command + ".");
                Globals.logDebug("Output: " + this.text.trim());
            }
        }
    }

    // =================== Adapter ====================
    //
    //
    //
    // These are all adapter-based functions
    function toggleAdapter(): void {
        bluetoothAction.command = ["bluetoothctl", "power", root.adapterEnabled ? "off" : "on"];
        bluetoothAction.running = true;
    }

    function fetchAdapters(): void {
        getAdapters.running = true;
    }

    function setAdapterProperty(property: string, value: string): void {
        bluetoothAction.command = ["bluetoothctl", property, value];
        bluetoothAction.running = true;
    }

    Process {
        id: getAdapters

        running: true
        command: ["bash", "-c", `bluetoothctl show | jc --bluetoothctl | jq`]

        stdout: StdioCollector {
            onStreamFinished: {
                root.adapters = JSON.parse(this.text.trim());
            }
        }
    }

    // =================== Devices ====================
    //
    //
    //
    // These functions shall be used for connecting to devices
    function fetchDevices(): void {
        getDevices.running = true;
    }

    Process {
        id: getDevices
        command: ["bash", "-c", `${Globals.basePath}/scripts/bluetooth.sh`]

        stdout: StdioCollector {
            onStreamFinished: {
                root.devices = JSON.parse(this.text.trim());
                Globals.logDebug("Found bluetoothdevices: " + root.devices.length);
            }
        }
    }

    // This will only remove the device from the singleton object
    // This is so no dupes are created after connections are made
    function removeDevice(mac: string): void {
        root.devices = root.devices.filter(device => device.address !== mac);
    }

    function connectDevice(mac: string): void {
        Globals.logDebug("Going to connect to: " + mac);

        bluetoothAction.command = ["bluetoothctl", "connect", `${mac}`];
        bluetoothAction.running = true;

        root.removeDevice(mac);

        root.fetchDevices();
    }

    Component.onCompleted: {
        root.fetchAdapters();
        root.fetchDevices();
    }
}
