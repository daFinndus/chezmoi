import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Hyprland

import qs.singletons

Item {
    id: root

    property Component contentComponent
    required property string icon

    property bool available: false

    implicitWidth: widget.width
    implicitHeight: widget.height

    Widget {
        id: widget

        background: "transparent"
        text: root.icon

        MouseArea {
            enabled: root.contentComponent != undefined

            anchors.fill: parent

            cursorShape: Qt.PointingHandCursor
            onClicked: Globals.togglePopup(root)
        }
    }

    PopupWindow {
        id: popup

        visible: root.available

        color: Globals.withAlpha(Themes.background, Themes.transparency)

        anchor.item: widget

        anchor.gravity: Edges.Bottom
        anchor.edges: Edges.Bottom

        anchor.rect.x: root.width / 2
        anchor.rect.y: Themes.barHeight + Themes.paddingSize

        implicitWidth: loader.item ? loader.item.width + Themes.paddingSize * 4 : 0
        implicitHeight: loader.item ? loader.item.height + Themes.paddingSize * 4 : 0

        HyprlandFocusGrab {
            id: grab

            active: root.available
            windows: [popup]

            onCleared: Globals.closePopup()
        }

        Rectangle {
            id: rect

            anchors.fill: parent

            visible: root.contentComponent != undefined

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
}
