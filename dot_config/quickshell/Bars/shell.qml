//@ pragma UseQApplication

import QtQuick
import Quickshell

import qs.modules
import qs.singletons
import qs.modules.widgets

Scope {
    Taskbar {}
    Statusbar {}

    Component.onCompleted: {
        Themes.reloadHypr.running = true;
    }
}
