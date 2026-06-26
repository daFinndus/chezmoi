//@ pragma UseQApplication

import QtQuick
import Quickshell

import qs.modules
import qs.singletons

Scope {
    Taskbar {}
    Statusbar {}

    Component.onCompleted: {
        Themes.reloadHypr();
    }
}
