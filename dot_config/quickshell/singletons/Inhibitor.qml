pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool inhibited: false
    readonly property string icon: {
        if (root.inhibited) {
            return "\udb80\ude08";
        } else {
            return "\udb80\ude09";
        }
    }

    readonly property string text: `Inhibitor is: ${root.inhibited}`

    readonly property string who: "quickshell"
    readonly property string what: "idle"
    readonly property string why: "Quickshell inhibitor widget for ignoring hypridle"

    function getInhibitProcess(): void {
        getInhibitProcess.running = true;
    }

    Process {
        id: getInhibitProcess
        command: ["bash", "-c", `systemd-inhibit --list | grep ${what}`]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                if (this.text.trim() != "") {
                    root.inhibited = true;
                } else {
                    root.inhibited = false;
                }
            }
        }
    }

    Process {
        id: startInhibitProcess
        command: ["systemd-inhibit", "--who", who, "--what", what, "--why", why, "sleep", "infinity"]
        running: root.inhibited
    }

    // This is a convenience thing
    Component.onCompleted: root.inhibited = true
}
