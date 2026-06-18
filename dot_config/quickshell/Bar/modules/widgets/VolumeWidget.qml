import QtQuick
import Quickshell
import Quickshell.Io

import qs.singletons
import qs.modules.components

Rect {
    id: root

    farbe: getColor()
    inhalt: getText()

    property int volume: 0
    property bool muted: false

    function refreshVolume() {
        getVolume.running = true;
        getMute.running = true;
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

        command: ["bash", "-c", `pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | tr -d "%"`]

        stdout: StdioCollector {
            onStreamFinished: data => {
                volume = parseInt(this.text.trim());
                console.log("Volume updated:", volume);
            }
        }
    }

    Process {
        id: getMute

        command: ["bash", "-c", `pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}'`]

        stdout: StdioCollector {
            onStreamFinished: data => {
                muted = this.text.trim() === "yes";
                console.log("Mute status updated:", muted);
            }
        }
    }

    Process {
        id: toggleMute

        command: ["bash", "-c", `pactl set-sink-mute @DEFAULT_SINK@ toggle`]
    }

    focus: mouseArea.containsMouse

    Keys.onPressed: event => {
        console.log("Key pressed:", event.key);

        switch (event.key) {
        case Qt.Key_Up:
            volumeUp.running = true;
            break;
        case Qt.Key_Down:
            volumeDown.running = true;
            break;
        case Qt.Key_M:
            toggleMute.running = true;
            break;
        }
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
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered: root.forceActiveFocus()

        acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton

        onClicked: event => {
            switch (event.button) {
            case Qt.LeftButton:
                toggleMute.running = true;
                break;
            case Qt.RightButton:
                startPavucontrol.running = true;
                break;
            case Qt.MiddleButton:
                toggleDevice.running = true;
                break;
            }
        }

        onWheel: event => {
            if (event.angleDelta.y > 0) {
                volumeUp.running = true;
            } else {
                volumeDown.running = true;
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
                    refreshVolume();
                    media.updatePlayers();
                }
            }
        }
    }

    function getColor() {
        if (volume === 0) {
            return Colors.color1;
        } else if (volume > 0 && volume <= 15) {
            return Colors.color2;
        } else if (volume > 15 && volume <= 50) {
            return Colors.color3;
        } else if (volume > 50 && volume <= 80) {
            return Colors.color4;
        } else {
            return Colors.color5;
        }
    }

    function getText() {
        refreshVolume();

        if (volume === 0 || muted) {
            return `Volume muted`;
        } else {
            return `Volume at ${volume}%`;
        }
    }
}
