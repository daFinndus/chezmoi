import QtQuick
import Quickshell
import Quickshell.Io

import qs.singletons
import qs.modules.components

Rect {
    farbe: getColor()
    inhalt: `${updateCount} Updates`

    property bool updatesLoaded: false
    property int updateCount: 0

    opacity: updateCount > 0 ? 1 : 0
    visible: opacity > 0 ? 1 : 0

    Behavior on opacity {
        NumberAnimation {
            duration: 250
        }
    }

    function refreshUpdates() { checkUpdates.running = true }

    function getColor() {
        if (updatesLoaded) {
            if (updateCount == 0) {
                return Colors.colors.green
            } else if (updateCount > 0 && updateCount < 12) {
                return Colors.colors.yellow
            } else {
                return Colors.colors.red
            }
        } else {
            return Colors.colors.yellow
        }
    }

    Process {
        id: checkUpdates

        // Sleep is added to let the system settle down
        command: ["bash", "-c", "checkupdates >&/dev/null; yay -Qu | wc -l"]

        stdout: StdioCollector  {
            waitForEnd: true

            onStreamFinished: {
                updatesLoaded = true                
                updateCount = parseInt(this.text)
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