pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    // Data about CPU
    property int cpuUsage: 5
    property int cpuTemp: 62
    property string cpuLoad: "1.15, 1.10, 1.09"

    property var cpuCores: []

    // Information about GPU
    property int gpuLoad: 15
    property int gpuTemp: 45

    // Stats about RAM
    property int ramLoad: 23
    property int ramTotal: 32703
    property int ramUsed: 7440

    property int swapLoad: 0
    property int swapTotal: 4294
    property int swapUsed: 0

    // Disk bases information
    property int rootLoad: 54
    property int rootTotal: 195723
    property int rootUsed: 98523

    // Disk bases information
    property int homeLoad: 36
    property int homeTotal: 1460248
    property int homeUsed: 498841

    Process {
        id: fetchCPU

        command: [`${Globals.basePath}/scripts/hardware.sh`, "cpu"]

        stdout: StdioCollector {
            onStreamFinished: {
                const parsed = JSON.parse(this.text.trim());

                root.cpuUsage = parseInt(parsed.usage) || 5;
                root.cpuTemp = parseInt(parsed.temp) || 62;
                root.cpuLoad = parsed.load || "1.15, 1.10, 1.09";

                root.cpuCores = parsed.cores || [];
            }
        }
    }

    Process {
        id: fetchGPU

        command: [`${Globals.basePath}/scripts/hardware.sh`, "gpu"]

        stdout: StdioCollector {
            onStreamFinished: {
                const parsed = JSON.parse(this.text.trim());

                root.gpuLoad = parseInt(parsed.usage) || 15;
                root.gpuTemp = parseInt(parsed.temp) || 46;
            }
        }
    }

    Process {
        id: fetchRAM

        command: [`${Globals.basePath}/scripts/hardware.sh`, "ram"]

        stdout: StdioCollector {
            onStreamFinished: {
                const parsed = JSON.parse(this.text.trim());

                root.ramLoad = parseInt(parsed.usage) || 23;
                root.ramTotal = parseInt(parsed.total) || 32703;
                root.ramUsed = parseInt(parsed.used) || 7440;
            }
        }
    }

    Process {
        id: fetchSwap

        command: [`${Globals.basePath}/scripts/hardware.sh`, "swap"]

        stdout: StdioCollector {
            onStreamFinished: {
                const parsed = JSON.parse(this.text.trim());

                root.swapUsage = parseInt(parsed.usage) || 0;
                root.swapTotal = parseInt(parsed.total) || 4294;
                root.swapUsed = parseInt(parsed.used) || 0;
            }
        }
    }

    Process {
        id: fetchDisk

        command: [`${Globals.basePath}/scripts/hardware.sh`, "disk"]

        stdout: StdioCollector {
            onStreamFinished: {
                const parsed = JSON.parse(this.text.trim());

                root.rootTotal = parseInt(parsed.rootTotal) || 195723;
                root.rootUsed = parseInt(parsed.rootUsed) || 98523;
                root.rootLoad = parseInt(parsed.rootLoad) || 54;

                root.homeTotal = parseInt(parsed.homeTotal) || 1460248;
                root.homeUsed = parseInt(parsed.homeUsed) || 498841;
                root.homeLoad = parseInt(parsed.homeLoad) || 36;
            }
        }
    }

    function updateHardware(): void {
        fetchCPU.running = true;
        fetchGPU.running = true;
        fetchRAM.running = true;
        fetchDisk.running = true;
    }

    Timer {
        interval: 3000

        running: true
        repeat: true

        onTriggered: root.updateHardware()
    }

    Component.onCompleted: root.updateHardware()
}
