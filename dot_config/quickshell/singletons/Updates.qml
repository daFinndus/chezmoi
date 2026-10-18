pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool widgetHovered: false

    property int updateCount: 0
    property bool updatesLoaded: false

    function refreshUpdates(): void {
        checkUpdates.running = true;
    }

    Process {
        id: checkUpdates

        command: [`${Quickshell.env("XDG_DATA_HOME")}/../bin/update-manager.sh`, "get_updates"]

        stdout: StdioCollector {
            waitForEnd: true

            onStreamFinished: {
                root.updatesLoaded = true;
                root.updateCount = parseInt(this.text);
            }
        }
    }

    function runUpdateScript(): void {
        runUpdateScript.running = true;
    }

    Process {
        id: runUpdateScript

        command: [`${Quickshell.env("XDG_DATA_HOME")}/../bin/update-manager.sh`, "do_updates"]

        onExited: exitCode => {
            if (exitCode === 0) {
                root.updateCount = 0;
            } else {
                root.refreshUpdates();
            }
        }
    }

    Timer {
        interval: 1000 * 60 * 5
        running: true
        repeat: true

        onTriggered: root.refreshUpdates()
    }

    Component.onCompleted: root.refreshUpdates()
}
