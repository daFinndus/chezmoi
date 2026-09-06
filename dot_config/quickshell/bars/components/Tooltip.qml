import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.singletons

PopupWindow {
    id: root

    required property Item target
    required property string text

    property bool available: false

    visible: rect.opacity > 0

    color: "transparent"

    anchor.item: target

    anchor.gravity: Edges.Top
    anchor.edges: Edges.Bottom

    anchor.rect.x: target.width / 2
    anchor.rect.y: Themes.barHeight * 2

    implicitWidth: text.width + Themes.paddingSize * 4
    implicitHeight: text.height + Themes.paddingSize * 2

    Rectangle {
        id: rect

        anchors.fill: parent

        color: Colors.background

        border.color: Colors.color7
        border.width: 1

        radius: Themes.borderRadius

        opacity: root.available ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: Themes.animationDuration / 2
            }
        }

        Text {
            id: text

            anchors.centerIn: parent

            text: root.text

            color: Colors.foreground

            font.family: Themes.fontFamily
            font.pixelSize: Themes.fontSize
        }
    }
}
