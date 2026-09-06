pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property int volume: 0
    property bool muted: false

    function getText(): string {
        refreshVolume();

        if (root.volume === 0 || root.muted) {
            return `Volume muted`;
        } else {
            return `Volume at ${volume}%`;
        }
    }

    function refreshVolume(): void {
        getVolume.running = true;
        getMute.running = true;
    }

    function increaseVolume(): void {
        volumeUp.running = true;
    }

    function decreaseVolume(): void {
        volumeDown.running = true;
    }

    function toggleVolume(): void {
        toggleMute.running = true;
    }

    function startPavucontrol(): void {
        startPavucontrol.running = true;
    }

    function toggleDevice(): void {
        toggleDevice.running = true;
    }

    Process {
        id: startPavucontrol

        command: "pavucontrol"
    }

    Process {
        id: toggleDevice

        command: `${Globals.basePath}/scripts/toggle-audio.sh`
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
}
