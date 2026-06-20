import QtQuick
import Quickshell.Io
import QtQuick.Controls

import qs.singletons
import qs.modules.components

Rectangle {
    id: root

    property real padding: 32

    width: text.width + padding * 2
    height: Globals.barHeight

    color: Colors.background

    border.color: Colors.color1
    border.width: Globals.borderWidth

    radius: Globals.borderRadius

    anchors.centerIn: parent

    opacity: text.text != "No players found" ? 1 : 0
    visible: opacity > 0

    // This will hold the media text
    property string current: ""

    onCurrentChanged: fadeAnimation.restart()

    Behavior on opacity {
        NumberAnimation {
            duration: 250
        }
    }

    Behavior on width {
        NumberAnimation {
            duration: 250
        }
    }

    // This is only for the text widget, nice animations
    SequentialAnimation {
        id: fadeAnimation

        NumberAnimation {
            target: text
            property: "opacity"
            to: 0
            duration: 250
        }

        NumberAnimation {
            target: text
            property: "opacity"
            to: 1
            duration: 250
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered: root.forceActiveFocus()

        onClicked: event => {
            switch (event.button) {
            case Qt.LeftButton:
                toggleTrack.running = true;
                root.opacity = 1;
                break;
            }
        }

        onWheel: event => {
            if (event.angleDelta.y > 0) {
                nextTrack.running = true;
            } else {
                previousTrack.running = true;
            }
        }
    }

    // This will store all media playing applications
    ListModel {
        id: applications
    }

    Text {
        id: text

        font.family: Globals.fontFamily
        font.pixelSize: Globals.fontSize

        // This is to limit the widget width
        width: Math.min(text.implicitWidth, 256)
        elide: Text.ElideRight
        wrapMode: Text.NoWrap

        property int index: 0

        color: Colors.color1

        x: parent.padding
        y: parent.padding

        anchors.centerIn: parent

        text: root.current.length > 0 ? root.current : "No players found"

        property var colors: [Colors.color1, Colors.color2, Colors.color3, Colors.color4, Colors.color5, Colors.color6]

        Behavior on color {
            ColorAnimation {
                duration: Globals.animationDuration
                easing.type: Easing.OutCubic
            }
        }

        Timer {
            id: getColor

            interval: 1000

            running: true
            repeat: true

            onTriggered: {
                if ((text.index + 1) == parseInt(text.colors.length)) {
                    text.index = 0;
                } else {
                    text.index = text.index + 1;
                }

                text.color = text.colors[text.index];
                root.border.color = text.colors[text.index];
            }
        }
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

    // This function is for other widgets, which cannot access the Process directly
    function updatePlayers() {
        delaySync.start();
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
                syncMetadatas(metadatas);
            }
        }
    }

    // Otherwise the media player isn't up to date
    Timer {
        id: delaySync

        interval: 250
        onTriggered: getPlayers.running = true
    }

    function syncMetadatas(metadatas) {
        console.log("Length of metadatas:", metadatas.length, "and application length:", applications.count);

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
                console.log(applications.get(i).name, "is not active anymore!");

                applications.remove(i);
                i--;
            }
        }

        // This will add any new applications that are playing
        for (let i = 0; i < metadatas.length; i++) {
            const parts = metadatas[i].split("/divider/");

            console.log("Grabbed", parts.length, "different parts from the metadata.");

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

        console.log("Successfully synced", metadatas.length, "applications!");
        console.log("Applications is now at:", applications.count);
    }

    function addApplication(id, status, name, interpret, title, url) {
        console.log("Adding", id, "to the media player.");

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

        console.log("The id", id, "doesn't exist yet, creating entry...");

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
        console.log("Going into text creation with a length of", applications.count);

        for (let i = 0; i < applications.count; i++) {
            console.log("Now checking", applications.get(i).id, "which has a status of", applications.get(i).status);

            if (applications.get(i).status === "Playing") {
                if (applications.get(i).interpret != "") {
                    current = applications.get(i).interpret + ": " + applications.get(i).title;
                } else {
                    current = applications.get(i).title;
                }

                console.log("Going to return the name", current);

                return;
            } else if (applications.get(i).id === "No players found" || applications.count == 0) {
                root.opacity = 0;
            } else {
                return applications.get(i).status;
            }
        }

        current = "No players found";
    }

    Component.onCompleted: {
        updatePlayers();
    }
}
