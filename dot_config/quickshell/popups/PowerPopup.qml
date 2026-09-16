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
                profileTitle: "Power Saver"
                profileIndex: 0
            }

            ProfileButton {
                profileTitle: "Balanced"
                profileIndex: 1
            }

            ProfileButton {
                profileTitle: "Performance"
                profileIndex: 2
            }
        }
    }

    component ProfileButton: Button {
        id: profile

        required property string profileTitle
        required property int profileIndex

        width: 96
        height: 32

        active: Power.powerProfileIndex === profile.profileIndex
        text: profile.profileTitle

        onClick: () => Power.setProfile(profile.profileIndex)
    }
}
