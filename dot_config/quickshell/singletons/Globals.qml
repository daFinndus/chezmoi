pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    readonly property string basePath: Qt.resolvedUrl("../.").toString().replace("file://", "")
    readonly property string barsPath: Qt.resolvedUrl("../bars").toString().replace("file://", "")
    readonly property string selectorPath: Qt.resolvedUrl("../selector").toString().replace("file://", "")

    readonly property string fullTime: "d. MMMM 'on a' dddd - hh:mm AP"
    readonly property string shortTime: "hh:mm AP"

    // This function iterates through an object
    // Will return the index of the matching parameter name
    function findIndex(object: var, name: string): int {
        Globals.logEverything("Object length: " + object.length);

        const index = object.findIndex(item => item.name === name);
        Globals.logEverything("Found index of " + name + " in object: " + index);
        return index === -1 ? 0 : index;
    }

    property int verbosity: 4

    function logError(message): void {
        if (root.verbosity >= 1) {
            const date = new Date();
            console.error(`${date.getMinutes()}:${date.getSeconds()}:${date.getMilliseconds()}: ${message}`);
        }
    }

    function logInfo(message): void {
        if (root.verbosity >= 2) {
            const date = new Date();

            console.warn(`${date.getMinutes()}:${date.getSeconds()}:${date.getMilliseconds()}: ${message}`);
        }
    }

    function logDebug(message): void {
        if (root.verbosity >= 3) {
            const date = new Date();
            console.log(`${date.getMinutes()}:${date.getSeconds()}:${date.getMilliseconds()}: ${message}`);
        }
    }

    function logEverything(message): void {
        if (root.verbosity >= 4) {
            const date = new Date();
            console.log(`${date.getMinutes()}:${date.getSeconds()}:${date.getMilliseconds()}: ${message}`);
        }
    }
}
