import QtQuick
import QtQuick.Layouts

import qs.singletons

RowLayout {
    id: root

    // Basically label all to the left and on the right is value
    required property string label
    required property string value

    // Description will be shown under label
    property string description: ""

    property real fontSize: root.description != "" ? Themes.fontSize * 0.9 : Themes.fontSize

    property color shade: Themes.shade

    property bool capitalize: false

    width: parent.width

    Column {
        Text {
            font.family: Themes.fontFamily
            font.pixelSize: root.fontSize * 0.7
            font.capitalization: root.capitalize

            color: root.shade
            text: root.label
        }

        Text {
            visible: root.description != ""

            color: Globals.withAlpha(root.shade, 0.5)

            font.family: Themes.fontFamily
            font.pixelSize: root.fontSize * 0.6

            text: root.description

            bottomPadding: -2
        }
    }

    Item {
        Layout.fillWidth: true
    }

    Text {
        font.family: Themes.fontFamily
        font.pixelSize: root.fontSize * 0.7

        color: root.shade
        text: root.value
    }
}
