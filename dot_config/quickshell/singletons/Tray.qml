pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    // This will convert an tray icon id to an text unicode icon
    function convertId(id: string): string {
        Globals.logDebug("Converting tray id: " + id);

        switch (id.toLowerCase()) {
        case "chrome_status_icon_1":
            return "\udb85\udd74";
        case "discord_status_icon_1":
            return "\udb81\ude6f";
        case "nextcloud":
            return "\udb81\udc8b";
        case "steam":
            return "\udb81\udcd3";
        case "spotify-client":
            return "\uf1bc";
        case "obs":
            return "\ueba7";
        case "tray-icon tray app main":
            return "\udb80\udedc";
        case "teams-for-linux_status_icon_1":
            return "\udb80\udebb";
        default:
            return id;
        }
    }
}
