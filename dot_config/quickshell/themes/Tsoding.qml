import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Wayland

import qs.singletons
import qs.modules

Scope {
    id: root

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
    function getBackground(total: int, item: QtObject, index: int): color {
        return Math.abs(total - index) % 2 === 0 ? Themes.shade : Themes.background;
    }

    function getShade(total: int, item: QtObject, index: int): color {
        return Math.abs(total - index) % 2 === 0 ? Themes.background : Themes.shade;
    }

    PanelWindow {
        id: panel

        WlrLayershell.aboveWindows: false

        // This is needed so widgets can be focused for the keyboard
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

        color: Themes.background
        visible: Colors.loaded && Themes.loaded

        anchors {
            bottom: true
            left: true
            right: true
        }

        implicitWidth: 1920
        implicitHeight: Themes.barHeight

        Item {
            anchors.fill: parent

            Row {
                anchors.left: parent.left
                anchors.leftMargin: 12
                anchors.verticalCenter: parent.verticalCenter

                Repeater {
                    model: root.leftWidgets.filter(widget => widget.visible)

                    delegate: Loader {
                        id: leftLoader

                        required property var modelData
                        required property var index

                        property var total: root.leftWidgets.filter(widget => widget.visible).length - 1

                        source: Colors.loaded ? Qt.resolvedUrl("../modules/" + modelData.source) : ""

                        onLoaded: {
                            item.background = root.getBackground(0, item, index);
                            item.shade = root.getShade(0, item, index);
                        }
                    }
                }
            }

            Row {
                anchors.right: parent.right
                anchors.rightMargin: 12
                anchors.verticalCenter: parent.verticalCenter

                Repeater {
                    model: root.rightWidgets.filter(widget => widget.visible)

                    delegate: Loader {
                        id: rightLoader

                        required property var modelData
                        required property var index

                        // Gotta flip the index here, so the right-side item is backgrounded
                        property var total: root.rightWidgets.filter(widget => widget.visible).length - 1

                        source: Colors.loaded ? Qt.resolvedUrl("../modules/" + modelData.source) : ""

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
