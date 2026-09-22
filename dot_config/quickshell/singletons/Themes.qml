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
    property bool transparentBackground: false

    property color background: "#ffffff"
    property color shade: "#000000"

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

        function applyTheme(theme: string): void {
            root.applyTheme(theme);
        }
    }

    function applyTheme(): void {
        const theme = root.theme;

        Globals.logDebug("Setting theme: " + theme.name);

        root.fontFamily = theme.fontFamily ?? root.fontFamily;
        root.fontSize = theme.fontSize ?? root.fontSize;

        root.transparentBackground = theme.transparentBackground ?? root.transparentBackground;

        root.background = Colors.getColor(theme.background) ?? root.background;
        root.shade = Colors.getColor(theme.shade) ?? root.shade;

        root.barHeight = theme.quickshell.barHeight ?? root.barHeight;
        root.borderWidth = theme.quickshell.borderWidth ?? root.borderWidth;
        root.borderRadius = theme.quickshell.borderRadius ?? root.borderRadius;
        root.paddingSize = theme.quickshell.paddingSize ?? root.paddingSize;
        root.animationDuration = theme.animationDuration ?? root.animationDuration;

        root.iconMode = theme.quickshell.iconMode ?? root.iconMode;
        root.iconFont = theme.quickshell.iconFont ?? root.iconFont;
        root.iconSize = theme.quickshell.iconSize ?? root.iconSize;

        // Lastly look where the active theme is in all themes
        root.activeThemeIndex = Globals.findIndex(root.themes, root.theme.name);
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
