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

        onEntered: {
            Globals.wlogoutOpen = true;
            Globals.wlogoutClickable = true;
        }

        onExited: {
            verifyWlogout.start();
        }
    }

    // This function will check, if the wlogout menu should be closed
    function checkWlogout() {
        if (!Globals.wlogoutHovered) {
            Globals.wlogoutClickable = false;
            closeWlogout.start();
        } else {
            console.log("WlogoutWidget is hovered, not closing it yet...");
        }
    }

    Timer {
        id: verifyWlogout
        interval: 150

        onTriggered: checkWlogout()
    }

    Timer {
        id: closeWlogout
        interval: Globals.wlogoutFadeDelay

        onTriggered: Globals.wlogoutOpen = false
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
