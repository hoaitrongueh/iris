pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import qs.components
import qs.services

Item {
    id: root
    required property real nonAnimWidth
    required property ScreenState screenState
    required property var tabs
    readonly property int count: tabs.length
    implicitHeight: 42
    IrisText {
        id: wordmark
        anchors.left: parent.left; anchors.leftMargin: 14
        anchors.verticalCenter: parent.verticalCenter
        text: "iris"
        font.family: "Space Grotesk"; font.pixelSize: 23; font.weight: Font.Bold; font.letterSpacing: -0.5
        color: "#292c2a"
    }
    HeaderControls {
        anchors.left: wordmark.right; anchors.leftMargin: 22
        anchors.right: navigation.left; anchors.rightMargin: 14
        anchors.verticalCenter: parent.verticalCenter
        screenState: root.screenState
        visible: width >= implicitWidth
    }
    Row {
        id: navigation
        anchors.right: parent.right; anchors.rightMargin: 10; anchors.verticalCenter: parent.verticalCenter
        spacing: 6
        Repeater {
            model: root.tabs
            delegate: Rectangle {
                id: tab
                required property var modelData
                required property int index
                readonly property bool current: root.screenState.dashboardTab === index
                width: 92; height: 32; radius: 8
                activeFocusOnTab: true
                Accessible.role: Accessible.PageTab
                Accessible.name: modelData.text
                Accessible.selected: current
                Keys.onReturnPressed: root.screenState.dashboardTab = index
                Keys.onSpacePressed: root.screenState.dashboardTab = index
                color: hit.containsMouse || activeFocus ? "#eaeae5" : "transparent"
                Behavior on color { ColorAnimation { duration: 100 } }
                IrisText {
                    anchors.centerIn: parent
                    text: tab.modelData.text === "Dashboard" ? "Overview" : tab.modelData.text === "Media" ? "Music" : tab.modelData.text === "Performance" ? "System" : tab.modelData.text
                    font.family: "Space Grotesk"; font.pixelSize: 12; font.weight: Font.Bold
                    color: tab.current ? "#292c2a" : "#626660"
                }
                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter; anchors.bottom: parent.bottom
                    width: tab.current ? 18 : 0; height: 2; radius: 1; color: "#656f5b"
                    Behavior on width { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
                }
                MouseArea {
                    id: hit; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                    onClicked: root.screenState.dashboardTab = tab.index
                    onWheel: wheel => root.screenState.dashboardTab = Math.max(0, Math.min(root.count - 1, root.screenState.dashboardTab + (wheel.angleDelta.y < 0 ? 1 : -1)))
                }
            }
        }
    }
}
