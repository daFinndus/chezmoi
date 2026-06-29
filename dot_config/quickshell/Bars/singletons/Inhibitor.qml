pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool inhibited: false

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

        onExited: function (exitCode) {
            console.log("Inhibitor process exited!");

            if (Globals.inhibited && exitCode !== 0) {
                console.warn("Inhibitor: Inhibitor process crashed with exit code:", exitCode);

                Globals.inhibited = false;
            }
        }
    }
}
