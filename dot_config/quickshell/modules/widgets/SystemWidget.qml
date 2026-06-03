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
            Globals.dropdownVisible = true;
            Globals.dropdownOpen = true;
        }

        onExited: {
            dropdownOpenTimer.start();
        }
    }

    function toggleDropdownOpen() {
        if (!Globals.dropdownHovered) {
            Globals.dropdownOpen = false;
            dropdownVisibleTimer.start();
        }
    }

    Timer {
        id: dropdownOpenTimer
        interval: 150
        onTriggered: toggleDropdownOpen()
    }

    Timer {
        id: dropdownVisibleTimer
        interval: Globals.dropdownTimer
        onTriggered: Globals.dropdownVisible = false
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
