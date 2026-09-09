import QtQuick
import QtQuick.Controls

import qs.singletons

Slider {
    id: root

    property color shade: Themes.shade

    from: 0.0
    to: 1.0

    stepSize: 0.05
    snapMode: Slider.SnapOnRelease

    width: parent.width
    height: 6

    anchors.horizontalCenter: parent.horizontalCenter

    background: Rectangle {
        x: 0
        y: root.height / 2 - height / 2

        width: parent.width
        height: 6

        color: Qt.rgba(root.shade.r, root.shade.g, root.shade.b, 0.15)

        radius: height / 2

        Rectangle {
            width: root.visualPosition * parent.width
            height: parent.height

            radius: height / 2

            color: root.shade
        }
    }

    handle: Rectangle {
        width: 8
        height: 8

        radius: width / 2

        x: root.visualPosition * (root.width - width)
        y: root.height / 2 - height / 2

        color: root.shade
    }
}
