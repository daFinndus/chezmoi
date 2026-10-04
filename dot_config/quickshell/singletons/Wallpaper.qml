pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

import qs.selector

Singleton {
    id: root

    property bool loaded: false

    property var wallpapers: []
    property string activeWallpaper: ""
    property int activeWallpaperIndex: 0

    // Returns the active wallpaper
    // Out of /tmp/wallpaper
    function fetchActive(): void {
        activeWallpaper.running = true;
    }

    Process {
        id: activeWallpaper
        command: ["bash", "-c", `basename $(cat ${Globals.basePath}/assets/states/wallpaper) | sed 's/\\.[^.]*$//'`]

        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                root.activeWallpaper = this.text.trim();
                root.activeWallpaperIndex = Globals.findIndex(root.wallpapers, root.activeWallpaper);

                Globals.logDebug("Active wallpaper is: " + root.activeWallpaper);
            }
        }
    }

    Process {
        id: watchWallpaperState
        command: ["inotifywait", "-m", "-e", "modify", `${Globals.basePath}/assets/states/wallpaper`]

        running: true

        stdout: SplitParser {
            onRead: data => {
                root.fetchActive();
            }
        }
    }

    // Will get wallpapers and store them into wallpaper.json
    function fetchWallpapers(): void {
        Globals.logDebug("Re-fetching wallpapers from directory.");
        fetchWallpapers.running = true;
    }

    Process {
        id: fetchWallpapers
        command: [`${Globals.basePath}/scripts/wallpaper.sh`]

        stdout: StdioCollector {
            onStreamFinished: {
                wallpaperManager.reloadWallpapers();
            }
        }
    }

    function setWallpaper(path: string) {
        setWallpaper.command = [`${Quickshell.env("XDG_DATA_HOME")}/../bin/set-wallpaper.sh`, path];
        setWallpaper.running = true;
    }

    Process {
        id: setWallpaper

        stdout: StdioCollector {
            onStreamFinished: {
                root.fetchActive();
            }
        }
    }

    function removeWallpaper(index: int) {
        if (root.activeWallpaperIndex === index) {
            Globals.logDebug("Active wallpaper is being deleted!");

            let next = (index + 1) % Selector.object.length;

            root.setWallpaper(Selector.object[next].path);
        }

        removeWallpaper.command = ["rm", Selector.object[index].path];
        removeWallpaper.running = true;
    }

    Process {
        id: removeWallpaper

        stdout: StdioCollector {
            onStreamFinished: {
                Globals.logDebug("Deleted wallpaper via: " + removeWallpaper.command);
                Globals.sendNotification("Deleted wallpaper. Changes will apply after re-opening the menu.");
            }
        }
    }

    Process {
        id: watchDirectory
        command: ["inotifywait", "-m", "-e", "create,delete,move", Quickshell.env("HOME") + "/Pictures/Wallpaper/"]

        running: true

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
