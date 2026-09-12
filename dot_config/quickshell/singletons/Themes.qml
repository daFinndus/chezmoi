pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string activeTheme: "tsoding"

    property bool loaded: false
    property var themes: []

    property FileView file: FileView {
        path: Qt.resolvedUrl(`${Globals.basePath}/assets/files/themes.json`)
        preload: true

        watchChanges: true

        onLoaded: {
            root.themes = JSON.parse(file.text());

            Globals.logDebug("Themes file is parsed! Applying theme...");
            Themes.applyTheme(root.activeTheme);

            root.loaded = true;
        }
    }

    // Font stuff
    property string fontFamily: "Minecraft"
    property double fontSize: 10

    // Color stuff
    property bool transparentBackground: false

    property color background: "#ffffff"
    property color shade: "#000000"

    Connections {
        target: Colors

        function onLoadedChanged() {
            Themes.applyTheme(root.activeTheme);
        }
    }

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

    Process {
        id: reloadHypr
        command: ["hyprctl", "reload"]
    }

    Process {
        id: applyHypr
    }

    function reloadHypr(): void {
        reloadHypr.running = true;
    }

    function applyHyprlandRules(no_rounding, decorate, no_border, gaps_in, gaps_out): void {
        applyHypr.command = ["hyprctl", "eval", `hl.workspace_rule({ workspace = '', no_rounding = ${no_rounding}, decorate = ${decorate}, no_border = ${no_border}, gaps_in = ${gaps_in}, gaps_out = ${gaps_out}})`];
        applyHypr.running = true;
    }

    IpcHandler {
        target: "theme"

        function applyTheme(theme: string): void {
            root.applyTheme(theme);
        }
    }

    function applyTheme(theme): void {
        if (!root.loaded) {
            Globals.logDebug("Themes file not parsed yet, aborting...");
            return;
        }

        Globals.logDebug("Setting theme: " + theme);

        theme = root.themes.find(composition => composition.name === theme);

        if (!theme) {
            Globals.logDebug("Theme is not existant in json file.");
            return;
        }

        root.fontFamily = theme.fontFamily ?? root.fontFamily;
        root.fontSize = theme.fontSize ?? root.fontSize;

        root.transparentBackground = theme.transparentBackground ?? root.transparentBackground;

        root.background = Colors.getColor(theme.background) ?? root.background;
        root.shade = Colors.getColor(theme.shade) ?? root.shade;

        root.barHeight = theme.barHeight ?? root.barHeight;
        root.borderWidth = theme.borderWidth ?? root.borderWidth;
        root.borderRadius = theme.borderRadius ?? root.borderRadius;
        root.paddingSize = theme.paddingSize ?? root.paddingSize;
        root.animationDuration = theme.animationDuration ?? root.animationDuration;

        root.iconMode = theme.iconMode ?? root.iconMode;
        root.iconFont = theme.iconFont ?? root.iconFont;
        root.iconSize = theme.iconSize ?? root.iconSize;

        root.applyHyprlandRules(theme.hypr.noRounding, theme.hypr.decorate, theme.hypr.noBorder, theme.hypr.gapsIn, theme.hypr.gapsOut);

        root.activeTheme = theme.name;
        root.writeDisk(theme.name);
    }

    Process {
        id: readTheme
        running: true
        command: ["cat", `${Globals.basePath}/assets/states/theme`]
        stdout: StdioCollector {

            onStreamFinished: {
                const theme = this.text.trim();

                Globals.logDebug("The theme state is: " + theme);

                if (theme !== "") {
                    root.activeTheme = theme;
                    root.applyTheme(theme);
                }
            }
        }
    }

    Process {
        id: writeTheme
    }

    function writeDisk(name): void {
        writeTheme.command = ["bash", "-c", `echo "${name}" > ${Globals.basePath}/assets/states/theme`];
        writeTheme.running = true;
    }

    Component.onCompleted: readTheme.running = true
}
