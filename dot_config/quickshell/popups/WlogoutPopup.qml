import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.singletons
import qs.components

Popup {
    id: root

    contentComponent: Grid {
        id: grid

        width: 256

        columns: 2

        spacing: Themes.paddingSize / 2

        Repeater {
            model: Wlogout.systemFunctions
            delegate: Button {
                required property var modelData

                width: grid.width / 2
                height: 32

                onClickClosePopup: true

                text: modelData.text
                onClick: modelData.command
            }
        }
    }
}
