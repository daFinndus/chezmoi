import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.singletons

PopupWindow {
    id: root

    required property Item target

    property bool available: false

    visible: rect.opacity > 0

    color: "transparent"

    anchor.item: target

    anchor.gravity: Edges.Top
    anchor.edges: Edges.Bottom

    anchor.rect.x: target.width / 2
    anchor.rect.y: Themes.barHeight + root.implicitHeight + 5

    implicitWidth: 400
    implicitHeight: 240

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

            text: "Wlogout Widget"

            color: Colors.foreground

            font.family: Themes.fontFamily
            font.pixelSize: Themes.fontSize
        }
    }
}
