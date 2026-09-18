import QtQuick
import Quickshell
import Quickshell.Io

import qs.singletons
import qs.components

Popup {
    id: root

    contentComponent: Column {
        id: rootColumn

        width: 256

        Component.onCompleted: Globals.logDebug("Home: " + Quickshell.env("HOME"))

        Section {
            title: "Border"
        }

        Section {
            title: "Font"
        }

        Section {
            title: "Color"
        }

        Separator {}

        Row {
            width: rootColumn.width
            spacing: Themes.paddingSize

            Button {
                width: (rootColumn.width - Themes.paddingSize) / 2
                height: 32

                text: "Revert"
                onClick: () => {}
            }

            Button {
                width: (rootColumn.width - Themes.paddingSize) / 2
                height: 32

                text: "Apply"
                onClick: () => {}
            }
        }
    }

    component Section: Column {
        id: section

        width: rootColumn.width

        required property string title

        Text {
            id: text

            font.family: Themes.fontFamily
            font.pixelSize: Themes.fontSize * 0.7
            font.capitalization: Font.AllUppercase

            color: Themes.shade

            text: section.title
        }

        Separator {}
    }
}
