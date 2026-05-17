import QtQuick
import Quickshell

import qs.colors

pragma Singleton

Singleton {
    readonly property double fontSize: 16
    readonly property string fontFamily: "Minecraft"

    readonly property int barHeight: 36

    readonly property string configPath: Qt.resolvedUrl("../.")

    readonly property var colors: Colors.colors

    readonly property string backgroundColor: colors.background
    readonly property string foregroundColor: colors.white

    readonly property string fullTime: "d. MMMM 'on a' dddd - hh:mm AP"
    readonly property string shortTime: "hh:mm AP"

    readonly property string borderColor: colors.lightgray
    readonly property int borderWidth: 2

    property bool inhibited: false
}
