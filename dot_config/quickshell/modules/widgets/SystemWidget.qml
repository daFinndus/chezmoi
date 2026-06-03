import QtQuick
import Quickshell
import Quickshell.Io

import qs.singletons

Rectangle {
    // This is set based on the dropdown menu
    width: 126
    height: Globals.barHeight

    color: Colors.colors.red

    border.color: Colors.colors.red
    border.width: Globals.borderWidth

    radius: 6

    Behavior on width {
        NumberAnimation {
            duration: 250
        }
    }

    MouseArea {
        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: Globals.wlogout = true

        onEntered: {
            Globals.dropdownOpen = true;
        }

        onExited: {
            dropdownTimer.start();
        }
    }

    function toggleDropdown() {
        if (!Globals.dropdownHovered) {
            Globals.dropdownOpen = false;
        }
    }

    Timer {
        id: dropdownTimer

        interval: 150

        onTriggered: toggleDropdown()
    }

    Text {
        id: text

        font.family: Globals.fontFamily
        font.pixelSize: Globals.fontSize

        color: Colors.colors.winered

        anchors.centerIn: parent

        text: "System"
    }
}
