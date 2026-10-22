pragma ComponentBehavior: Bound
import "dash" as DashParts
import QtQuick
import Quickshell
import Quickshell.Services.UPower
import Caelestia.Config
import Caelestia.Services
import qs.components
import qs.components.filedialog
import qs.services

Item {
    id: root
    required property ScreenState screenState
    required property FileDialog facePicker
    implicitWidth: 800
    implicitHeight: 318
    ServiceRef { service: Cpu }
    ServiceRef { service: Memory }
    Rectangle {
        x: 8; y: 8; width: 234; height: 302; radius: IrisStyle.cardRadius
        color: "#eaeae5"
        Item { anchors.fill: parent; anchors.margins: 16; DashParts.Media {} }
    }
    Item {
        x: 264; y: 10; width: 272; height: 300
        IrisText {
            id: clock
            anchors.horizontalCenter: parent.horizontalCenter; y: 0
            text: Time.format("HH:mm")
            font.family: "Space Grotesk"; font.pixelSize: 48; font.weight: Font.Bold; font.letterSpacing: -1.4; font.features: { "tnum": 1 }
            color: "#292c2a"
        }
        IrisText { anchors.horizontalCenter: parent.horizontalCenter; y: 58; text: Time.format("ddd, dd MMMM"); font.pixelSize: 12; color: "#626660" }
        Item { x: 14; y: 95; width: parent.width - 28; height: 205; DashParts.Calendar { screenState: root.screenState } }
    }
    Grid {
        x: 558; y: 8; columns: 2; spacing: 12
        ResourceDial { label: "CPU"; value: Cpu.percentage; interactive: true; onActivated: root.screenState.dashboardTab = 2 }
        ResourceDial { label: "Memory"; value: Memory.percentage; accent: "#555e51"; interactive: true; onActivated: root.screenState.dashboardTab = 2 }
        ResourceDial {
            label: Audio.muted ? "Muted" : "Volume"; value: Audio.volume; accent: "#555e51"; interactive: true
            onActivated: Quickshell.execDetached(["qs", "-c", "workstation-controls", "ipc", "call", "controls", "reveal"])
            onAdjusted: direction => Audio.setVolume(Math.max(0, Math.min(1, Audio.volume + direction * 0.05)))
        }
        ResourceDial { label: UPower.onBattery ? "Battery" : "Charging"; value: UPower.displayDevice.percentage; accent: "#555e51"; interactive: true; onActivated: root.screenState.dashboardTab = 2 }
    }
    Row {
        x: 576; y: 284; spacing: 22
        QuickAction { icon: "apps"; accessibleName: "Applications"; command: ["/home/iris/.local/bin/iris-launcher"] }
        QuickAction { icon: "terminal"; accessibleName: "Terminal"; command: ["/home/iris/.local/bin/iris-terminal"] }
        QuickAction { icon: "folder_open"; accessibleName: "Files"; command: ["/home/iris/.local/bin/iris", "dolphin"] }
    }
    component QuickAction: Item {
        id: action
        required property string icon
        required property string accessibleName
        required property var command
        width: 40; height: 28
        Accessible.name: accessibleName
        Accessible.role: Accessible.Button
        Rectangle { anchors.fill: parent; radius: 8; color: hit.containsMouse ? "#dedfd8" : "transparent" }
        IrisIcon { anchors.centerIn: parent; text: action.icon; fontStyle: Tokens.font.icon.size(18).build(); color: "#292c2a" }
        MouseArea { id: hit; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: { root.screenState.dashboard = false; Quickshell.execDetached(action.command); } }
    }
}
