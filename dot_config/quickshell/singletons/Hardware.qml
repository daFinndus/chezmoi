pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string loadCPU: "5"
    property string tempCPU: "62"

    property string loadGPU: "15"
    property string tempGPU: "46"

    property string loadRAM: "23"

    property string rootDisk: "50"
    property string homeDisk: "34"

    Process {
        id: fetchCPU

        command: [`${Globals.barsPath}/scripts/hardware.sh`, "cpu"]

        stdout: StdioCollector {
            onStreamFinished: {
                const parsed = JSON.parse(this.text.trim());

                root.loadCPU = parsed.load || "5";
                root.tempCPU = parsed.temp || "62";
            }
        }
    }

    Process {
        id: fetchGPU

        command: [`${Globals.barsPath}/scripts/hardware.sh`, "gpu"]

        stdout: StdioCollector {
            onStreamFinished: {
                const parsed = JSON.parse(this.text.trim());

                root.loadGPU = parsed.load || "15";
                root.tempGPU = parsed.temp || "46";
            }
        }
    }

    Process {
        id: fetchRAM

        command: [`${Globals.barsPath}/scripts/hardware.sh`, "ram"]

        stdout: StdioCollector {
            onStreamFinished: {
                const parsed = JSON.parse(this.text.trim());

                root.loadRAM = parsed.load;
            }
        }
    }

    Process {
        id: fetchDisk

        command: [`${Globals.barsPath}/scripts/hardware.sh`, "disk"]

        stdout: StdioCollector {
            onStreamFinished: {
                const parsed = JSON.parse(this.text.trim());

                root.rootDisk = parsed.root;
                root.homeDisk = parsed.home;
            }
        }
    }

    function updateHardware() {
        fetchCPU.running = true;
        fetchGPU.running = true;
        fetchRAM.running = true;
        fetchDisk.running = true;
    }

    Timer {
        interval: 3000

        running: true
        repeat: true

        onTriggered: updateHardware()
    }
}
