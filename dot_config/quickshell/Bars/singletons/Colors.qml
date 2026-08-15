pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string background: "#1C1C1C"
    property string foreground: "#EEEEEE"
    property string cursor: "#EEEEEE"
    property string color0: "#656565"
    property string color1: "#454545"
    property string color2: "#E87676"
    property string color3: "#71D651"
    property string color4: "#46C1DB"
    property string color5: "#7CCC5E"
    property string color6: "#E88B1A"
    property string color7: "#400404"
    property string color8: "#2B9E99"
    property string color9: "#28A69A"
    property string color10: "#63A24C"
    property string color11: "#CDD433"
    property string color12: "#A33333"
    property string color13: "#400404"
    property string color14: "#46C1DB"
    property string color15: "#454545"

    signal colorReloadRequested

    function reloadColors() {
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
        property bool loaded: false
        property FileView file: FileView {
            path: Qt.resolvedUrl(Globals.configPath + "/files/colors.json")
            preload: true

            // The next 3 options are necessary to make it interactive
            watchChanges: true

            onFileChanged: {
                Themes.reloadHypr();
                colorManager.reloadColors();
            }

            onLoaded: {
                colorManager.reloadColors();
            }
        }

        function reloadColors() {
            file.reload();

            try {
                var text = file.text();

                if (!text) {
                    console.log("File seems empty!");
                    return;
                }

                parsed = JSON.parse(text);

                root.background = parsed.special.background;
                root.foreground = parsed.special.foreground;
                root.cursor = parsed.special.cursor;
                root.color0 = parsed.colors.color0;
                root.color1 = parsed.colors.color1;
                root.color2 = parsed.colors.color2;
                root.color3 = parsed.colors.color3;
                root.color4 = parsed.colors.color4;
                root.color5 = parsed.colors.color5;
                root.color6 = parsed.colors.color6;
                root.color7 = parsed.colors.color7;
                root.color8 = parsed.colors.color8;
                root.color9 = parsed.colors.color9;
                root.color10 = parsed.colors.color10;
                root.color11 = parsed.colors.color11;
                root.color12 = parsed.colors.color12;
                root.color13 = parsed.colors.color13;
                root.color14 = parsed.colors.color14;
                root.color15 = parsed.colors.color15;
            } catch (e) {
                console.log("Error parsing colors file:", e);
            }
        }
    }
}
