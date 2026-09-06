import QtQuick
import Quickshell.Io

import qs.singletons

Rectangle {
    id: root

    property string background: Colors.background
    property string shade: Colors.color1

    required property string text
    property bool icon: Themes.iconMode

    property real padding: Themes.paddingSize

    width: text.width + padding * 2
    height: Themes.barHeight

    border.color: root.shade
    border.width: Themes.borderWidth

    Component.onCompleted: {
        Globals.logDebug("The border radius is: " + root.radius);
    }

    radius: Themes.borderRadius

    onRadiusChanged: {
        Globals.logDebug("Radius is now: " + root.radius);
        Globals.logDebug("Width is: " + border.width);
        Globals.logDebug("Active theme is: " + Themes.fontSize);
    }

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
