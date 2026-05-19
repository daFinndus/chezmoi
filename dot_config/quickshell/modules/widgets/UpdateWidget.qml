import QtQuick
import Quickshell
import Quickshell.Io

import qs.singletons

Rectangle {
    id: root

    property real padding: 8

    property bool updatesLoaded: false
    property int updateCount: 0

    width: text.implicitWidth + 16 + padding * 4
    height: Globals.barHeight

    color: Colors.colors.background

    opacity: updateCount > 0 ? 1 : 0

    border.color: Colors.colors.gray
    border.width: Globals.borderWidth

    radius: 6

    Behavior on width {
        NumberAnimation {
            duration: 250
        }
    }

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
        command: ["bash", "-c", "checkupdates | wc -l"]

        stdout: StdioCollector  {
            waitForEnd: true

            onStreamFinished: {
                updatesLoaded = true                
                updateCount = parseInt(this.text)

                refreshUpdates()
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

        property string script: Globals.configPath + "/scripts/updater.sh"

        command: [script]

        
    }

    MouseArea {
        anchors.fill: parent
        onClicked:runUpdateScript.running = true
    }

    Component.onCompleted: refreshUpdates()

    Text {
        id: text

        font.family: Globals.fontFamily
        font.pixelSize: Globals.fontSize

        color: getColor()

        x: parent.padding
        y: parent.padding

        anchors.centerIn: parent

        text: updateCount + " Updates"

        Behavior on color {
            ColorAnimation {
                duration: 250
            }
        }
    }

}
