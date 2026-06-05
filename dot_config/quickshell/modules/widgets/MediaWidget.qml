import QtQuick
import Quickshell.Io

import qs.singletons
import qs.modules.components

Rect {
    farbe: Colors.colors.white
    inhalt: getText()

    anchors.centerIn: parent

    opacity: playing ? 1 : 0
    visible: opacity > 0

    property string media: "No players"
    property bool playing: false

    property string player: ""

    Behavior on opacity {
        NumberAnimation {
            duration: 250
        }
    }

    function runCheckPlayerctl() {
        checkPlayerctl.running = true
    }

    Process {
        id: checkPlayerctl

        command: ["playerctl", "status"]

        stdout: StdioCollector  {
            waitForEnd: true

            onStreamFinished: {
                media = this.text.trim()
                verifyStatus()
            }
        }
    }

    function verifyStatus() {
        switch (media) {
            case "Playing":
                playing = true
                break
            case "Paused":
                playing = true
                break
            case "Stopped":
                playing = false
                break
            default:
                playing = false
                console.log("Unknown status. Probably empty.")
        }

        if (playing) checkPlayer.running = true
        if (!playing) player = "No players"
    }

    Process {
        id: checkPlayer

        command: ["playerctl", "-l"]

        stdout: StdioCollector {
            waitForEnd: true

            onStreamFinished: {
                player = this.text.trim()
                console.log("Player:", player)
            }
        }
    }

    function getText() {
        if (player == "") return "No players"
        return player
    }
}
