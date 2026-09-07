import QtQuick
import QtQuick.Controls

import qs.singletons

ProgressBar {
    from: 0.0
    to: 100.0

    value: 50

    background: Rectangle {
        height: 6
        radius: 6
        color: Colors.background
    }
}
