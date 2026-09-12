pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool loaded: false

    property var colors: []

    signal colorReloadRequested

    // Index is based on the color object
    // The higher the index, the brighter the color... typically
    function getColor(index: int): color {
        return root.colors.colors["color" + index] || "#5F95B7";
    }

    function reloadColors(): void {
        colorManager.reloadColors();
    }

    onColorReloadRequested: {
        colorManager.reloadColors();
    }

    Component.onCompleted: {
        colorManager.reloadColors();
    }

    QtObject {
        id: colorManager

        property var parsed: ({})
        property FileView file: FileView {
            path: Qt.resolvedUrl(`${Globals.basePath}/assets/files/colors.json`)
            preload: true

            // The next 3 options are necessary to make it interactive
            watchChanges: true

            onFileChanged: colorManager.reloadColors()
            onLoaded: colorManager.reloadColors()
        }

        function reloadColors(): void {
            // Programmatically unload the colors
            // Only relevant currently for the Simple.qml theme
            root.loaded = false;

            file.reload();

            try {
                var text = file.text();

                if (!text) {
                    console.log("Color file seems empty!");
                    return;
                }

                root.colors = JSON.parse(text);

                debounceParsing.start();

                Globals.logDebug("Updated colors object from wal-generated json.");
            } catch (e) {
                console.log("Error parsing colors file:", e);
            }
        }
    }

    Timer {
        id: debounceParsing

        interval: 500

        // Parsing needs a debounce timer
        onTriggered: root.loaded = true
    }
}
