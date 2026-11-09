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

        // This is done without checking the real profile
        // Cuz checking costs so much time
        root.profile = profile;
    }

    Process {
        id: setProfile
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
                root.profile = this.text.trim();
            }
        }
    }
}
