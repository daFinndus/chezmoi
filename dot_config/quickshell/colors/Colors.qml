import QtQuick
import Quickshell
import Quickshell.Io

import qs.singletons

pragma Singleton

Singleton {
    id: root

    readonly property var colors: colorManager.currentColors

    signal colorReloadRequested()

    function reloadColors() {
        colorManager.reloadColors();
    }

    onColorReloadRequested: {
        colorManager.reloadColors();
    }

    QtObject {
        id: colorManager

        property var currentColors: ({})
        property bool colorsLoaded: false
        property FileView colorFile: FileView {
            path: Qt.resolvedUrl(Globals.configPath + "/colors/colors.json")
            preload: true

            // The next 3 options are necessary to make it interactive
            watchChanges: true

            onFileChanged: {
                colorManager.reloadColors();
            }

            onLoaded: {
                colorManager.reloadColors();
            }
        }

        function reloadColors() {
            colorFile.reload();

            try {
                var text = colorFile.text();
                if (!text) return;

                currentColors = JSON.parse(text);
            } catch (e) {
                console.log("Error parsing colors file:", e);
            }
        }
    }

}
