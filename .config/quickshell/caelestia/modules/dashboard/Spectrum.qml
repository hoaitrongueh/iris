pragma ComponentBehavior: Bound
import QtQuick
import Caelestia.Services
import qs.services

Item {
    id: root
    property bool active: visible && (Players.active?.isPlaying ?? false)
    property color accent: "#626660"
    readonly property int barCount: 32
    readonly property var levels: active ? Audio.cava.values : []
    ServiceRef { service: root.active ? Audio.cava : null }
    Row {
        anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom
        spacing: 3
        Repeater {
            model: root.barCount
            Rectangle {
                required property int index
                readonly property int sourceIndex: Math.min(Math.max(0, root.levels.length - 1), Math.floor(index * root.levels.length / root.barCount))
                readonly property real magnitude: root.active ? Math.min(1, Math.max(0, root.levels[sourceIndex] ?? 0)) : 0
                width: Math.max(1, (root.width - (root.barCount - 1) * 3) / root.barCount)
                height: Math.max(2, magnitude * root.height)
                anchors.bottom: parent.bottom
                radius: 1.5
                color: root.accent
                opacity: root.active ? 0.95 : 0.3
                Behavior on height { NumberAnimation { duration: 75; easing.type: Easing.OutQuad } }
            }
        }
    }
}
