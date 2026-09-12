import QtQuick
import Quickshell.Io

import qs.singletons
import qs.components

Popup {
    id: root

    contentComponent: Rectangle {
        id: rect

        color: "transparent"

        implicitWidth: row.width
        implicitHeight: row.height

        Row {
            id: row

            spacing: Themes.paddingSize

            Section {
                profileTitle: "Power Saver"
                profileIndex: 0
                onClick: () => Power.setProfile(profileIndex)
            }

            Section {
                profileTitle: "Balanced"
                profileIndex: 1
                onClick: () => Power.setProfile(profileIndex)
            }

            Section {
                profileTitle: "Performance"
                profileIndex: 2
                onClick: () => Power.setProfile(profileIndex)
            }
        }
    }

    component Section: Rectangle {
        id: section

        required property string profileTitle
        required property int profileIndex
        required property var onClick

        width: 96
        height: 32

        property bool active: Power.powerProfileIndex === section.profileIndex

        onActiveChanged: section.setColor(mouseArea.containsMouse)

        property string background: active ? Themes.shade : Themes.background
        property string shade: active ? Themes.background : Themes.shade

        color: section.background

        border.color: section.shade
        border.width: section.active ? 0 : 1

        Behavior on color {
            ColorAnimation {
                duration: Themes.animationDuration
                easing.type: Easing.OutCubic
            }
        }

        // This is for giving color based on color, active state, and hover
        function setColor(inverted: bool): void {
            if (!section.active) {
                if (inverted) {
                    section.background = Themes.shade;
                    section.shade = Themes.background;
                    section.border.width = 0;
                } else {
                    section.background = Themes.background;
                    section.shade = Themes.shade;
                    section.border.width = 1;
                }
            }
        }

        MouseArea {
            id: mouseArea

            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor

            hoverEnabled: true
            onHoveredChanged: section.setColor(mouseArea.containsMouse)

            onClicked: section.onClick()
        }

        Text {
            anchors.centerIn: parent

            color: section.shade

            font.family: Themes.fontFamily
            font.pixelSize: Themes.fontSize * 0.8

            text: section.profileTitle

            Behavior on color {
                ColorAnimation {
                    duration: Themes.animationDuration
                    easing.type: Easing.OutCubic
                }
            }
        }
    }
}
