import QtQuick
import Quickshell
import Quickshell.Services.UPower

import qs.singletons
import qs.modules.components

Rect {
    farbe: getColor()
    inhalt: `Profile: ${getProfile()}`

    property int power: PowerProfiles.profile

    function getProfile() {
        switch (power) {
        case 0:
            return "Chillin'";
        case 1:
            return "Balanced";
        case 2:
            return "Performance";
        default:
            return "Unknown";
        }
    }

    function getColor() {
        switch (power) {
        case 0:
            return Colors.color1;
        case 1:
            return Colors.color4;
        case 2:
            return Colors.color6;
        default:
            return Colors.color1;
        }
    }

    MouseArea {
        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            PowerProfiles.profile = (power + 1) % 3;
        }
    }
}
