pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.UPower

Singleton {
    id: root

    property int powerProfileIndex: PowerProfiles.profile
    property string powerProfileName: root.getText()

    onPowerProfileIndexChanged: Globals.logDebug("Profile changed to " + root.powerProfileIndex + "!")

    // Will return the profile as a human-readable string
    function getText(): string {
        switch (root.powerProfileIndex) {
        case 0:
            return "Power Saver";
        case 1:
            return "Balanced";
        case 2:
            return "Performance";
        default:
            return "Unknown";
        }
    }

    function setProfile(profileIndex: int): void {
        Globals.logDebug("Changing profile to: " + profileIndex);

        PowerProfiles.profile = profileIndex;
    }

    function nextProfile() {
        PowerProfiles.profile = (root.powerProfileIndex + 1) % 3;
    }
}
