pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    // This will convert an tray icon id to an text unicode icon
    function convertId(id: string): string {
        switch (id.toLowerCase()) {
        case "chrome_status_icon_1":
            return "\udb85\udd74";
        case "discord_status_icon_1":
            return "\uf1ff";
        case "nextcloud":
            return "\uf233";
        case "steam":
            return "\uf1b6";
        case "spotify-client":
            return "\uf1bc";
        case "obs":
            return "\ueba7";
        default:
            return id;
        }
    }
}
