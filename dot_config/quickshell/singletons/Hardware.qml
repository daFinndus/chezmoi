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
    property real ramTotal: 32703
    property real ramUsed: 7440

    property real swapTotal: 4294
    property real swapUsed: 0

    // Disk bases information
    property int rootLoad: 54
    property real rootTotal: 195723
    property real rootUsed: 98523

    // Disk bases information
    property int homeLoad: 36
    property real homeTotal: 1460248
    property real homeUsed: 498841

    Process {
        id: fetchHardware

        command: [`${Globals.basePath}/scripts/hardware.sh`, "all"]

        stdout: StdioCollector {
            onStreamFinished: {
                const parsed = JSON.parse(this.text.trim());

                root.cpuUsage = Globals.numberOr(parsed.cpu.usage, 5);
                root.cpuTemp = Globals.numberOr(parsed.cpu.temp, 62);
                root.cpuLoad = parsed.cpu.load || "1.15, 1.10, 1.09";
                root.cpuCores = parsed.cpu.cores || [];

                root.gpuLoad = Globals.numberOr(parsed.gpu.load, 15);
                root.gpuTemp = Globals.numberOr(parsed.gpu.temp, 46);
                root.ramLoad = Globals.numberOr(parsed.ram.load, 23);
                root.ramTotal = Globals.numberOr(parsed.ram.total, 32703);
                root.ramUsed = Globals.numberOr(parsed.ram.used, 7440);
                root.swapTotal = Globals.numberOr(parsed.swap.total, 4294);
                root.swapUsed = Globals.numberOr(parsed.swap.used, 0);

                root.rootTotal = Globals.numberOr(parsed.disk.rootTotal, 195723);
                root.rootUsed = Globals.numberOr(parsed.disk.rootUsed, 98523);
                root.rootLoad = Globals.numberOr(parsed.disk.rootLoad, 54);
                root.homeTotal = Globals.numberOr(parsed.disk.homeTotal, 1460248);
                root.homeUsed = Globals.numberOr(parsed.disk.homeUsed, 498841);
                root.homeLoad = Globals.numberOr(parsed.disk.homeLoad, 36);
            }
        }
    }

    function updateHardware(): void {
        fetchHardware.running = true;
    }

    Timer {
        interval: 3000

        running: true
        repeat: true

        onTriggered: root.updateHardware()
    }

    Component.onCompleted: root.updateHardware()
}
