import QtQuick
import Quickshell
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects
import Quickshell.Services.SystemTray

import qs.singletons
import qs.bars.components

Widget {
    id: root

    width: row.width

    color: "transparent"
    shade: "transparent"

    text: ""

    Row {
        id: row

        anchors.centerIn: parent

        padding: 8
        spacing: 6

        Repeater {
            model: SystemTray.items

            delegate: Item {
                width: 12
                height: Themes.barHeight

                MouseArea {
                    id: mouseArea

                    anchors.fill: parent

                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton

                    implicitWidth: parent.width
                    implicitHeight: parent.height

                    onClicked: event => {
                        const position = mouseArea.mapToItem(null, event.x, event.y);

                        var x = position.x;
                        var y = position.y;

                        switch (event.button) {
                        case Qt.LeftButton:
                            modelData.activate();
                            break;
                        case Qt.MiddleButton:
                            modelData.secondaryActivate();
                            break;
                        case Qt.RightButton:
                            modelData.display(QsWindow.window, x, y);
                            break;
                        }
                    }
                }

                IconImage {
                    id: image

                    asynchronous: true

                    width: parent.width
                    height: parent.height

                    source: Qt.resolvedUrl(modelData.icon)
                }
            }
        }
    }
}
