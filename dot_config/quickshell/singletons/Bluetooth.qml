pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property var adapters: []
    readonly property bool adapterEnabled: root.adapters.length > 0 && root.adapters[0].powered === true

    property int deviceIndex: 0
    property var devices: []

    // This is only used in non-icon themes
    function getText(): string {
        if (root.devices.length === 0) {
            return "No devices";
        }

        const index = Math.min(root.deviceIndex, root.devices.length - 1);
        return root.devices[index].name + ": " + root.devices[index].battery;
    }

    // Universal bluetooth function handler
    Process {
        id: bluetoothAction

        stdout: StdioCollector {
            onStreamFinished: {
                //
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

    Process {
        id: getAdapters

        running: true
        command: ["bash", "-c", `bluetoothctl show | jc --bluetoothctl | jq`]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.adapters = JSON.parse(this.text.trim());
                } catch (error) {
                    Globals.logError("Bluetooth adapter parsing failed: " + error);
                    root.adapters = [];
                }
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
                try {
                    root.devices = JSON.parse(this.text.trim());
                } catch (error) {
                    Globals.logError("Bluetooth device parsing failed: " + error);
                    root.devices = [];
                }
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
