pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    readonly property string barsPath: Qt.resolvedUrl("../bars").toString().replace("file://", "")
    readonly property string selectorPath: Qt.resolvedUrl("../selector").toString().replace("file://", "")

    readonly property string fullTime: "d. MMMM 'on a' dddd - hh:mm AP"
    readonly property string shortTime: "hh:mm AP"

    property int verbosity: 3

    function logError(message) {
        if (root.verbosity >= 1) {
            console.error(message);
        }
    }

    function logInfo(message) {
        if (root.verbosity >= 2) {
            console.warn(message);
        }
    }

    function logDebug(message) {
        if (root.verbosity >= 3) {
            console.log(message);
        }
    }

    function logEverything(message) {
        if (root.verbosity >= 4) {
            console.log(message);
        }
    }
}
