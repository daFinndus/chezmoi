import QtQuick
import Quickshell.Io
import QtQuick.Controls

import qs.singletons
import qs.modules.components

Rectangle {
    id: root

    property real padding: 32

    width: text.width + padding * 2
    height: Globals.barHeight

    color: Colors.background

    border.color: Colors.color1
    border.width: Globals.borderWidth

    radius: Globals.borderRadius

    anchors.centerIn: parent

    opacity: text.text != "No players found" ? 1 : 0
    visible: opacity > 0

    Behavior on opacity {
        NumberAnimation {
            duration: 250
        }
    }

    Behavior on width {
        NumberAnimation {
            duration: 250
        }
    }

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

        font.family: Globals.fontFamily
        font.pixelSize: Globals.fontSize

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
