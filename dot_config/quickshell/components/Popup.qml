import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Hyprland

import qs.singletons

PopupWindow {
    id: root

    required property Item target
    required property Component contentComponent

    property bool available: false

    visible: root.available

    color: Qt.rgba(Themes.background.r, Themes.background.g, Themes.background.b, Themes.transparency)

    anchor.item: target

    anchor.gravity: Edges.Top
    anchor.edges: Edges.Bottom

    anchor.rect.x: target.width / 2
    anchor.rect.y: Themes.barHeight + root.implicitHeight + 5

    implicitWidth: loader.item ? loader.item.width + Themes.paddingSize * 4 : 0
    implicitHeight: loader.item ? loader.item.height + Themes.paddingSize * 4 : 0

    HyprlandFocusGrab {
        id: grab

        active: root.available
        windows: [root]

        onCleared: Globals.closePopup()
    }

    Rectangle {
        id: rect

        anchors.fill: parent

        color: "transparent"

        border.color: Themes.shade
        border.width: 1

        radius: Themes.borderRadius

        Loader {
            id: loader

            anchors.centerIn: parent
            sourceComponent: root.contentComponent
        }
    }
}
