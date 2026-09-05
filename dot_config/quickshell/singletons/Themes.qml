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
            "path": "/home/finn/.config/quickshell/selector/assets/thumbs/japan.jpg",
            "thumb": "/home/finn/.config/quickshell/selector/assets/thumbs/japan.jpg",
            "command": "qs ipc call theme applyTheme simple"
        },
        {
            "name": "blown",
            "path": "/home/finn/.config/quickshell/selector/assets/thumbs/cherryblossom.jpg",
            "thumb": "/home/finn/.config/quickshell/selector/assets/thumbs/cherryblossom.jpg",
            "command": "qs ipc call theme applyTheme blown"
        },
        {
            "name": "quattro",
            "path": "/home/finn/.config/quickshell/selector/assets/thumbs/ayanami_rei.jpg",
            "thumb": "/home/finn/.config/quickshell/selector/assets/thumbs/ayanami_rei.jpg",
            "command": "qs ipc call theme applyTheme quattro"
        }
    ]

    // Font stuff
    property string fontFamily: "Minecraft"
    property double fontSize: 12

    // Rectangle geometry
    property int barHeight: 28
    property int borderWidth: 1
    property int borderRadius: 4
    property int paddingSize: 12

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

    function reloadHypr() {
        reloadHypr.running = true;
    }

    function applyHyprlandRules(no_rounding, decorate, no_border, gaps_in, gaps_out) {
        applyHypr.command = ["hyprctl", "eval", `hl.workspace_rule({ workspace = '', no_rounding = ${no_rounding}, decorate = ${decorate}, no_border = ${no_border}, gaps_in = ${gaps_in}, gaps_out = ${gaps_out}})`];
        applyHypr.running = true;
    }

    function applyTheme(name) {
        switch (name) {
        case "simple":
            root.fontFamily = "Minecraft";
            root.fontSize = 10;
            root.barHeight = 22;
            root.borderWidth = 0;
            root.borderRadius = 0;
            root.paddingSize = 12;
            root.animationDuration = 250;
            root.applyHyprlandRules(true, false, true, 0, 0);
            break;
        case "blown":
            root.fontFamily = "JetBrains Mono NF";
            root.fontSize = 12;
            root.barHeight = 26;
            root.borderWidth = 1;
            root.borderRadius = 4;
            root.paddingSize = 16;
            root.animationDuration = 250;
            root.applyHyprlandRules(false, true, false, 4, 2);
            break;
        case "quattro":
            root.fontFamily = "JetBrains Mono NF";
            root.fontSize = 14;
            root.barHeight = 32;
            root.borderWidth = 0;
            root.borderRadius = 0;
            root.paddingSize = 16;
            root.animationDuration = 250;
            root.applyHyprlandRules(false, true, false, 2, 6);
            break;
        }

        root.activeTheme = name;
        root.writeDisk(root.activeTheme);
    }

    Process {
        id: readTheme
        running: true
        command: ["cat", `${Globals.basePath}/states/theme`]
        stdout: StdioCollector {

            onStreamFinished: {
                const theme = this.text.trim();

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

    function writeDisk(name) {
        writeTheme.command = ["bash", "-c", `echo "${name}" > ${Globals.basePath}/states/theme`];
        writeTheme.running = true;
    }

    Component.onCompleted: {
        readTheme.running = true;
        root.applyTheme(root.activeTheme);
    }
}
