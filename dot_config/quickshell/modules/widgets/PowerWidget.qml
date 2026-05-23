import QtQuick
import Quickshell
import Quickshell.Services.UPower 

import qs.singletons

Rectangle {
    property int padding: 16

    width: text.width + padding * 3
    height: Globals.barHeight

    color: Colors.colors.background

    border.color: Colors.colors.gray
    border.width: Globals.borderWidth

    radius: 6

    property int power: PowerProfiles.profile

    Behavior on width {
        NumberAnimation {
            duration: 250
        }
    }

    function getProfile() {
        switch (power) {
        case 0:
            return "Chillin'"
        case 1:
            return "Balanced"
        case 2:
            return "Performance"
        default:
            return "Unknown"
        }
    }

    function getColor() {
        switch (power) {
        case 0:
            return Colors.colors.green
        case 1:
            return Colors.colors.orange
        case 2:
            return Colors.colors.red
        default:
            return Colors.colors.gray
        }
    }

    MouseArea {
        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            PowerProfiles.profile = (power + 1) % 3
        }
    }
    
    Text {
        id: text

        font.family: Globals.fontFamily
        font.pixelSize: Globals.fontSize

        color: getColor()

        x: parent.padding
        y: parent.padding

        anchors.centerIn: parent

        text: "Profile: " + getProfile()

        Behavior on color {
            ColorAnimation {
                duration: 500
                easing.type: Easing.OutCubic
            }
        }        
    }
}
