import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Wayland

import qs.singletons
import qs.bars.modules

Scope {
    id: root

    // This is basically a boolean to wait for color fetching
    // Color fetching is done in the Colors singleton
    property bool loadColors: false

    property var leftWidgets: [
        {
            source: "WorkspaceWidget.qml",
            visible: true
        },
        {
            source: "TimeWidget.qml",
            visible: true
        },
        {
            source: "InhibitorWidget.qml",
            visible: true
        },
        {
            source: "PowerWidget.qml",
            visible: true
        },
        {
            source: "BluetoothWidget.qml",
            visible: true
        },
        {
            source: "BatteryWidget.qml",
            visible: Battery.available
        },
        {
            source: "UpdateWidget.qml",
            visible: Updates.updateCount > 0
        }
    ]

    property var rightWidgets: [
        {
            source: "TrayWidget.qml",
            visible: true
        },
        {
            source: "VirtualWidget.qml",
            visible: VPN.vpnActive
        },
        {
            source: "NetworkWidget.qml",
            visible: true
        },
        {
            source: "VolumeWidget.qml",
            visible: true
        },
        {
            source: "HomeWidget.qml",
            visible: Homeassistant.available
        },
        {
            source: "ProcessorWidget.qml",
            visible: true
        },
        {
            source: "GraphicsWidget.qml",
            visible: true
        },
        {
            source: "MemoryWidget.qml",
            visible: true
        },
        {
            source: "RootDiskWidget.qml",
            visible: true
        },
        {
            source: "HomeDiskWidget.qml",
            visible: true
        },
        {
            source: "WlogoutWidget.qml",
            visible: true
        }
    ]

    // If total is specified, reverse operations can be made
    function getBackground(total: int, item: QtObject, index: int): string {
        return Math.abs(total - index) % 2 === 0 ? Colors.color1 : Colors.background;
    }

    function getShade(total: int, item: QtObject, index: int): string {
        return Math.abs(total - index) % 2 === 0 ? Colors.color0 : Colors.color1;
    }

    PanelWindow {
        id: panel

        aboveWindows: false

        // This is needed so widgets can be focused for the keyboard
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

        color: Colors.background

        anchors {
            bottom: true
            left: true
            right: true
        }

        implicitWidth: 1920
        implicitHeight: Themes.barHeight

        RowLayout {
            id: layout

            anchors.fill: parent

            Row {
                id: leftRow

                leftPadding: 12

                Repeater {
                    model: root.leftWidgets.filter(widget => widget.visible)

                    delegate: Loader {
                        id: leftLoader

                        active: Colors.loaded

                        required property var modelData
                        required property var index

                        property var total: root.leftWidgets.filter(widget => widget.visible).length - 1

                        source: Qt.resolvedUrl("../modules/" + modelData.source)

                        onLoaded: {
                            item.background = root.getBackground(0, item, index);
                            item.shade = root.getShade(0, item, index);
                        }
                    }
                }
            }

            Item {
                Layout.fillWidth: true
            }

            Row {
                id: rightRow

                rightPadding: 12

                Repeater {
                    model: root.rightWidgets.filter(widget => widget.visible)

                    delegate: Loader {
                        id: rightLoader

                        active: Colors.loaded

                        required property var modelData
                        required property var index

                        // Gotta flip the index here, so the right-side item is backgrounded
                        property var total: root.rightWidgets.filter(widget => widget.visible).length - 1

                        source: Qt.resolvedUrl("../modules/" + modelData.source)

                        onLoaded: {
                            item.background = root.getBackground(total, item, index);
                            item.shade = root.getShade(total, item, index);
                        }
                    }
                }
            }
        }
    }
}
