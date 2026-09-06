pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string type: "wallpaper"

    property int activeWallpaperIndex: Globals.findIndex(root.object, Wallpaper.activeWallpaper)
    property int activeThemeIndex: Globals.findIndex(root.object, Themes.activeTheme)

    property var object: Wallpaper.wallpapers
    property string active: root.activeWallpaperIndex

    property bool widgetVisible: false

    onObjectChanged: Globals.logDebug("Menu has new object with: " + root.object.length + " items.")

    IpcHandler {
        target: "menu"

        function toggleMenu(type: string): void {
            if (Wallpaper.loaded) {
                switch (type) {
                case "wallpaper":
                    root.type = "wallpaper";
                    root.object = Wallpaper.wallpapers;
                    root.active = root.activeWallpaperIndex;

                    Globals.logDebug(`Opening ${root.type} menu, object with ${root.object.length} and active index of ${root.activeWallpaperIndex}.`);

                    root.widgetVisible = !root.widgetVisible;
                    break;
                case "theme":
                    root.type = "theme";
                    root.object = Themes.themes;
                    root.active = root.activeThemeIndex;

                    Globals.logDebug(`Opening ${root.type} menu, object with ${root.object.length} and active index of ${root.activeThemeIndex}.`);

                    root.widgetVisible = !root.widgetVisible;
                    break;
                }
            }
        }
    }

    function runCommand(name: string, command: string): void {
        executeCommand.command = ["bash", "-c", command];
        executeCommand.running = true;

        fetchActive.running = true;
    }

    // This will fetch the active wallpaper
    // Debounce time is needed, so the wallpaper can be set, than fetched
    Timer {
        id: fetchActive

        interval: 300

        onTriggered: Wallpaper.fetchActive()
    }

    Process {
        id: executeCommand
    }

    function convertText(text: string): string {
        // Replace all underscores
        return text.replace(/_/g, " ");
    }
}
