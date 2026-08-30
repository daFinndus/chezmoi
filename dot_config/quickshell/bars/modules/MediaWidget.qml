import QtQuick

import qs.singletons
import qs.bars.modules.components

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

        color: Colors.color1

        x: parent.padding
        y: parent.padding

        anchors.centerIn: parent

        text: Media.current.length > 0 ? Media.current : "No players found"

        property var colors: [Colors.color1, Colors.color2, Colors.color3, Colors.color4, Colors.color5, Colors.color6]

        Behavior on color {
            ColorAnimation {
                duration: Globals.animationDuration
                easing.type: Easing.OutCubic
            }
        }

        Timer {
            id: getColor

            interval: 1000

            running: true
            repeat: true

            onTriggered: {
                if ((text.index + 1) == parseInt(text.colors.length)) {
                    text.index = 0;
                } else {
                    text.index = text.index + 1;
                }

                text.color = text.colors[text.index];
                root.border.color = text.colors[text.index];
            }
        }
    }
}
