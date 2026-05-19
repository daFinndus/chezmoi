import QtQuick
import Quickshell

import qs.singletons

PopupWindow {
    anchor.window: QsWindow.window

    implicitWidth: text.implicitWidth + 32
    implicitHeight: Globals.barHeight

    anchor.rect.x: Globals.trayPosition.x
    anchor.rect.y: Globals.trayPosition.y + 4

    visible: Globals.trayHovered

    color: "transparent"
    
    Rectangle {
        width: parent.width
        height: parent.height

        border.color: Colors.colors.gray
        border.width: Globals.borderWidth

        radius: 6

        color: Colors.colors.background

        opacity: Globals.trayHovered ? 1 : 0

        Behavior on opacity {
            NumberAnimation { 
                duration: 250
                easing.type: Easing.InOutQuad
            }
        }

        Text {
            id: text

            anchors.centerIn: parent

            color: Colors.colors.lightgray
            
            font.family: Globals.fontFamily
            
            text: "Hello, world!"
        }
    }
}