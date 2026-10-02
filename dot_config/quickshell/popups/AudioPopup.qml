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

        Column {
            visible: Audio.sinks.length > 0

            width: rootColumn.width
            spacing: Themes.paddingSize

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
                delegate: Device {
                    required property var modelData

                    identifier: modelData.name
                    type: "sink"

                    title: modelData.properties["alsa.card_name"]
                    description: modelData.properties["alsa.name"]

                    state: modelData.state
                }
            }
        }

        Column {
            visible: Audio.sources.length > 0

            width: rootColumn.width
            spacing: Themes.paddingSize

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
                delegate: Device {
                    required property var modelData

                    identifier: modelData.name
                    type: "source"

                    title: modelData.properties["alsa.card_name"]
                    description: modelData.properties["alsa.name"]

                    state: modelData.state
                }
            }
        }
    }

    // This is for changing volume
    component SliderBlock: Column {
        id: sliderBlock

        required property string title
        required property string value

        required property var onMoved

        spacing: Themes.paddingSize

        width: rootColumn.width

        KeyValueRow {
            label: sliderBlock.title
            value: sliderBlock.value <= 0 ? "Mute" : sliderBlock.value + "%"
        }

        Slider {
            from: 0.0
            to: 100.0

            stepSize: 5.0

            value: sliderBlock.value
            onMoved: sliderBlock.onMoved(value)
        }
    }

    component Device: Button {
        id: device

        required property string identifier
        required property string type

        required property string title
        required property string description

        required property string state

        active: type === "sink" ? device.identifier === Audio.defaultSink : device.identifier === Audio.defaultSource
        onClick: type === "sink" ? () => Audio.setSink(device.identifier) : () => Audio.setSource(device.identifier)

        width: rootColumn.width
        height: 32

        KeyValueRow {
            width: parent.width - Themes.paddingSize * 2
            anchors.centerIn: parent

            shade: device.shade

            label: device.title
            value: device.state

            description: device.description
        }
    }
}
