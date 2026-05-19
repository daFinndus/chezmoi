import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

import qs.singletons

Rectangle {
    property real padding: 8

    width: row.implicitWidth + padding * 2
    height: Globals.barHeight

    color: "transparent"

    Behavior on width {
        NumberAnimation {
            duration: 250
        }
    }

    Row {
        id: row

        anchors.fill: parent
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        spacing: 16

        Repeater {
            model: SystemTray.items

            delegate: Item {
                width: 16
                height: Globals.barHeight

                Component.onCompleted: {
                    console.log("Added system tray item: ", modelData.icon)
                    console.log("Tray item: ", modelData.id)
                }
 
                IconImage {
                    asynchronous: true

                    width: parent.width
                    height: parent.height

                    source: Qt.resolvedUrl(modelData.icon)
                }
            }
        }
    }
}
