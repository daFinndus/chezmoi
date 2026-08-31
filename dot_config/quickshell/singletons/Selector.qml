pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

import qs.selector

Singleton {
    id: root

    property string type: "wallpaper"

    property string active: Wallpaper.activeWallpaper
    property var object: Wallpaper.wallpapers

    property bool widgetVisible: false

    onObjectChanged: Globals.logDebug("Menu showing object with: " + root.object.length)

    IpcHandler {
        target: "menu"

        function toggleMenu(type: string): void {
            if (Selector.widgetVisible || Selector.object.length == 0) {
                Selector.widgetVisible = false;
                return;
            }

            switch (type) {
            case "wallpaper":
                Globals.logDebug("Opening Wallpaper menu!");

                root.type = "wallpaper";
                root.object = Wallpaper.wallpapers;
                root.active = Wallpaper.activeWallpaper;

                Selector.widgetVisible = !Selector.widgetVisible;
                break;
            case "theme":
                Globals.logDebug("Opening Theme menu!");

                root.type = "theme";
                root.object = Themes.themes;
                root.active = Themes.activeTheme;

                Selector.widgetVisible = !Selector.widgetVisible;
                break;
            }
        }
    }

    function runCommand(name: string, command: string) {
        executeCommand.command = ["bash", "-c", command];
        executeCommand.running = true;

        if (root.type === "wallpaper") {
            Wallpaper.activeWallpaper = name;
        }
    }

    Process {
        id: executeCommand
    }

    function convertText(text: string): string {
        // Replace all underscores
        while (text.includes("_")) {
            text = text.replace("_", " ");
        }

        return text;
    }
}
