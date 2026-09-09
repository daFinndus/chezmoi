//@ pragma UseQApplication

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Qt5Compat.GraphicalEffects

import qs.themes
import qs.modules
import qs.selector
import qs.singletons
import qs.miscellaneous

ShellRoot {
    id: root

    property var themes: {
        "tsoding": Qt.resolvedUrl("themes/Tsoding.qml"),
        "prototype": Qt.resolvedUrl("themes/Prototype.qml"),
        "quattro": Qt.resolvedUrl("themes/Quattro.qml")
    }

    Loader {
        id: loader

        active: false
        source: root.themes[Themes.activeTheme] ?? Qt.resolvedUrl("themes/Quattro.qml")

        DesktopArea {}
        WallpaperArea {}
    }

    Connections {
        target: Themes

        function onActiveThemeChanged() {
            loader.active = true;
        }
    }

    Menu {}

    Component.onCompleted: loader.active = true
}
