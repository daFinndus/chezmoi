import QtQuick
import Quickshell
import Quickshell.Io

import qs.singletons
import qs.modules.components

Rect {
    id: root

    farbe: getColor()
    inhalt: Volume.getText()

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

    function getColor() {
        if (Volume.volume === 0) {
            return Colors.color1;
        } else if (Volume.volume > 0 && Volume.volume <= 15) {
            return Colors.color2;
        } else if (Volume.volume > 15 && Volume.volume <= 50) {
            return Colors.color3;
        } else if (Volume.volume > 50 && Volume.volume <= 80) {
            return Colors.color4;
        } else {
            return Colors.color5;
        }
    }
}
