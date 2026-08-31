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
    property int currentIndex: root.findIndex(Selector.active)

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
        root.currentIndex = root.findIndex(Selector.active);

        if (!root.visible && Selector.type === "wallpaper") {
            Wallpaper.fetchWallpapers();
        }
    }

    implicitWidth: Screen.width
    implicitHeight: Screen.height

    property int slant: 96
    property int cardWidth: 1920 / 3
    property int cardHeight: 1080 / 4

    // This function iterates through the entries names
    // Will return the index of the matching parameter name
    function findIndex(name: string): int {
        for (var index = 0; index < Selector.object.length; ++index) {
            var comparator = Selector.object[index].name;

            if (comparator === name) {
                Globals.logDebug("Found index for object in Menu: " + index);
                return index;
            }
        }

        return 0;
    }

    // Background overlay
    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: 0.9
    }

    Item {
        anchors.centerIn: parent

        width: root.width
        height: root.height

        focus: true

        Keys.onPressed: event => {
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
        }

        Repeater {
            model: Selector.object

            delegate: Item {
                id: card

                // This index describes where the card is in the modeldata
                required property var modelData
                required property int index

                property bool isActive: index === root.currentIndex

                // Distance from modeldata index to currently active card
                property int distance: index - root.currentIndex

                property real scaleFactor: Math.max(0.2, 1.0 - Math.abs(distance) * 0.1)

                width: root.cardWidth * scaleFactor
                height: root.cardHeight * scaleFactor

                x: parent.width / 2 - cardWidth / 2 + distance * (root.cardWidth * 0.5)
                y: parent.height / 2 - cardHeight / 2

                // Active card on top
                z: 10 - Math.abs(distance)

                // Cards too far away are not rendered
                visible: Math.abs(distance) <= 4

                Behavior on x {
                    NumberAnimation {
                        duration: 100
                        easing.type: Easing.OutCubic
                    }
                }

                Behavior on width {
                    NumberAnimation {
                        duration: 200
                    }
                }

                Behavior on height {
                    NumberAnimation {
                        duration: 200
                    }
                }

                layer.enabled: true
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

                    source: modelData.path
                    cache: false

                    playing: card.isActive
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

                // Overlay stuff
                Shape {

                    visible: card.isActive
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

                Text {
                    x: 36
                    y: card.height - card.height / 10

                    visible: card.isActive

                    text: Selector.convertText(card.modelData.name.toString())
                    color: "#ffffff"

                    font.pixelSize: 12

                    Behavior on color {
                        ColorAnimation {
                            duration: 150
                        }
                    }
                }

                Shape {
                    anchors.fill: parent

                    visible: !card.isActive
                    opacity: 0.5

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

    MouseArea {
        id: mouseArea

        hoverEnabled: true
    }
}
