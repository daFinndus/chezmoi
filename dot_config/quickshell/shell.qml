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
        "prototype": Qt.resolvedUrl("themes/Prototype.qml"),
        "quattro": Qt.resolvedUrl("themes/Quattro.qml"),
        "tsoding": Qt.resolvedUrl("themes/Tsoding.qml")
    }

    Loader {
        id: loader

        active: false
        source: root.themes[Themes.theme.name] ?? Qt.resolvedUrl("themes/Tsoding.qml")

        // DesktopArea {}
        WallpaperArea {}
    }

    Connections {
        target: Colors

        function onLoadedChanged(): void {
            Globals.logDebug("Loaded for colors changed: " + Colors.loaded);

            // Gotta wait until all colors are loaded
            if (Colors.loaded) {
                // Then the theme needs to apply
                Themes.applyTheme();

                // Then the loader can load the bar
                if (!loader.active) {
                    loader.active = true;
                }
            }
        }
    }

    Menu {}
}
