pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property string icon: "\uefcf"

    // ==================== Sink / Output ====================
    //
    //
    //
    // Here starts all the sink based stuff, also the application fetching

    // Sink based properties
    property var sinks: []
    property int sinkVolume: 0
    property bool sinkMuted: false
    property string defaultSink: ""

    Process {
        id: getSinks

        // Filter for not available sinks
        command: ["sh", "-c", `pactl -f json list sinks | jq '[.[] | select(.ports[0].availability != "not available")]'`]

        stdout: StdioCollector {

            onStreamFinished: {
                root.sinks = JSON.parse(this.text.trim());
                root.getSinkVolume();
            }
        }
    }

    Process {
        id: getDefaultSink

        command: ["pactl", "get-default-sink"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.defaultSink = this.text.trim();
            }
        }
    }

    function refreshSinks() {
        getSinks.running = true;
    }

    function setSink(sink: string) {
        changeSink.command = ["pactl", "set-default-sink", `${sink}`];
        changeSink.running = true;
    }

    Process {
        id: changeSink

        stdout: StdioCollector {
            onStreamFinished: {
                getDefaultSink.running = true;
            }
        }
    }

    function setSinkVolume(volume: int): void {
        Globals.logEverything("Setting sink volume to: " + volume);
        changeVolume.command = ["pactl", "set-sink-volume", "@DEFAULT_SINK@", `${volume}%`];
        changeVolume.running = true;
    }

    function getSinkVolume() {
        getSinkVolume.running = true;
    }

    Process {
        id: getSinkVolume
        command: ["sh", "-c", "pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | tr -d %"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.sinkVolume = this.text.trim();
            }
        }
    }

    function setSinkMute(mute: bool) {
        Globals.logEverything("Setting sink mute to: " + mute);
        setSinkMuteState.command = ["pactl", "set-sink-mute", "@DEFAULT_SINK@", `${mute}`];
        setSinkMuteState.running = true;
    }

    Process {
        id: setSinkMuteState

        stdout: StdioCollector {
            onStreamFinished: {
                root.refreshSinks();
            }
        }
    }

    // =================== Source / Input ====================
    //
    //
    //
    // Here starts all the source based stuff

    // Source based data
    property var sources: []
    property int sourceVolume: 0
    property bool sourceMuted: false
    property string defaultSource: ""

    Process {
        id: getSources

        command: ["sh", "-c", `pactl -f json list sources | jq '[.[] | select(.ports[0].availability != "not available")]'`]

        stdout: StdioCollector {
            onStreamFinished: {
                // Filter out monitor sources
                root.sources = JSON.parse(this.text).filter(source => !source.name.endsWith(".monitor"));
                root.getSourceVolume();
            }
        }
    }

    Process {
        id: getDefaultSource

        command: ["pactl", "get-default-source"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.defaultSource = this.text.trim();
            }
        }
    }

    function refreshSources() {
        getSources.running = true;
    }

    function setSource(source: string) {
        changeSource.command = ["pactl", "set-default-source", `${source}`];
        changeSource.running = true;
    }

    Process {
        id: changeSource

        stdout: StdioCollector {
            onStreamFinished: {
                getDefaultSource.running = true;
            }
        }
    }

    function setSourceVolume(volume: int): void {
        Globals.logEverything("Setting source volume to: " + volume);
        changeVolume.command = ["pactl", "set-source-volume", "@DEFAULT_SOURCE@", `${volume}%`];
        changeVolume.running = true;
    }

    function getSourceVolume() {
        getSourceVolume.running = true;
    }

    Process {
        id: getSourceVolume
        command: ["sh", "-c", "pactl get-source-volume @DEFAULT_SOURCE@ | awk '{print $5}' | tr -d %"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.sourceVolume = this.text.trim();
            }
        }
    }

    function setSourceMute(mute: bool) {
        Globals.logEverything("Setting source mute to: " + mute);
        setSourceMuteState.command = ["pactl", "set-source-mute", "@DEFAULT_SOURCE@", `${mute}`];
        setSourceMuteState.running = true;
    }

    Process {
        id: setSourceMuteState

        stdout: StdioCollector {
            onStreamFinished: {
                root.refreshSources();
            }
        }
    }

    // =================== Rest ====================
    //
    // I know these comments look like AI, they are not
    //
    // Here's the rest
    Process {
        id: changeVolume

        stdout: StdioCollector {
            onStreamFinished: {
                if (changeVolume.command[1].includes("set-sink-volume")) {
                    root.getSinkVolume();
                } else {
                    root.getSourceVolume();
                }
            }
        }
    }

    Process {
        id: events

        command: ["pactl", "subscribe"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                Globals.logEverything("Pactl event occured: " + data);

                if (data.includes("sink")) {
                    root.refreshSinks();
                } else if (data.includes("source")) {
                    root.refreshSources();
                }
            }
        }
    }

    Component.onCompleted: {
        initialFetching.start();
    }

    // Fetch as long as neither a sink or a source is fetched
    Timer {
        id: initialFetching

        running: false
        repeat: root.sinks.length < 1 && root.sources.length < 1

        interval: 1500

        onTriggered: {
            getDefaultSink.running = true;
            getDefaultSource.running = true;

            root.refreshSinks();
            root.refreshSources();
        }
    }
}
