pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    // This basically only holds the current theme properties
    property var theme: ({})

    property FileView file: FileView {
        path: Qt.resolvedUrl(`${Quickshell.env("XDG_CONFIG_HOME")}/themes/active.json`)

        watchChanges: true

        onFileChanged: file.reload()
        onLoaded: root.theme = JSON.parse(file.text())
    }

    onThemeChanged: {
        if (Colors.loaded) {
            root.applyTheme();
        }
    }

    // Font stuff
    property string fontFamily: "Minecraft"
    property double fontSize: 10

    // Color stuff
    property color background: "#ffffff"
    property color shade: "#000000"

    property double transparency: 0.5

    // Rectangle geometry
    property int barHeight: 22
    property int borderWidth: 0
    property int borderRadius: 0
    property int paddingSize: 12

    // Relevant for icon based themes
    property bool iconMode: false
    property string iconFont: "JetBrainsMono Nerd Font"
    property int iconSize: 11

    // Animations and so on
    property int animationDuration: 250

    IpcHandler {
        target: "theme"

        function applyTheme(): void {
            root.applyTheme();
        }
    }

    function applyTheme(): void {
        const theme = root.theme;
        const quickshell = theme.quickshell;

        Globals.logDebug("Setting theme: " + theme.name);

        root.fontFamily = theme.fontFamily ?? root.fontFamily;
        root.fontSize = theme.fontSize ?? root.fontSize;

        root.transparency = theme.transparency ?? root.transparency;

        // First fetch the color it-self, then apply transparency
        // This is necessary because otherwise it would only be the color index
        root.background = Colors.getColor(theme.background) ?? root.background;
        root.shade = Colors.getColor(theme.shade) ?? root.shade;

        root.barHeight = quickshell.barHeight ?? root.barHeight;
        root.borderWidth = quickshell.borderWidth ?? root.borderWidth;
        root.borderRadius = quickshell.borderRadius ?? root.borderRadius;
        root.paddingSize = quickshell.paddingSize ?? root.paddingSize;
        root.animationDuration = theme.animationDuration ?? root.animationDuration;

        root.iconMode = quickshell.iconMode ?? root.iconMode;
        root.iconFont = quickshell.iconFont ?? root.iconFont;
        root.iconSize = quickshell.iconSize ?? root.iconSize;

        // Lastly look where the active theme is in all themes
        root.activeThemeIndex = Globals.findIndex(root.themes, root.theme.name);

        Globals.logDebug("Background is now: " + root.background);
    }

    function setTheme(name: string) {
        setTheme.command = [`${Quickshell.env("XDG_DATA_HOME")}/../bin/theme-configurator.sh`, "set_theme", name];
        setTheme.running = true;
    }

    Process {
        id: setTheme
    }

    // This is for all available theme-json files
    property var themes: ({})
    property int activeThemeIndex: 0

    Process {
        id: getThemes
        running: true
        command: [`${Quickshell.env("XDG_DATA_HOME")}/../bin/theme-configurator.sh`, "fetch_themes"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.themes = JSON.parse(this.text.trim());
            }
        }
    }
}
