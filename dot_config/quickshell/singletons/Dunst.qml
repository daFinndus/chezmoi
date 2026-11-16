pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool running: false
    readonly property string icon: root.running ? "\udb80\udc9a" : "\udb80\udc9b"

    function toggleDaemon() {
        toggleDunst.running = true;
    }

    Process {
        id: toggleDunst
        command: ["dunstctl", "set-paused", "toggle"]

        stdout: StdioCollector {
            onStreamFinished: {
                fetchDunst.running = true;
            }
        }
    }

    Process {
        id: fetchDunst
        command: ["dunstctl", "is-paused"]

        stdout: StdioCollector {
            onStreamFinished: {
                this.text.trim() === "false" ? root.running = true : root.running = false;
            }
        }
    }

    Component.onCompleted: fetchDunst.running = true
}
