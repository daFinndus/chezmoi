pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string activeTheme: "simple"
    property var themes: [
        {
            "name": "simple",
            "path": "/home/finn/.config/quickshell/assets/thumbs/japan.jpg",
            "thumb": "/home/finn/.config/quickshell/assets/thumbs/japan.jpg",
            "command": "qs ipc call theme applyTheme simple"
        },
        {
            "name": "blown",
            "path": "/home/finn/.config/quickshell/assets/thumbs/cherryblossom.jpg",
            "thumb": "/home/finn/.config/quickshell/assets/thumbs/cherryblossom.jpg",
            "command": "qs ipc call theme applyTheme blown"
        },
        {
            "name": "quattro",
            "path": "/home/finn/.config/quickshell/assets/thumbs/ayanami_rei.jpg",
            "thumb": "/home/finn/.config/quickshell/assets/thumbs/ayanami_rei.jpg",
            "command": "qs ipc call theme applyTheme quattro"
        }
    ]

    // Font stuff
    property string fontFamily: "Minecraft"
    property double fontSize: 10

    // Color stuff
    property bool transparentBackground: false

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
            switch (theme) {
            case "simple":
                Themes.applyTheme("simple");
                break;
            case "blown":
                Themes.applyTheme("blown");
                break;
            case "quattro":
                Themes.applyTheme("quattro");
                break;
            }
        }
    }

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

    function applyTheme(name): void {
        Globals.logDebug("Setting theme: " + name);

        switch (name) {
        case "simple":
            root.fontFamily = "Minecraft";
            root.fontSize = 10;
            root.barHeight = 22;
            root.borderWidth = 0;
            root.borderRadius = 0;
            root.paddingSize = 12;
            root.animationDuration = 250;
            root.iconMode = false;
            root.iconFont = "JetBrainsMono Nerd Font";
            root.iconSize = 0;
            root.applyHyprlandRules(true, false, true, 0, 0);
            break;
        case "blown":
            root.fontFamily = "JetBrainsMono Nerd Font";
            root.fontSize = 12;
            root.barHeight = 26;
            root.borderWidth = 1;
            root.borderRadius = 4;
            root.paddingSize = 16;
            root.animationDuration = 250;
            root.iconMode = false;
            root.iconFont = "JetBrainsMono Nerd Font";
            root.iconSize = 0;
            root.applyHyprlandRules(false, true, false, 4, 2);
            break;
        case "quattro":
            root.fontFamily = "Cascadia Code NF";
            root.fontSize = 14;
            root.barHeight = 36;
            root.borderWidth = 0;
            root.borderRadius = 0;
            root.paddingSize = 8;
            root.animationDuration = 250;
            root.iconMode = true;
            root.iconFont = "JetBrainsMono Nerd Font";
            root.iconSize = 15;
            root.applyHyprlandRules(true, true, false, 4, 12);
            break;
        }

        root.activeTheme = name;
        root.writeDisk(root.activeTheme);
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
