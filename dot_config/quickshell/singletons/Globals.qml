pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property string basePath: Qt.resolvedUrl("../.").toString().replace("file://", "")

    readonly property string fullTime: "d. MMMM 'on a' dddd - hh:mm AP"
    readonly property string shortTime: "hh:mm AP"

    // This function iterates through an object
    // Will return the index of the matching parameter name
    function findIndex(object: var, name: string): int {
        Globals.logEverything("Object length: " + object.length);

        const index = object.findIndex(item => item.name === name);
        Globals.logDebug("Found index of " + name + " in object: " + index);
        return index === -1 ? 0 : index;
    }

    // This is to make sure a value is between two anchors
    // Only used for the Quattro bar currently
    function clamp(minimumValue: double, maximumValue: double, currentValue: double): double {
        return Math.min(maximumValue, Math.max(minimumValue, currentValue));
    }

    function withAlpha(value: color, alpha: real): color {
        return Qt.rgba(value.r, value.g, value.b, alpha);
    }

    function numberOr(value: var, fallback: real): real {
        const number = Number(value);
        return Number.isFinite(number) ? number : fallback;
    }

    // This is for giving color based on active state and (mostly) hover
    // Used a lot in different popups
    function setColor(component: var, active: bool, inverted: bool): void {
        const invert = active || inverted;

        component.background = invert ? Themes.shade : "transparent";
        component.shade = invert ? Themes.background : Themes.shade;
        component.border.width = invert ? 0 : 1;
    }

    // This will return a string with a human readable format and size extension
    function formatNetworkSpeed(speed: real, bits: bool): string {
        var units = bits ? ["bit/s", "kbit/s", "Mbit/s", "Gbit/s"] : ["B/s", "kB/s", "MB/s", "GB/s"];
        var divider = 1000;

        if (!bits) {
            speed = speed / 8;
        }

        var unit = 0;

        // Iterate through speed until it's smaller than 1000
        while (speed >= divider && unit < units.length - 1) {
            speed = speed / divider;
            unit++;
        }

        return Math.round(speed) + " " + units[unit];
    }

    function formatSizeUnit(size: real): string {
        var units = ["B", "KB", "MB", "GB", "TB", "PB"];
        var divider = 1000;

        var unit = 0;

        // Iterate through speed until it's smaller than 1000
        while (size >= divider && unit < units.length - 1) {
            size = size / divider;
            unit++;
        }

        return Math.round(size) + units[unit];
    }

    // =================== Popups ====================
    //
    //
    //
    // Relevant for opening a maximum of one single popup a time
    property QtObject activePopup: null

    function togglePopup(popup: QtObject): void {
        if (root.activePopup != popup) {
            root.closePopup();
            root.openPopup(popup);
        } else {
            root.closePopup();
        }
    }

    function openPopup(popup: QtObject): void {
        root.activePopup = popup;
        root.activePopup.available = true;
    }

    function closePopup(): void {
        if (root.activePopup) {
            root.activePopup.available = false;
            root.activePopup = null;
        }
    }

    // =================== Logging ====================
    //
    //
    //
    //
    property int verbosity: 2

    function logError(message): void {
        if (root.verbosity >= 1) {
            const date = new Date();
            console.error(`${date.getMinutes()}:${date.getSeconds()}:${date.getMilliseconds()}: ${message}`);
        }
    }

    function logDebug(message): void {
        if (root.verbosity >= 2) {
            const date = new Date();
            console.log(`${date.getMinutes()}:${date.getSeconds()}:${date.getMilliseconds()}: ${message}`);
        }
    }

    function logEverything(message): void {
        if (root.verbosity >= 3) {
            const date = new Date();
            console.log(`${date.getMinutes()}:${date.getSeconds()}:${date.getMilliseconds()}: ${message}`);
        }
    }

    function sendNotification(body: string, head = "Quickshell", urgency = "low") {
        sendNotification.command = ["notify-send", "-u", urgency, head, body];
        sendNotification.running = true;
    }

    Process {
        id: sendNotification
    }
}
