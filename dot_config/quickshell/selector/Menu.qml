import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Shapes
import Quickshell.Wayland
import Qt5Compat.GraphicalEffects

import qs.singletons

PanelWindow {
    id: root

    // Current index says where the picker currently resides
    property int currentIndex: Selector.active

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    aboveWindows: true

    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusiveZone: -1

    color: "transparent"

    visible: Selector.widgetVisible

    onVisibleChanged: {
        Globals.logDebug("Menu has (dis-)appeared.");
        root.currentIndex = Selector.active;
    }

    implicitWidth: Screen.width
    implicitHeight: Screen.height

    property int cardAmount: 7

    property int slant: 96
    property int cardWidth: 1920 / Math.floor((7 / 2))
    property int cardHeight: 1080 / 4

    // Background overlay
    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: 0.9
    }

    Item {
        id: item

        anchors.centerIn: parent

        width: root.width
        height: root.height

        focus: true

        property bool keysLocked: false

        Keys.onPressed: event => {
            if (!keysLocked) {
                switch (event.key) {
                case Qt.Key_Left:
                    root.currentIndex = (root.currentIndex - 1 + Selector.object.length) % Selector.object.length;
                    break;
                case Qt.Key_Right:
                    root.currentIndex = (root.currentIndex + 1) % Selector.object.length;
                    break;
                case Qt.Key_Return:
                    Selector.runCommand(Selector.object[root.currentIndex].name, Selector.object[root.currentIndex].command);
                    Selector.widgetVisible = false;
                    break;
                case Qt.Key_Escape:
                    Selector.widgetVisible = false;
                    break;
                }

                // Add a debounce timer of Themes.animationDuration
                item.keysLocked = true;
                unlockKeys.start();
            }
        }

        Timer {
            id: unlockKeys

            interval: Themes.animationDuration / 2

            onTriggered: item.keysLocked = false
        }

        Repeater {
            id: repeater

            model: Selector.object

            delegate: Loader {
                id: loader

                // This index describes where the card is in the modeldata
                required property var modelData
                required property int index

                property int distance: loader.index - root.currentIndex

                property string displayName: Selector.convertText(loader.modelData.name.toString())

                property bool isActive: loader.index === root.currentIndex

                // Distance from modeldata index to currently active card
                property real scaleFactor: Math.max(0.2, 1.0 - Math.abs(loader.distance) * 0.1)

                active: Math.abs(loader.distance) <= Math.floor(root.cardAmount / 2)

                width: root.cardWidth * loader.scaleFactor
                height: root.cardHeight * loader.scaleFactor

                x: parent.width / 2 - root.cardWidth / 2 + (loader.distance) * (root.cardWidth * 0.5)
                y: parent.height / 2 - root.cardHeight / 2

                // Active card on top
                z: 10 - Math.abs(loader.distance)

                Behavior on x {
                    enabled: loader.active

                    NumberAnimation {
                        duration: Themes.animationDuration
                        easing.type: Easing.OutCubic
                    }
                }

                Behavior on width {
                    enabled: loader.active

                    NumberAnimation {
                        duration: Themes.animationDuration
                    }
                }

                Behavior on height {
                    enabled: loader.active

                    NumberAnimation {
                        duration: Themes.animationDuration
                    }
                }

                sourceComponent: Item {
                    id: card

                    anchors.fill: parent

                    layer.enabled: card.visible
                    layer.smooth: true
                    layer.effect: OpacityMask {
                        maskSource: Shape {
                            width: card.width
                            height: card.height

                            ShapePath {
                                fillColor: "white"
                                strokeWidth: 0

                                startX: root.slant
                                startY: 0

                                PathLine {
                                    x: card.width
                                    y: 0
                                }

                                PathLine {
                                    x: card.width - root.slant
                                    y: card.height
                                }

                                PathLine {
                                    x: 0
                                    y: card.height
                                }

                                PathLine {
                                    x: root.slant
                                    y: 0
                                }
                            }
                        }
                    }

                    AnimatedImage {
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectCrop

                        // Only load the 3 images to the right and left, one middle
                        source: loader.active ? loader.modelData.path : ""
                        cache: false

                        visible: loader.active

                        playing: loader.isActive
                    }

                    // Cover right triangle
                    Shape {
                        anchors.fill: parent

                        ShapePath {
                            fillColor: "#000000"
                            strokeWidth: 0

                            startX: card.width
                            startY: 0

                            PathLine {
                                x: card.width - root.slant
                                y: card.height
                            }

                            PathLine {
                                x: card.width
                                y: card.height
                            }
                        }
                    }

                    // This is the background of the object titles
                    Shape {
                        opacity: 0.85

                        ShapePath {
                            fillColor: "#000000"
                            strokeWidth: 0

                            startX: 0
                            startY: card.height

                            PathLine {
                                x: root.slant / 6
                                y: card.height - card.height / 6
                            }

                            PathLine {
                                x: card.width + root.slant / 6
                                y: card.height - card.height / 6
                            }

                            PathLine {
                                x: card.width
                                y: card.height
                            }
                        }
                    }

                    // This is the object title
                    Text {
                        x: 36
                        y: card.height - card.height / 10

                        text: loader.displayName
                        color: "#ffffff"

                        font.pixelSize: 12

                        Behavior on color {
                            ColorAnimation {
                                duration: 150
                            }
                        }
                    }

                    // This is the card overlay for non-active tiles
                    Shape {
                        anchors.fill: parent

                        visible: !loader.isActive
                        opacity: 0.85

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 150
                            }
                        }

                        ShapePath {
                            fillColor: "#000000"
                            strokeWidth: 0

                            startX: root.slant
                            startY: 0

                            PathLine {
                                x: card.width
                                y: 0
                            }

                            PathLine {
                                x: card.width - root.slant
                                y: card.height
                            }

                            PathLine {
                                x: 0
                                y: card.height
                            }

                            PathLine {
                                x: root.slant
                                y: 0
                            }
                        }
                    }
                }
            }
        }
    }

    MouseArea {
        id: mouseArea

        hoverEnabled: true
    }
}
