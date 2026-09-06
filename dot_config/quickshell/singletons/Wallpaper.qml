pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

import qs.selector

Singleton {
    id: root

    property bool widgetVisible: false

    property bool loaded: false

    onLoadedChanged: {
        Globals.logDebug("Loaded is now: " + root.loaded);
    }

    property var wallpapers: []
    property string activeWallpaper: ""

    // Returns the active wallpaper
    // Out of /tmp/wallpaper
    function fetchActive(): void {
        activeWallpaper.running = true;
    }

    Process {
        id: activeWallpaper

        running: true

        command: ["bash", "-c", "basename $(cat /tmp/wallpaper) | sed 's/\\.[^.]*$//'"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.activeWallpaper = this.text.trim();

                Selector.activeWallpaperIndex = Globals.findIndex(root.wallpapers, root.activeWallpaper);

                Globals.logDebug("Active wallpaper is: " + root.activeWallpaper);
            }
        }
    }

    // Will get wallpapers and store them into wallpaper.json
    function fetchWallpapers(): void {
        Globals.logDebug("Re-fetching wallpapers from directory.");
        getWallpapers.running = true;

        syncWallpapers.start();
    }

    Process {
        id: getWallpapers

        command: [`${Globals.basePath}/scripts/wallpaper.sh`]
    }

    // Will retrieve wallpapers from wallpaper.json
    // Put them into the wallpapers object
    function reloadWallpapers(): void {
        wallpaperManager.reloadWallpapers();
    }

    Process {
        id: watchDirectory

        running: true

        command: ["inotifywait", "-m", "-e", "create,delete,move", Quickshell.env("HOME") + "/Pictures/Wallpaper/"]

        stdout: SplitParser {
            onRead: data => {
                Globals.logDebug("Wallpaper directory changed: " + data);
                root.fetchWallpapers();
            }
        }
    }

    QtObject {
        id: wallpaperManager

        property FileView file: FileView {
            path: Qt.resolvedUrl(`${Globals.basePath}/assets/files/wallpapers.json`)
            preload: true
        }

        function reloadWallpapers(): void {
            root.loaded = false;

            file.reload();

            try {
                var text = file.text();

                if (!text) {
                    console.log("File seems empty!");
                    return;
                }

                root.wallpapers = JSON.parse(text);
                root.loaded = true;

                root.fetchActive();

                Globals.logDebug("Reloaded " + root.wallpapers.length + " wallpapers.");
            } catch (e) {
                console.log("Error parsing wallpapers file:", e);
            }
        }
    }

    Timer {
        id: syncWallpapers

        repeat: false
        interval: 300

        onTriggered: root.reloadWallpapers()
    }

    Component.onCompleted: root.fetchWallpapers()
}
