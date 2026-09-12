import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Wayland

import qs.singletons
import qs.components

Popup {
    id: root

    contentComponent: Column {
        id: rootColumn

        width: 256
        spacing: Themes.paddingSize

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: Themes.paddingSize

            Button {
                width: 32
                height: 32

                textSize: 20

                text: "\udb81\udcae"
                onClick: "playerctl previous"
            }

            Button {
                width: 32
                height: 32

                textSize: 20

                text: "\udb81\udc0e"
                onClick: "playerctl play-pause"
            }

            Button {
                width: 32
                height: 32

                textSize: 20

                text: "\udb81\udcad"
                onClick: "playerctl next"
            }
        }

        Separator {}

        SliderBlock {
            title: "Output"
            value: Audio.sinkVolume
            onMoved: par => Audio.setSinkVolume(par)
        }

        Separator {
            shade: "transparent"
            height: 4
        }

        Repeater {
            model: Audio.sinks
            delegate: Section {
                required property var modelData

                identifier: modelData.name
                type: "sink"

                title: modelData.properties["alsa.card_name"]
                description: modelData.properties["alsa.name"]

                state: modelData.state

                onClick: () => Audio.setSink(identifier)
            }
        }

        Separator {}

        SliderBlock {
            title: "Input"
            value: Audio.sourceVolume
            onMoved: par => Audio.setSourceVolume(par)
        }

        Separator {
            shade: "transparent"
            height: 4
        }

        Repeater {
            model: Audio.sources
            delegate: Section {
                required property var modelData

                identifier: modelData.name
                type: "source"

                title: modelData.properties["alsa.card_name"]
                description: modelData.properties["alsa.name"]

                state: modelData.state

                onClick: () => Audio.setSource(identifier)
            }
        }
    }

    component SliderBlock: Column {
        id: sliderBlock

        required property string title
        required property string value

        required property var onMoved

        spacing: Themes.paddingSize

        RowLayout {
            width: rootColumn.width

            Text {
                font.family: Themes.fontFamily
                font.pixelSize: Themes.fontSize * 0.7
                font.capitalization: Font.AllUppercase

                color: Themes.shade

                text: sliderBlock.title
            }

            Item {
                Layout.fillWidth: true
            }

            Text {
                font.family: Themes.fontFamily
                font.pixelSize: Themes.fontSize * 0.7

                color: Themes.shade

                text: sliderBlock.value <= 0 ? "Mute" : sliderBlock.value + "%"
            }
        }

        Slider {
            from: 0.0
            to: 100.0

            stepSize: 5.0

            value: sliderBlock.value

            onMoved: sliderBlock.onMoved(value)
        }
    }

    // This is for the sources and sinks
    component Section: Rectangle {
        id: section

        required property string identifier
        required property string type

        required property string title
        required property string description

        required property string state

        required property var onClick

        property bool active: type === "sink" ? section.identifier === Audio.defaultSink : section.identifier === Audio.defaultSource

        onActiveChanged: section.setColor(mouseArea.containsMouse)

        property color shade: active ? Themes.background : Themes.shade
        property color background: active ? Themes.shade : Themes.background

        width: rootColumn.width
        height: row.height

        color: section.background

        border.color: Qt.rgba(section.shade.r, section.shade.g, section.shade.b, 0.5)
        border.width: section.active ? 0 : 1

        Behavior on color {
            ColorAnimation {
                duration: Themes.animationDuration
                easing.type: Easing.OutCubic
            }
        }

        // This is for giving color based on default color, active state, and hover
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

        RowLayout {
            id: row

            width: rootColumn.width

            Column {
                padding: Themes.paddingSize

                Text {
                    color: section.shade

                    font.family: Themes.fontFamily
                    font.pixelSize: Themes.fontSize * 0.7

                    text: section.title

                    Behavior on color {
                        ColorAnimation {
                            duration: Themes.animationDuration
                            easing.type: Easing.OutCubic
                        }
                    }
                }

                Text {
                    color: Qt.rgba(section.shade.r, section.shade.g, section.shade.b, 0.5)

                    font.family: Themes.fontFamily
                    font.pixelSize: Themes.fontSize * 0.6

                    text: section.description

                    Behavior on color {
                        ColorAnimation {
                            duration: Themes.animationDuration
                            easing.type: Easing.OutCubic
                        }
                    }
                }
            }

            Item {
                Layout.fillWidth: true
            }

            Text {
                rightPadding: Themes.paddingSize

                color: Qt.rgba(section.shade.r, section.shade.g, section.shade.b, 0.5)

                font.family: Themes.fontFamily
                font.pixelSize: Themes.fontSize * 0.6

                text: section.state

                Behavior on color {
                    ColorAnimation {
                        duration: Themes.animationDuration
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }
    }
}
