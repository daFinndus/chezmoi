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
        id: fetchStates

        command: [`${Globals.basePath}/scripts/homeassistant.sh`, "all"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const states = JSON.parse(this.text.trim());
                    const temperature = Number(states.temperature);
                    const humidity = Number(states.humidity);

                    if (!Number.isFinite(temperature) || !Number.isFinite(humidity)) {
                        root.available = false;
                        return;
                    }

                    root.temperature = temperature.toFixed(1);
                    root.humidity = humidity.toFixed(1);
                    root.available = true;
                } catch (e) {
                    root.available = false;
                    Globals.logError("Home Assistant parse failed: " + e);
                }
            }
        }
    }

    function updateStates(): void {
        fetchStates.running = true;
    }

    Timer {
        interval: 5000

        running: true
        repeat: true

        onTriggered: root.updateStates()
    }

    Component.onCompleted: root.updateStates()
}
