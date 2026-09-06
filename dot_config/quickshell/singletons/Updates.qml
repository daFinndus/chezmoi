pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool widgetHovered: false

    property bool updatesLoaded: false
    property int updateCount: 0

    function refreshUpdates(): void {
        checkUpdates.running = true;
    }

    function runUpdateScript(): void {
        runUpdateScript.running = true;
    }

    Process {
        id: checkUpdates

        command: [`${Globals.basePath}/scripts/updater.sh`, "get_updates"]

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

        command: [`${Globals.basePath}/scripts/updater.sh`, "do_updates"]

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
