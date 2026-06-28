import QtQuick
import Quickshell
import Quickshell.Io

import qs.singletons
import qs.modules.components

Entry {
    id: root

    hintergrund: Colors.color1
    farbe: Colors.color0
    inhalt: `${Globals.updateCount} Updates`

    opacity: Globals.updateCount > 0 ? 1 : 0
    visible: opacity > 0 ? 1 : 0

    function refreshUpdates() {
        checkUpdates.running = true;
    }

    function getColor() {
        if (Globals.updatesLoaded) {
            if (Globals.updateCount == 0) {
                return Colors.color2;
            } else if (Globals.updateCount > 0 && Globals.updateCount < 12) {
                return Colors.color6;
            } else {
                return Colors.color12;
            }
        } else {
            return Colors.color2;
        }
    }

    Process {
        id: checkUpdates

        // Sleep is added to let the system settle down
        command: ["bash", "-c", "(checkupdates 2>/dev/null; yay -Qu 2>/dev/null) | wc -l"]

        stdout: StdioCollector {
            waitForEnd: true

            onStreamFinished: {
                Globals.updatesLoaded = true;
                Globals.updateCount = parseInt(this.text);
            }
        }
    }

    Timer {
        interval: 1000 * 60 * 5
        running: true
        repeat: true

        onTriggered: refreshUpdates()
    }

    Process {
        id: runUpdateScript

        command: `${Globals.configPath}/scripts/updater.sh`

        stdout: StdioCollector {
            waitForEnd: true

            onStreamFinished: {
                console.log("Update script finished, setting update count...");
                Globals.updateCount = 0;
            }
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: runUpdateScript.running = true
    }

    Component.onCompleted: refreshUpdates()
}
