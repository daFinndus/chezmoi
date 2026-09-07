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
            return !overrideIconMode & Themes.iconMode ? "\udb80\ude08" : "Inhibitor: Active";
        } else {
            return !overrideIconMode & Themes.iconMode ? "\udb80\ude09" : "Inhibitor: Inactive";
        }
    }

    Process {
        id: inhibitProcess

        readonly property string who: "--who=quickshell"
        readonly property string what: "--what=idle"
        readonly property string why: "--why=Quickshell inhibitor"

        command: {
            if (!root.inhibited) {
                return ["true"];
            }

            return ["systemd-inhibit", what, who, why, "sleep", "infinity"];
        }

        running: root.inhibited

        onExited: function (exitCode): void {
            console.log("Inhibitor process exited!");

            if (Globals.inhibited && exitCode !== 0) {
                Globals.inhibited = false;
            }
        }
    }
}
