pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string username: ""
    property string hostname: ""

    property string uptime: ""
    property string icon: "\udb82\udcc7"

    Process {
        id: getUsername

        running: true

        command: ["whoami"]

        stdout: StdioCollector {
            waitForEnd: true

            onStreamFinished: {
                root.username = this.text.trim();
            }
        }
    }

    Process {
        id: getHostname

        running: true

        command: ["cat", "/etc/hostname"]

        stdout: StdioCollector {
            waitForEnd: true

            onStreamFinished: {
                root.hostname = this.text.trim();
            }
        }
    }

    Process {
        id: getUptime

        running: true

        command: ["uptime", "--pretty"]

        stdout: StdioCollector {
            waitForEnd: true

            onStreamFinished: {
                root.uptime = this.text.trim();
            }
        }
    }

    Timer {
        id: updateUptime

        repeat: true
        running: true

        interval: 1000 * 60

        onTriggered: getUptime.running = true
    }
}
