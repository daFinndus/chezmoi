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

    color: Colors.colors.background

    border.color: Colors.colors.gray
    border.width: Globals.borderWidth

    radius: 6

    anchors.centerIn: parent

    opacity: applications.count > 0 ? 1 : 0
    visible: opacity > 0

    property string placeholder: "No players found"

    // This is for skip and previous animations
    property int direction: 1

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

    SequentialAnimation {
        id: horizontalAnimation

        NumberAnimation {
            target: text
            property: "opacity"
            to: 0
            duration: 100
        }

        NumberAnimation {
            target: text
            property: "opacity"
            to: 1
            duration: 100
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
                root.direction = 1;
                nextTrack.running = true;
            } else {
                root.direction = -1;
                previousTrack.running = true;
            }

            horizontalAnimation.start();
        }
    }

    // This will store all media playing applications
    ListModel {
        id: applications
    }

    // This is displayed when mouseArea.containsMouse is false
    Text {
        id: text

        font.family: Globals.fontFamily
        font.pixelSize: Globals.fontSize

        // This is to limit the widget width
        width: Math.min(text.implicitWidth, 456)
        elide: Text.ElideRight
        wrapMode: Text.NoWrap

        color: Colors.colors.white

        x: parent.padding
        y: parent.padding

        anchors.centerIn: parent

        text: getText()
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
        getPlayers.running = true;
    }

    // This will query the media player for the current artist, title, and status
    Process {
        id: getPlayers

        property var metadata: "{{mpris:trackid}} // {{status}} // {{playerName}} // {{artist}} // {{title}}"

        command: ["playerctl", "--all-players", "metadata", "--format", metadata]

        stdout: StdioCollector {
            waitForEnd: true

            onStreamFinished: {
                var metadatas = this.text.split("\n").filter(line => line.trim().length > 0);
                syncMetadatas(metadatas);
            }
        }
    }

    function syncMetadatas(metadatas) {
        if (metadatas == undefined) {
            console.log("Metadatas is undefined for some reason. Not good.");
            return;
        }

        console.log("Length of metadatas:", metadatas.length, "and application length:", applications.count);

        // This will remove any applications that are no longer playing
        for (let i = applications.count - 1; i >= 0; i--) {
            var found = false;

            for (let j = 0; j < metadatas.length; j++) {
                const parts = metadatas[j].split("//");

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
            const parts = metadatas[i].split("//");

            console.log("Grabbed", parts.length, "different parts from the metadata.");

            if (parts.length < 5)
                return;

            const id = parts[0].trim();
            const status = parts[1].trim();
            const name = parts[2].trim();
            const interpret = parts[3].trim();
            const title = parts[4].trim();

            addApplication(id, status, name, interpret, title);
        }

        console.log("Successfully synced", metadatas.length, "applications!");
        console.log("Applications is now at:", applications.count);
    }

    function addApplication(id, status, name, interpret, title) {
        console.log("Adding", id, "to the media player.");

        // Check if it already exists and update if so
        for (let i = 0; i < applications.count; i++) {
            if (applications.get(i).id === id) {
                console.log("The id", id, "already exists in", applications.get(i).id);

                console.log("Going to replace", applications.get(i).interpret, "with", interpret);

                applications.setProperty(i, "id", id);
                applications.setProperty(i, "status", status);
                applications.setProperty(i, "name", name);
                applications.setProperty(i, "interpret", interpret);
                applications.setProperty(i, "title", title);
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
            title: title
        });
    }

    function removeApplication(id) {
        for (let i = 0; i < applications.count; i++) {
            if (applications.get(i).id === id) {
                applications.remove(i);
                return;
            }
        }
    }

    function getText() {
        console.log("Going into text creation with a length of", applications.count);

        for (let i = 0; i < applications.count; i++) {
            console.log("Now checking", applications.get(i).id, "which has a status of", applications.get(i).status);

            if (applications.get(i).status === "Playing") {
                const text = applications.get(i).interpret + ": " + applications.get(i).title;

                if (text == "") {
                    break;
                }

                placeholder = text;

                console.log("Going to return the name", text);

                root.opacity = 1;
                return text;
            }

            if (applications.get(i).id === "No players found" || applications.count == 0) {
                root.opacity = 0;
            }
        }

        console.log("Going to return", placeholder);
        return placeholder;
    }

    Component.onCompleted: {
        updatePlayers();
    }
}
