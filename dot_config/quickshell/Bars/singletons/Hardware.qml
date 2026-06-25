pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string loadCPU: ""
    property string tempCPU: ""

    property string loadGPU: ""
    property string tempGPU: ""

    property string loadRAM: ""

    property string rootDisk: ""
    property string homeDisk: ""

    Process {
        id: fetchCPU

        command: [`${Globals.configPath}/scripts/hardware.sh`, "cpu"]

        stdout: StdioCollector {
            onStreamFinished: {
                const parsed = JSON.parse(this.text.trim());

                root.loadCPU = parsed.load + "%";
                root.tempCPU = parsed.temp + "°C";
            }
        }
    }

    Process {
        id: fetchGPU

        command: [`${Globals.configPath}/scripts/hardware.sh`, "gpu"]

        stdout: StdioCollector {
            onStreamFinished: {
                const parsed = JSON.parse(this.text.trim());

                root.loadGPU = parsed.load + "%";
                root.tempGPU = parsed.temp + "°C";
            }
        }
    }

    Process {
        id: fetchRAM

        command: [`${Globals.configPath}/scripts/hardware.sh`, "ram"]

        stdout: StdioCollector {
            onStreamFinished: {
                const parsed = JSON.parse(this.text.trim());

                root.loadRAM = parsed.load + "%";
            }
        }
    }

    Process {
        id: fetchDisk

        command: [`${Globals.configPath}/scripts/hardware.sh`, "disk"]

        stdout: StdioCollector {
            onStreamFinished: {
                const parsed = JSON.parse(this.text.trim());

                root.rootDisk = parsed.root + "%";
                root.homeDisk = parsed.home + "%";
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
