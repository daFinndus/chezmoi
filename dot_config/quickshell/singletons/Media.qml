pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    // This will hold the media text
    property string current: ""

    // This will store all media playing applications
    ListModel {
        id: applications
    }

    // This function is for other widgets, which cannot access the Process directly
    function updatePlayers() {
        delaySync.start();
    }

    function syncMetadatas(metadatas) {
        // This will remove any applications that are no longer playing
        for (let i = applications.count - 1; i >= 0; i--) {
            var found = false;

            for (let j = 0; j < metadatas.length; j++) {
                const parts = metadatas[j].split("/divider/");

                if (parts[0].trim() === applications.get(i).id) {
                    found = true;
                    break;
                }
            }

            if (!found) {
                applications.remove(i);
                i--;
            }
        }

        // This will add any new applications that are playing
        for (let i = 0; i < metadatas.length; i++) {
            const parts = metadatas[i].split("/divider/");

            if (parts.length < 5)
                continue;

            const id = parts[0].trim();
            const status = parts[1].trim();
            const name = parts[2].trim();
            const interpret = parts[3].trim();
            const title = parts[4].trim();
            const url = parts[5].trim();

            addApplication(id, status, name, interpret, title, url);
        }
    }

    function addApplication(id, status, name, interpret, title, url) {
        // This might be inefficient as hell, no clue
        // It works tho!
        if (url.includes("youtube")) {
            title = interpret;
            interpret = "YouTube";
        } else if (url.includes("x.com")) {
            interpret = "Twitter";
        } else if (title.includes("Prime Video")) {
            title = title.split("|")[0];
            interpret = "Prime Video";
        }

        // Check if it already exists and update if so
        for (let i = 0; i < applications.count; i++) {
            if (applications.get(i).id === id) {
                applications.setProperty(i, "id", id);
                applications.setProperty(i, "status", status);
                applications.setProperty(i, "name", name);
                applications.setProperty(i, "interpret", interpret);
                applications.setProperty(i, "title", title);
                applications.setProperty(i, "url", url);

                // This update is necessary, otherwise texts are not updated
                // when the source is still equal, e.g. in youtube
                updateText();
                return;
            }
        }

        // Otherwise, add a new entry
        applications.append({
            id: id,
            status: status,
            name: name,
            interpret: interpret,
            title: title,
            url: url
        });

        updateText();
    }

    function updateText() {
        for (let i = 0; i < applications.count; i++) {
            if (applications.get(i).status === "Playing") {
                if (applications.get(i).interpret != "") {
                    root.current = applications.get(i).interpret + ": " + applications.get(i).title;
                } else {
                    root.current = root.applications.get(i).title;
                }

                return;
            } else if (applications.get(i).id === "No players found" || applications.count == 0) {
                root.opacity = 0;
            } else {
                return applications.get(i).status;
            }
        }

        root.current = "No players found";
    }

    function nextTrack() {
        nextTrack.running = true;
    }

    function previousTrack() {
        previousTrack.running = true;
    }

    function toggleTrack() {
        toggleTrack.running = true;
    }

    Process {
        id: nextTrack
        command: ["playerctl", "next"]
    }

    Process {
        id: previousTrack
        command: ["playerctl", "previous"]
    }

    Process {
        id: toggleTrack
        command: ["playerctl", "play-pause"]
    }

    // This will query the media player for the current artist, title, and status
    Process {
        id: getPlayers

        property var metadata: "{{mpris:trackid}} /divider/ {{status}} /divider/ {{playerName}} /divider/ {{artist}} /divider/ {{title}} /divider/ {{xesam:url}}"

        command: ["playerctl", "--all-players", "metadata", "--format", metadata]

        stdout: StdioCollector {
            waitForEnd: true

            onStreamFinished: {
                var metadatas = this.text.split("\n").filter(line => line.trim().length > 0);
                root.syncMetadatas(metadatas);
            }
        }
    }

    // Otherwise the media player isn't up to date
    Timer {
        id: delaySync

        interval: 250
        onTriggered: getPlayers.running = true
    }
}
