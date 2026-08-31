pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool available: true

    property string humidity: "25.5"
    property string temperature: "61.2"

    Process {
        id: fetchTemperature

        command: [`${Globals.barsPath}/scripts/homeassistant.sh`, "temp"]

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

        command: [`${Globals.barsPath}/scripts/homeassistant.sh`, "humi"]

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

    function updateStates() {
        fetchTemperature.running = true;
        fetchHumidity.running = true;
    }

    Timer {
        interval: 3000

        running: true
        repeat: true

        onTriggered: root.updateStates()
    }
}
