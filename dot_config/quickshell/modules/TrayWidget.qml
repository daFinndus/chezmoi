import QtQuick
import Quickshell
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects
import Quickshell.Services.SystemTray

import qs.singletons
import qs.components

Item {
    id: root

    width: row.width
    height: Themes.barHeight

    // These values have to be here
    // They are not used
    // This is only to make the alternating thingy in Tsoding work
    property string background
    property string shade

    Row {
        id: row

        anchors.centerIn: parent

        spacing: 12
        padding: 8

        Repeater {
            model: SystemTray.items

            delegate: Widget {
                id: root

                required property var modelData

                width: Themes.iconSize
                height: Themes.iconSize

                background: "transparent"
                border.color: "transparent"

                icon: true
                text: Tray.convertId(modelData.id)

                MouseArea {
                    id: mouseArea

                    anchors.fill: parent

                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton

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

                Tooltip {
                    target: root

                    available: Themes.iconMode && mouseArea.containsMouse && modelData.title != ""

                    text: modelData.title
                }
            }
        }
    }
}
