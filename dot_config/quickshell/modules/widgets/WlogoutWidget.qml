import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import Quickshell.Wayland

import qs.singletons
import qs.modules.widgets
import qs.modules.components

Variants {
	id: root

	default property list<var> children: [
		{ command: "systemctl poweroff", inhalt: "Power Off" },
        { command: "systemctl reboot", inhalt: "Reboot" },
        { command: "systemctl suspend", inhalt: "Suspend" },
        { command: "systemctl hibernate", inhalt: "Hibernate" },
		{ command: "hyprctl dispatch 'hl.dsp.exit()'", inhalt: "Logout" },
        { command: "hyprlock", inhalt: "Lock" }
	]

	model: Quickshell.screens

	PanelWindow {
		id: window

        property var modelData
		screen: modelData

        color: Colors.colors.blurground

        visible: Globals.wlogout

		exclusionMode: ExclusionMode.Ignore

		WlrLayershell.layer: WlrLayer.Overlay
		WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

		anchors {
			top: true
			left: true
			bottom: true
			right: true
		}

		Rectangle {
            id: rectangle

			color: "transparent"
			anchors.fill: parent

			focus: mouseArea.containsMouse

			Keys.onPressed: event => {
				switch (event.key) {
					case Qt.Key_Escape:
						Globals.wlogout = false
						break
				}
			}

			MouseArea {
				id: mouseArea

				anchors.fill: parent
				
				hoverEnabled: true
				onEntered: rectangle.forceActiveFocus()

				onClicked: Globals.wlogout = false

				GridLayout {
					anchors.centerIn: parent

					width: 512
                    height: 128

					columns: 3
                    
					columnSpacing: 0
					rowSpacing: 0

					Repeater {
						model: root.children

                        delegate: Button {
                            required property var modelData

                            command: modelData.command
                            inhalt: modelData.inhalt
                        }
                    }
                }
			}
		}
	}
}
