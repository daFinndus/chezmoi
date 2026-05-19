import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

import qs.singletons

Rectangle {
    id: tray

    property real padding: 8

    property bool hovered: mouseArea.containsMouse

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            const position = tray.mapToGlobal(Qt.point(implicitWidth, tray.height))

            Globals.trayHovered = true
            Globals.trayPosition = position

            console.log("Mouse entered tray, position =", position)
        }

        onExited: {
            Globals.trayHovered = false
            Globals.trayPosition = Qt.point(0, 0)

            console.log("Mouse exited tray")
        }
    }

    width: text.implicitWidth + padding * 4
    height: Globals.barHeight

    color: Colors.colors.background

    opacity : trayActive ? 1 : 0

    border.color: Colors.colors.gray
    border.width: Globals.borderWidth

    radius: 6

    Behavior on opacity {
        NumberAnimation {
            duration: 250
        }
    }

    property int trayItems: SystemTray.items.rowCount()
    property bool trayActive: trayItems > 0

    Connections {
        target: SystemTray.items

        function onRowsInserted() {
            trayItems = SystemTray.items.rowCount()
            console.log("Inserted an application, count =", trayItems)
        }

        function onRowsRemoved() {
            trayItems = SystemTray.items.rowCount()
            console.log("Removed an application, count =", trayItems)
        }
    }

    Text {
        id: text

        font.family: Globals.fontFamily
        font.pixelSize: Globals.fontSize

        color: hovered ? Colors.colors.lightgray : Colors.colors.gray

        x: parent.padding
        y: parent.padding

        anchors.centerIn: parent

        text: "Tray active"

        Behavior on color {
            ColorAnimation {
                duration: 500
            }
        }
    }
}

