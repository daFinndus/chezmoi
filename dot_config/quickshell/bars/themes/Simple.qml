import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Wayland

import qs.singletons
import qs.bars.modules

Scope {
    id: root

    PanelWindow {
        id: simple

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
                leftPadding: 12

                WorkspaceWidget {
                    background: Colors.color1
                    shade: Colors.color0
                    accent: Colors.color2
                }

                TimeWidget {}

                InhibitorWidget {
                    background: Colors.color1
                    shade: Colors.color0
                }

                PowerWidget {}

                BluetoothWidget {
                    background: Colors.color1
                    shade: Colors.color0
                }

                BatteryWidget {}

                UpdateWidget {}
            }

            Item {
                Layout.fillWidth: true
            }

            Row {
                rightPadding: 12

                TrayWidget {}

                VirtualWidget {}

                NetworkWidget {
                    background: Colors.color1
                    shade: Network.online ? Colors.color7 : Colors.color0
                }

                VolumeWidget {}

                HomeWidget {
                    background: Colors.color1
                    shade: Colors.color0
                }

                ProcessorWidget {}

                GraphicsWidget {
                    background: Colors.color1
                    shade: Colors.color0
                }

                MemoryWidget {}

                RootDiskWidget {
                    background: Colors.color1
                    shade: Colors.color0
                }

                HomeDiskWidget {}

                WlogoutWidget {
                    background: Colors.color1
                    shade: Colors.color0
                }
            }
        }
    }
}
