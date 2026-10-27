pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    // Sink based properties
    property var sinks: []
    property int sinkVolume: 0
    property bool sinkMuted: false
    property string defaultSink: ""

    // Source based data
    property var sources: []
    property int sourceVolume: 0
    property bool sourceMuted: false
    property string defaultSource: ""

    // This is only used in non-icon based themes
    function getText(): string {
        if (root.sinkVolume === 0 || root.sinkMuted) {
            return `Volume muted`;
        } else {
            return `Volume at ${root.sinkVolume}%`;
        }
    }

    function refreshVolume(): void {
        root.refreshSinks();
        root.refreshSources();
    }

    function startPavucontrol(): void {
        startPavucontrol.running = true;
    }

    function toggleDevice(): void {
        toggleDevice.running = true;
    }

    Process {
        id: startPavucontrol
        command: ["pavucontrol"]
    }

    Process {
        id: toggleDevice
        command: [`${Globals.basePath}/scripts/audio.sh`, "toggle"]
    }

    // ==================== Sink / Output ====================
    //
    //
    //
    // Here starts all the sink based stuff, also the application fetching
    Process {
        id: getSinks

        command: ["pactl", "-f", "json", "list", "sinks"]

        stdout: StdioCollector {
            onStreamFinished: {
                const devices = JSON.parse(this.text);
                root.sinks = devices;

                const device = devices.find(item => item.name === root.defaultSink);
                if (device) {
                    root.sinkVolume = parseInt(device.volume?.["front-left"]?.value_percent) || 0;
                    root.sinkMuted = device.mute;
                }
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

                root.refreshSinks();
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

    function setSinkVolume(volume: int): void {
        Globals.logEverything("Setting sink volume to: " + volume);

        if (volume <= 0) {
            root.setSinkMute(true);
            root.sinkVolume = 0;
            return;
        }

        if (root.sinkMuted) {
            root.setSinkMute(false);
        }

        changeVolume.command = ["pactl", "set-sink-volume", "@DEFAULT_SINK@", `${volume}%`];
        changeVolume.running = true;
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
    Process {
        id: getSources

        command: ["pactl", "-f", "json", "list", "sources"]

        stdout: StdioCollector {
            onStreamFinished: {
                // Filter out monitor sources
                const devices = JSON.parse(this.text);
                root.sources = devices.filter(source => !source.name.endsWith(".monitor"));

                const device = devices.find(item => item.name === root.defaultSource);
                if (device) {
                    root.sourceVolume = parseInt(device.volume?.["front-left"]?.value_percent) || 0;
                    root.sourceMuted = device.mute;
                }
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

                root.refreshSources();
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

    function setSourceVolume(volume: int): void {
        Globals.logEverything("Setting source volume to: " + volume);

        if (volume <= 0) {
            root.setSourceMute(true);
            root.sourceVolume = 0;
            return;
        }

        if (root.sourceMuted) {
            root.setSourceMute(false);
        }

        changeVolume.command = ["pactl", "set-source-volume", "@DEFAULT_SOURCE@", `${volume}%`];
        changeVolume.running = true;
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
                root.refreshVolume();
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

    // I think this might be necessary
    // PipeWire might just need some time to initiate
    Timer {
        id: initialFetching

        running: false
        repeat: root.defaultSink === "" || root.defaultSource === ""

        interval: 3000

        onTriggered: {
            getDefaultSink.running = true;
            getDefaultSource.running = true;

            root.refreshSinks();
            root.refreshSources();
        }
    }
}
