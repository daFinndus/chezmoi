pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string type: "wallpaper"

    property var object: Wallpaper.wallpapers
    property int active: Wallpaper.activeWallpaperIndex

    property bool widgetVisible: false

    onObjectChanged: Globals.logDebug("Menu has new object with: " + root.object.length + " items.")

    IpcHandler {
        target: "menu"

        function toggleMenu(type: string): void {
            root.toggleMenu(type);
        }
    }

    function toggleMenu(type: string): void {
        if (Wallpaper.loaded) {
            switch (type) {
            case "wallpaper":
                Wallpaper.menuVisible = !Wallpaper.menuVisible;
                break;
            case "theme":
                Themes.menuVisible = !Themes.menuVisible;
                break;
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
