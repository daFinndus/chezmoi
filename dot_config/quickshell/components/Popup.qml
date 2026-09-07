import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.singletons

PopupWindow {
    id: root

    required property Item target
    required property Component contentComponent

    property bool available: false

    visible: root.available

    color: "transparent"

    anchor.item: target

    anchor.gravity: Edges.Top
    anchor.edges: Edges.Bottom

    anchor.rect.x: target.width / 2
    anchor.rect.y: Themes.barHeight + root.implicitHeight + 5

    implicitWidth: loader.item ? loader.item.width : 0
    implicitHeight: loader.item ? loader.item.height : 0

    Rectangle {
        id: rect

        anchors.fill: parent

        color: Colors.background

        border.color: Colors.color7
        border.width: 1

        radius: Themes.borderRadius

        Loader {
            id: loader

            anchors.centerIn: parent
            sourceComponent: root.contentComponent

            width: item ? item.implicitWidth : 0
            height: item ? item.implicitHeight : 0
        }
    }
}
