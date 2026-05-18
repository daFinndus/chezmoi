import QtQuick
import Quickshell
import Quickshell.Io

import qs.singletons

pragma Singleton

Singleton {
    id: root

    readonly property var colors: {
        "background": "#1C1C1C",
        "backerground": "#121212",
        "white": "#EEEEEE",
        "gray": "#656565",
        "lightgray": "#454545",
        "lightred": "#E87676",
        "lightgreen": "#71D651",
        "lightblue": "#46C1DB",
        "lime": "#7CCC5E",
        "orange": "#E88B1A",
        "winered": "#400404",
        "cyan": "#2B9E99",
        "darkcyan": "#28a69a",
        "green": "#5C9C44",
        "yellow": "#CDD433",
        "red": "#A33333"
    }
}

    // All these variables and functions are not needed anymore
    /** @deprecated
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
    */
