pragma Singleton
import QtQuick
import Quickshell

Singleton {
    readonly property double fontSize: 16
    readonly property string fontFamily: "Minecraft"

    readonly property int barHeight: 36

    readonly property string configURL: Qt.resolvedUrl("../.")
    readonly property string configPath: configURL.toString().replace("file://", "")

    readonly property string fullTime: "d. MMMM 'on a' dddd - hh:mm AP"
    readonly property string shortTime: "hh:mm AP"

    readonly property int borderWidth: 2

    // This is toggled when an inhibitor is active
    property bool inhibited: false
    property bool wlogout: false

    // This is toggled when tray is hovered
    property bool trayHovered: false
    property point trayPosition: Qt.point(0, 0)

    // This is toggled when the dropdown menu is open
    property bool dropdownOpen: false
    property bool dropdownVisible: false
    property bool dropdownHovered: false
    property int dropdownTimer: 250
}
