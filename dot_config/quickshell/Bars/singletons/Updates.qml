pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool updatesLoaded: false
    property int updateCount: 0

    function refreshUpdates() {
        checkUpdates.running = true;
    }

    function runUpdateScript() {
        runUpdateScript.running = true;
    }

    Process {
        id: checkUpdates

        command: [`${Globals.configPath}/scripts/updater.sh`, "get_updates"]

        stdout: StdioCollector {
            waitForEnd: true

            onStreamFinished: {
                root.updatesLoaded = true;
                root.updateCount = parseInt(this.text);
            }
        }
    }

    Process {
        id: runUpdateScript

        command: [`${Globals.configPath}/scripts/updater.sh`, "do_updates"]

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
}
