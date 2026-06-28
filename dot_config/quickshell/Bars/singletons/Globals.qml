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

    // This is toggled when an inhibitor is active
    property bool inhibited: false
    property bool wlogout: false

    // This is toggled when tray is hovered
    property bool trayHovered: false
    property point trayPosition: Qt.point(0, 0)

    // This is toggled when the dropdown menu is open
    property bool wlogoutOpen: false
    property bool wlogoutVisible: false

    // This is for the statusbar
    property bool statusbarVisible: false

    // This is for the update stuff
    property bool updatesLoaded: false
    property int updateCount: 0
}
