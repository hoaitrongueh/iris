pragma ComponentBehavior: Bound
import QtQuick
import qs.services
import Caelestia.Config
import qs.components
import qs.components.controls

Rectangle {
    id: root
    required property string label
    required property real value
    property color accent: "#555e51"
    signal activated()
    signal adjusted(int direction)
    property bool interactive: false
    implicitWidth: 112; implicitHeight: 128
    radius: 16
    activeFocusOnTab: interactive
    Accessible.role: Accessible.Button
    Keys.onReturnPressed: if (interactive) activated()
    Keys.onSpacePressed: if (interactive) activated()
    Keys.onUpPressed: if (interactive) adjusted(1)
    Keys.onDownPressed: if (interactive) adjusted(-1)
    color: (hit.containsMouse || activeFocus) && interactive ? "#dedfd8" : "#eaeae5"
    Accessible.name: label + " " + Math.round(value * 100) + "%"
    CircularProgress {
        x: (parent.width - width) / 2; y: 12
        implicitSize: Math.min(parent.width - 24, 82)
        value: root.value; strokeWidth: 3; spacing: 3
        startAngle: 135; sweepAngle: 270
        fgColour: root.accent; bgColour: "#cdd0c7"
        hasEndIndicator: false
        wavy: false
        Column {
            anchors.centerIn: parent; spacing: 3
            IrisText { anchors.horizontalCenter: parent.horizontalCenter; text: Math.round(root.value * 100) + "%"; color: "#292c2a"; font.family: "JetBrains Mono"; font.pixelSize: 18; font.weight: Font.Medium; font.features: { "tnum": 1 } }
        }
    }
    IrisText { anchors.horizontalCenter: parent.horizontalCenter; anchors.bottom: parent.bottom; anchors.bottomMargin: 13; text: root.label; font.pixelSize: 11; color: "#626660" }
    MouseArea {
        id: hit; anchors.fill: parent; hoverEnabled: root.interactive; enabled: root.interactive
        cursorShape: Qt.PointingHandCursor
        onClicked: root.activated()
        onWheel: wheel => root.adjusted(wheel.angleDelta.y > 0 ? 1 : -1)
    }
}
