pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

import qs.selector

Singleton {
    id: root

    property bool widgetVisible: false

    property var wallpapers: []
    property string activeWallpaper: ""

    function fetchActive() {
        activeWallpaper.running = true;
    }

    Process {
        id: activeWallpaper
        running: true

        command: ["bash", "-c", "basename $(cat /tmp/wallpaper) | sed 's/\\.[^.]*$//'"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.activeWallpaper = this.text.trim();

                Globals.logDebug("Active wallpaper is: " + root.activeWallpaper);
            }
        }
    }

    function fetchWallpapers() {
        Globals.logDebug("Re-fetching wallpapers from directory.");
        getWallpapers.running = true;

        syncWallpapers.start();
    }

    Process {
        id: getWallpapers

        command: ["bash", "-c", `${Globals.selectorPath}/scripts/wallpaper.sh`]
    }

    function reloadWallpapers() {
        wallpaperManager.reloadWallpapers();
    }

    QtObject {
        id: wallpaperManager

        property FileView file: FileView {
            path: Qt.resolvedUrl(Globals.selectorPath + "/assets/wallpapers.json")
            preload: true

            // The next 3 options are necessary to make it interactive
            watchChanges: true

            onFileChanged: syncWallpapers.start()
        }

        function reloadWallpapers() {
            file.reload();

            try {
                var text = file.text();

                if (!text) {
                    console.log("File seems empty!");
                    return;
                }

                root.wallpapers = JSON.parse(text);
                Globals.logDebug("Reloaded " + root.wallpapers.length + " wallpapers.");
            } catch (e) {
                console.log("Error parsing wallpapers file:", e);
            }
        }
    }

    Timer {
        id: syncWallpapers

        repeat: false
        interval: 5000

        onTriggered: root.reloadWallpapers()
    }

    Component.onCompleted: root.fetchWallpapers()
}
