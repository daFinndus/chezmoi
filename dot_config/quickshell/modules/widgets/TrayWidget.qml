import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

import qs.singletons

Rectangle {
    id: tray

    property real padding: 16

    width: row.width + padding * 2
    height: Globals.barHeight

    color: "transparent"

    Row {
        id: row

        anchors.centerIn: parent

        spacing: 12

        Repeater {
            model: SystemTray.items

            delegate: Item {
                width: 16
                height: Globals.barHeight
 
                MouseArea {
                    id: maus

                    anchors.fill: parent

                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton

                    implicitWidth: parent.width
                    implicitHeight: parent.height

                    onClicked: event => {
                        const position = maus.mapToItem(null, event.x, event.y)

                        var x = position.x
                        var y = position.y

                        switch (event.button) {
                            case Qt.LeftButton:
                                modelData.activate()
                                break

                            case Qt.MiddleButton:
                                modelData.secondaryActivate()
                                break

                            case Qt.RightButton:
                                modelData.display(QsWindow.window, x, y)
                                break
                        }
                    }
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

