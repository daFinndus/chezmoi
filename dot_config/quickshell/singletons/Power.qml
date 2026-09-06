pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.UPower

Singleton {
    id: root

    property int power: PowerProfiles.profile

    function getText(): string {
        switch (power) {
        case 0:
            return "Profile: Chillin'";
        case 1:
            return "Profile: Balanced";
        case 2:
            return "Profile: Performance";
        default:
            return "Profile: Unknown";
        }
    }

    function nextProfile() {
        PowerProfiles.profile = (power + 1) % 3;
    }
}
