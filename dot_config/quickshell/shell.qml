//@ pragma UseQApplication

import QtQuick
import Quickshell
import Quickshell.Io

import qs.themes
import qs.modules
import qs.selector
import qs.singletons
import qs.miscellaneous

ShellRoot {
    id: root

    property var themes: {
        "simple": Qt.resolvedUrl("themes/Simple.qml"),
        "blown": Qt.resolvedUrl("themes/Blown.qml"),
        "quattro": Qt.resolvedUrl("themes/Quattro.qml")
    }

    Loader {
        id: loader

        active: false
        source: root.themes[Themes.activeTheme] ?? Qt.resolvedUrl("themes/Simple.qml")

        DesktopArea {}
        WallpaperArea {}
    }

    Connections {
        target: Themes

        function onActiveThemeChanged() {
            loader.active = true;

            Globals.logDebug("Themes changed! It's now: " + Themes.activeTheme);
        }
    }

    Menu {}

    Component.onCompleted: loader.active = true
}
