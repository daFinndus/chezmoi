import QtQuick
import Quickshell.Io

import qs.singletons

Rectangle {
    id: root

    property color background: Themes.background
    property color shade: Themes.shade

    required property string text
    property bool icon: Themes.iconMode

    property real padding: Themes.paddingSize

    width: text.width + padding * 2
    height: Themes.barHeight

    color: root.background

    border.color: root.shade
    border.width: Themes.borderWidth

    radius: Themes.borderRadius

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

        font.family: root.icon ? Themes.iconFont : Themes.fontFamily
        font.pixelSize: root.icon ? Themes.iconSize : Themes.fontSize

        color: root.shade
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
