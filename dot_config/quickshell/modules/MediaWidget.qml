import QtQuick

import qs.singletons
import qs.components

Widget {
    id: root

    text: ""

    width: text.width + Themes.paddingSize * 2
    height: Themes.barHeight

    anchors.centerIn: parent

    opacity: text.text != "No players found" ? 1 : 0
    visible: root.opacity > 0

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered: root.forceActiveFocus()

        onClicked: event => {
            switch (event.button) {
            case Qt.LeftButton:
                Media.toggleTrack();
                root.opacity = 1;
                break;
            }
        }

        onWheel: event => {
            if (event.angleDelta.y > 0) {
                Media.nextTrack();
            } else {
                Media.previousTrack();
            }
        }
    }

    Text {
        id: text

        font.family: Themes.fontFamily
        font.pixelSize: Themes.fontSize

        // This is to limit the widget width
        width: Math.min(text.implicitWidth, 256)
        elide: Text.ElideRight
        wrapMode: Text.NoWrap

        property int index: 0

        color: Themes.shade

        x: parent.padding
        y: parent.padding

        anchors.centerIn: parent

        text: Media.current.length > 0 ? Media.current : "No players found"

        property var colors: [Themes.shade, Colors.getColor(2), Colors.getColor(3), Colors.getColor(4), Colors.getColor(5), Colors.getColor(6)]

        Behavior on color {
            ColorAnimation {
                duration: Themes.animationDuration
                easing.type: Easing.OutCubic
            }
        }

        Timer {
            id: getColor

            interval: 1000

            running: true
            repeat: true

            onTriggered: {
                text.index = (text.index + 1) % text.colors.length;

                text.color = text.colors[text.index];
                root.border.color = text.colors[text.index];
            }
        }
    }
}
