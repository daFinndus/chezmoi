import QtQuick
import QtQuick.Controls

import qs.singletons

Item {
    id: root

    property color shade: Themes.shade

    property double minimumValue: 0.0
    property double maximumValue: 100.0
    property double actualValue: 50.0

    // This is for showing color gradient based on value
    property bool showDanger: false

    width: parent.width
    height: 6

    anchors.horizontalCenter: parent.horizontalCenter

    Rectangle {
        anchors.fill: parent

        color: Qt.rgba(root.shade.r, root.shade.g, root.shade.b, 0.15)

        radius: root.height / 2
    }

    Rectangle {
        id: overlay

        property double calculatedPercentage: (root.actualValue - root.minimumValue) / (root.maximumValue - root.minimumValue)

        width: Math.max(height, parent.width * overlay.calculatedPercentage)
        height: parent.height

        radius: height / 2

        function getDangerColor() {
            return Qt.rgba(root.shade.r, root.shade.g, root.shade.b, Math.max(0.15, 1 - overlay.calculatedPercentage));
        }

        color: showDanger ? getDangerColor() : root.shade

        Behavior on width {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutCubic
            }
        }
    }
}
