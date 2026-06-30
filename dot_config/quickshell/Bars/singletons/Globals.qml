pragma Singleton

import QtQuick
import Quickshell

Singleton {
    readonly property double fontSize: 12
    readonly property string fontFamily: "Minecraft"

    readonly property int barHeight: 28

    readonly property int animationDuration: 250

    readonly property string configURL: Qt.resolvedUrl("../.")
    readonly property string configPath: configURL.toString().replace("file://", "")

    readonly property string fullTime: "d. MMMM 'on a' dddd - hh:mm AP"
    readonly property string shortTime: "hh:mm AP"

    readonly property int borderWidth: 1
    readonly property int borderRadius: 4

    // This is for the statusbar
    property bool statusbarVisible: true

    function reloadComponents() {
        Themes.reloadHypr();
        Updates.refreshUpdates();
        Network.refreshNetworkState();
        Battery.refreshBattery();
        Media.updatePlayers();
        Hardware.updateHardware();
    }

    Component.onCompleted: reloadComponents()
}
