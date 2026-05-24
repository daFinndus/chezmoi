import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

import qs.singletons

Rectangle {
    property real padding: 16

    width: text.width + padding * 2
    height: Globals.barHeight

    color: Colors.colors.background

    border.color: Colors.colors.gray
    border.width: Globals.borderWidth

    radius: 6

    Behavior on width {
        NumberAnimation {
            duration: 250
        }
    }

    property int volume: 0
    property bool muted: false

    function refreshVolume() { 
        getVolume.running = true
        getMute.running = true
    }

    Process {
        id: startPavucontrol

        command: "pavucontrol"
    }

    Process {
        id: toggleDevice

        command: `${Globals.configPath}/scripts/toggle-audio.sh`
    }

    Process {
        id: getVolume

        command: [
            "bash", "-c", 
            `pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | tr -d "%"`
        ]

        stdout: StdioCollector {
            onStreamFinished: data => {
                volume = parseInt(this.text.trim())
                console.log("Volume updated:", volume)
            }
        }
    }

    Process {
        id: getMute

        command: [
            "bash", "-c",
            `pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}'`
        ]

        stdout: StdioCollector {
            onStreamFinished: data => {
                muted = this.text.trim() === "yes"
                console.log("Mute status updated:", muted)
            }
        }
    }

    Process {
        id: toggleMute

        command: [
            "bash", "-c",
            `pactl set-sink-mute @DEFAULT_SINK@ toggle`
        ]
    }

    Process {
        id: volumeUp
        command: ["pactl", "set-sink-volume", "@DEFAULT_SINK@", "+5%"]
    }

    Process {
        id: volumeDown
        command: ["pactl", "set-sink-volume", "@DEFAULT_SINK@", "-5%"]
    }

    MouseArea {
        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton | Qt.M

        onClicked: event => {
            switch (event.button) {
                case Qt.LeftButton:
                    toggleMute.running = true
                    break
                case Qt.RightButton:
                    startPavucontrol.running = true
                    break
                case Qt.MiddleButton:
                    toggleDevice.running = true
                    break
            }
        }

        onWheel: event => {
            if (event.angleDelta.y > 0) {
                volumeUp.running = true
            } else {
                volumeDown.running = true
            }
        }
    }

    Process {
        id: events
        command: ["pactl", "subscribe"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                if (data.includes("sink")) {
                    refreshVolume()
                }
            }
        }
    }

    function getColor() {
        if (volume === 0) {
            return Colors.colors.red
        } else if (volume > 0 && volume <= 15) {
            return Colors.colors.lightred
        } else if (volume > 15 && volume <= 50) {
            return Colors.colors.orange
        } else if (volume > 50 && volume <= 80) {
            return Colors.colors.yellow
        } else {
            return Colors.colors.green
        }
    }

    function getText() {
        refreshVolume()

        if (volume === 0 || muted) {
            return `Volume muted`
        } else {
            return `Volume at ${volume}%`
        }
    }

    Text {
        id: text

        Component.onCompleted: refreshVolume()

        font.family: Globals.fontFamily
        font.pixelSize: Globals.fontSize

        color: getColor()

        x: parent.padding
        y: parent.padding

        anchors.centerIn: parent

        text: getText()
    }
}
