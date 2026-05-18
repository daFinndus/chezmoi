import QtQuick
import Quickshell

pragma Singleton

Singleton {
    readonly property double fontSize: 16
    readonly property string fontFamily: "Minecraft"

    readonly property int barHeight: 36

    readonly property string configURL: Qt.resolvedUrl("../.")
    readonly property string configPath: configURL.toString().replace("file://", "")

    readonly property string fullTime: "d. MMMM 'on a' dddd - hh:mm AP"
    readonly property string shortTime: "hh:mm AP"

    readonly property int borderWidth: 2

    property bool inhibited: false
}
