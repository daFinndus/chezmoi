import QtQuick

import qs.singletons

Item {
    id: root

    property color shade: Themes.shade

    property double margin: Themes.paddingSize * 2

    anchors.horizontalCenter: parent.horizontalCenter

    width: parent.width
    height: 1 + root.margin

    Rectangle {
        anchors.centerIn: parent

        width: parent.width
        height: 1

        color: Qt.rgba(root.shade.r, root.shade.g, root.shade.b, 0.15)
    }
}
