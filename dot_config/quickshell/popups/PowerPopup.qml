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

            ProfileButton {
                display: "Power Saver"
                name: "power-saver"
            }

            ProfileButton {
                display: "Balanced"
                name: "balanced"
            }

            ProfileButton {
                display: "Performance"
                name: "performance"
            }
        }
    }

    component ProfileButton: Button {
        id: profile

        required property string display
        required property string name

        width: 96
        height: 32

        active: Power.profile == profile.name
        text: profile.display

        onClick: () => Power.setProfile(profile.name)
    }
}
