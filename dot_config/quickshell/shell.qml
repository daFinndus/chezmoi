//@ pragma UseQApplication

import QtQuick
import Quickshell

import qs.selector
import qs.singletons
import qs.bars.themes
import qs.bars.modules

ShellRoot {
    id: root

    property var themes: {
        "simple": Qt.resolvedUrl("bars/themes/Simple.qml"),
        "blown": Qt.resolvedUrl("bars/themes/Blown.qml"),
        "quattro": Qt.resolvedUrl("bars/themes/Quattro.qml")
    }

    Loader {
        id: loader
        active: false
        source: root.themes[Themes.activeTheme] ?? Qt.resolvedUrl("bars/themes/Simple.qml")
    }

    Connections {
        target: Themes

        function onActiveThemeChanged() {
            loader.active = false;
            loader.active = true;

            Globals.logDebug("Themes changed! It's now: " + Themes.theme);
        }
    }

    Menu {}

    Component.onCompleted: loader.active = true
}
