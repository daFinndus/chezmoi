pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool available: true

    property string temperature: "25.5"
    property string humidity: "62.3"

    Process {
        id: fetchTemperature

        command: [`${Globals.basePath}/scripts/homeassistant.sh`, "temp"]

        stdout: StdioCollector {
            onStreamFinished: {
                var text = this.text.trim();

                if (isNaN(Number(text))) {
                    root.available = false;
                } else {
                    root.temperature = this.text.trim();
                    root.available = true;
                }
            }
        }
    }

    Process {
        id: fetchHumidity

        command: [`${Globals.basePath}/scripts/homeassistant.sh`, "humi"]

        stdout: StdioCollector {
            onStreamFinished: {
                var text = this.text.trim();

                if (isNaN(Number(text))) {
                    root.available = false;
                } else {
                    root.humidity = this.text.trim();
                    root.available = true;
                }
            }
        }
    }

    function updateStates(): void {
        fetchTemperature.running = true;
        fetchHumidity.running = true;
    }

    Timer {
        interval: 3000

        running: true
        repeat: true

        onTriggered: root.updateStates()
    }

    Component.onCompleted: root.updateStates()
}
