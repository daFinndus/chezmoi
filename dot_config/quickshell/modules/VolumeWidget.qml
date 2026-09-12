import QtQuick

import qs.singletons
import qs.popups
import qs.components

Widget {
    id: root

    text: Themes.iconMode ? "\uefcf" : Audio.getText()

    Keys.enabled: !Themes.iconMode
    Keys.onPressed: event => {
        switch (event.key) {
        case Qt.Key_Up:
            Audio.increaseVolume();
            break;
        case Qt.Key_Down:
            Audio.decreaseVolume();
            break;
        case Qt.Key_M:
            Audio.toggleVolume();
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
            if (Themes.iconMode) {
                Globals.togglePopup(popup);
            } else {
                switch (event.button) {
                case Qt.LeftButton:
                    Audio.setSinkVolume(0);
                    break;
                case Qt.RightButton:
                    Audio.startPavucontrol();
                    break;
                case Qt.MiddleButton:
                    Audio.toggleDevice();
                    break;
                }
            }
        }

        onWheel: event => {
            // Not needed in icon mode
            if (Themes.iconMode) {
                return;
            }

            var volumeDelta = ((event.angleDelta.y / 120) * 5) + Audio.sinkVolume;
            volumeDelta = Globals.clamp(0, 100, volumeDelta);

            Audio.setSinkVolume(volumeDelta);
        }
    }

    VolumePopup {
        id: popup
        target: root
    }
}
