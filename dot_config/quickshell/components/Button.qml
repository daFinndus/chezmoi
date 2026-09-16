import QtQuick
import Quickshell.Io

import qs.singletons

Rectangle {
    id: root

    property color background: Themes.background
    property color shade: Themes.shade

    // This only needs to be done, if an active value is provided
    // This is used for buttons like audiosinks, powerprofiles, etc.
    onActiveChanged: Globals.setColor(root, root.active, mouseArea.containsMouse)

    // This has to be done, so if the background values change
    // E.g. through file parsing, the values in the components are updated
    Connections {
        target: Themes

        function onShadeChanged() {
            Globals.setColor(root, root.active, mouseArea.containsMouse);
        }
    }

    property int textSize: Themes.fontSize * 0.8

    // Shall the button close the corresponding popup
    property bool onClickClosePopup: false

    required property string text
    property bool active: false

    // Either pass a command to be executed in a process
    // Or a function executed from... the function
    property var onClick: undefined

    width: text.width + Themes.paddingSize * 2
    height: text.height + Themes.paddingSize

    // Border color is darker than text color
    border.color: Qt.rgba(root.shade.r, root.shade.g, root.shade.b, 0.25)
    border.width: 1

    radius: Themes.borderRadius

    color: root.background

    Behavior on color {
        ColorAnimation {
            duration: Themes.animationDuration
            easing.type: Easing.OutCubic
        }
    }

    Text {
        id: text

        font.family: Themes.fontFamily
        font.pixelSize: root.textSize

        text: root.text
        color: root.shade

        anchors.centerIn: parent

        Behavior on color {
            ColorAnimation {
                duration: Themes.animationDuration
                easing.type: Easing.OutCubic
            }
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        hoverEnabled: true
        onHoveredChanged: Globals.setColor(root, root.active, mouseArea.containsMouse)
        onClicked: {
            // Either wait for a closing popup
            // Or execute the function directly
            if (root.onClickClosePopup) {
                Globals.closePopup();
                debounceCommand.start();
            } else {
                root.runOnClick();
            }
        }
    }

    function runOnClick() {
        var type = typeof root.onClick;

        switch (type) {
        case "string":
            command.running = true;
            break;
        case "function":
            root.onClick();
            break;
        default:
            Globals.logError("onClick seems to be invalid for this button.");
            break;
        }
    }

    // Wait until the popup disappears
    // Then execute the function
    // This is so animations are done before function execution
    Timer {
        id: debounceCommand

        running: false
        interval: Themes.animationDuration

        onTriggered: root.runOnClick()
    }

    Process {
        id: command

        running: false

        command: ["bash", "-c", `${root.onClick}`]
    }
}
