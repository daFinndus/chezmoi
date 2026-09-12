pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

import qs.selector

Singleton {
    id: root

    property bool widgetVisible: false

    property bool loaded: false

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

        command: ["bash", "-c", `basename $(cat ${Globals.basePath}/assets/states/wallpaper) | sed 's/\\.[^.]*$//'`]

        stdout: StdioCollector {
            onStreamFinished: {
                root.activeWallpaper = this.text.trim();

                Selector.activeWallpaperIndex = Globals.findIndex(root.wallpapers, root.activeWallpaper);

                Globals.logDebug("Active wallpaper is: " + root.activeWallpaper);
            }
        }
    }

    Process {
        id: watchWallpaperState

        running: true

        command: ["inotifywait", "-m", "-e", "modify", `${Globals.basePath}/assets/states/wallpaper`]

        stdout: SplitParser {
            onRead: data => {
                root.fetchActive();
            }
        }
    }

    // Will get wallpapers and store them into wallpaper.json
    function fetchWallpapers(): void {
        Globals.logDebug("Re-fetching wallpapers from directory.");
        getWallpapers.running = true;
    }

    Process {
        id: getWallpapers

        command: [`${Globals.basePath}/scripts/wallpaper.sh`]

        stdout: StdioCollector {
            onStreamFinished: {
                wallpaperManager.reloadWallpapers();
            }
        }
    }

    Process {
        id: watchDirectory

        running: true

        command: ["inotifywait", "-m", "-e", "create,delete,move", Quickshell.env("HOME") + "/Pictures/Wallpaper/"]

        stdout: SplitParser {
            onRead: data => {
                Globals.logDebug("Event happened in wallpaper directory: " + data);
                root.fetchWallpapers();
            }
        }
    }

    // Will retrieve wallpapers from wallpaper.json
    // Put them into the wallpapers object
    function reloadWallpapers(): void {
        wallpaperManager.reloadWallpapers();
    }

    QtObject {
        id: wallpaperManager

        property FileView file: FileView {
            path: Qt.resolvedUrl(`${Globals.basePath}/assets/files/wallpapers.json`)

            onLoaded: wallpaperManager.processWallpapers()
        }

        function reloadWallpapers(): void {
            root.loaded = false;
            file.reload();
        }

        function processWallpapers(): void {
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

    Component.onCompleted: root.fetchWallpapers()
}
