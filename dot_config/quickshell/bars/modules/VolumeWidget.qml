import QtQuick

import qs.singletons
import qs.bars.modules.components

Widget {
    id: root

    text: Volume.getText()

    Keys.onPressed: event => {
        switch (event.key) {
        case Qt.Key_Up:
            Volume.increaseVolume();
            break;
        case Qt.Key_Down:
            Volume.decreaseVolume();
            break;
        case Qt.Key_M:
            Volume.toggleVolume();
            break;
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered: root.forceActiveFocus()

        acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton

        onClicked: event => {
            switch (event.button) {
            case Qt.LeftButton:
                Volume.toggleVolume();
                break;
            case Qt.RightButton:
                Volume.startPavucontrol();
                break;
            case Qt.MiddleButton:
                Volume.toggleDevice();
                break;
            }
        }

        onWheel: event => {
            if (event.angleDelta.y > 0) {
                Volume.increaseVolume();
            } else {
                Volume.decreaseVolume();
            }
        }
    }
}
