pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property int volume: 0
    property bool muted: false

    function refreshVolume() {
        getVolume.running = true;
        getMute.running = true;
    }

    function increaseVolume() {
        volumeUp.running = true;
    }

    function decreaseVolume() {
        volumeDown.running = true;
    }

    function toggleVolume() {
        toggleMute.running = true;
    }

    function startPavucontrol() {
        startPavucontrol.running = true;
    }

    function toggleDevice() {
        toggleDevice.running = true;
    }

    Process {
        id: startPavucontrol

        command: "pavucontrol"
    }

    Process {
        id: toggleDevice

        command: `${Globals.barsPath}/scripts/toggle-audio.sh`
    }

    Process {
        id: getVolume

        command: ["bash", "-c", `pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | tr -d "%"`]

        stdout: StdioCollector {
            onStreamFinished: {
                root.volume = parseInt(this.text.trim());
                Globals.logEverything("Volume updated: " + root.volume);
            }
        }
    }

    Process {
        id: getMute

        command: ["bash", "-c", `pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}'`]

        stdout: StdioCollector {
            onStreamFinished: {
                root.muted = this.text.trim() === "yes";
                Globals.logEverything("Mute status updated: " + root.muted);
            }
        }
    }

    Process {
        id: toggleMute

        command: ["bash", "-c", `pactl set-sink-mute @DEFAULT_SINK@ toggle`]
    }

    Process {
        id: volumeUp
        command: ["pactl", "set-sink-volume", "@DEFAULT_SINK@", "+5%"]
    }

    Process {
        id: volumeDown
        command: ["pactl", "set-sink-volume", "@DEFAULT_SINK@", "-5%"]
    }

    Process {
        id: events

        command: ["pactl", "subscribe"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                if (data.includes("sink")) {
                    refreshVolume();
                }
            }
        }
    }

    function getText() {
        refreshVolume();

        if (root.volume === 0 || root.muted) {
            return `Volume muted`;
        } else {
            return `Volume at ${volume}%`;
        }
    }
}
