pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool inhibited: false

    // Override icon is for getting text even though iconMode is enabled
    function getText(overrideIconMode = false): string {
        if (root.inhibited) {
            return !overrideIconMode && Themes.iconMode ? "\udb80\ude08" : "Inhibitor: Active";
        } else {
            return !overrideIconMode && Themes.iconMode ? "\udb80\ude09" : "Inhibitor: Inactive";
        }
    }

    property string who: "quickshell"
    property string what: "idle"
    property string why: "Quickshell inhibitor widget for ignoring hypridle"

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
