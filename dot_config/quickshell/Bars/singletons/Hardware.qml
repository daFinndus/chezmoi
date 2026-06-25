pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string loadCPU: ""
    property string tempCPU: ""

    property string loadRAM: ""
    property string tempRAM: ""

    property string loadGPU: ""
    property string tempGPU: ""

    Process {
        id: fetchCPU

        command: [`${Globals.configPath}/scripts/hardware.sh`, "cpu"]

        stdout: StdioCollector {
            onStreamFinished: {
                console.log(this.text.trim());

                root.loadCPU = this.text.trim();
            }
        }
    }

    Component.onCompleted: {
        fetchCPU.running = true;
    }
}
