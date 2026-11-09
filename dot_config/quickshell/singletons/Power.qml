pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string profile: ""

    function setProfile(profile: string): void {
        Globals.logDebug("Changing power profile to: " + profile);
        setProfile.command = ["tlpctl", "set", profile];
        setProfile.running = true;
    }

    Process {
        id: setProfile

        stdout: StdioCollector {
            onStreamFinished: {
                root.getProfile();
            }
        }
    }

    function getProfile() {
        getProfile.running = true;
    }

    Process {
        id: getProfile
        command: ["tlpctl", "get"]

        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                profile = this.text.trim();
            }
        }
    }
}
