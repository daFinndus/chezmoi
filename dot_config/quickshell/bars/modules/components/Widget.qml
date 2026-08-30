import QtQuick
import Quickshell.Io

import qs.singletons

Rectangle {
    id: root

    property string background: Colors.background
    property string shade: Colors.color1

    required property string text

    property real padding: Themes.paddingSize

    width: text.width + padding * 2
    height: Themes.barHeight

    border.color: root.shade
    border.width: Themes.borderWidth

    radius: Themes.borderRadius

    color: root.background

    Behavior on opacity {
        NumberAnimation {
            duration: Themes.animationDuration
        }
    }

    Behavior on width {
        NumberAnimation {
            duration: Themes.animationDuration / 2
        }
    }

    Text {
        id: text

        font.family: Themes.fontFamily
        font.pixelSize: Themes.fontSize

        color: root.shade

        x: parent.padding
        y: parent.padding

        anchors.centerIn: parent

        text: root.text

        Behavior on color {
            ColorAnimation {
                duration: Themes.animationDuration * 2
                easing.type: Easing.OutCubic
            }
        }
    }
}
