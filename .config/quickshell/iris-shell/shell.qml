//@ pragma DefaultEnv QS_NO_RELOAD_POPUP=1
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets

ShellRoot {
    id: root
    readonly property color ink: "#f1eeee"
    readonly property color dim: "#a9a3a6"
    readonly property color accent: "#b7c4d1"
    readonly property color glass: "#e0181c22"
    readonly property var apps: [
        {name: "Terminal", icon: "kitty", command: ["/home/iris/.local/bin/iris-terminal"]},
        {name: "Zen Browser", icon: "zen-browser", command: ["/home/iris/.local/bin/iris", "workstation-zen"]},
        {name: "Code", icon: "com.visualstudio.code.oss", command: ["/home/iris/.local/bin/iris", "workstation-editor"]},
        {name: "Files", icon: "org.kde.dolphin", command: ["/home/iris/.local/bin/iris", "dolphin"]},
        {name: "Spotify", icon: "spotify-launcher", command: ["/home/iris/.local/bin/iris", "spotify-launcher"]},
        {name: "Codex", icon: "chatgpt", command: ["/home/iris/.local/bin/iris", "chatgpt"]}
    ]
    function execute(command): void { Quickshell.execDetached(command); }
    function drawer(name): void { execute(["caelestia", "shell", "drawers", "toggle", name]); }
    IpcHandler {
        target: "shell"
        function reveal(): void { rail.revealed = true; }
        function hide(): void { rail.revealed = false; }
    }
    component Label: Text {
        color: root.ink
        font.family: "CaskaydiaCove Nerd Font"
        font.pixelSize: 11
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
    component Chip: Rectangle {
        id: chip
        property string label
        property string tip: ""
        Accessible.name: tip
        Accessible.role: Accessible.Button
        property color foreground: root.ink
        signal clicked()
        signal secondaryClicked()
        signal scrolled(int delta)
        implicitWidth: content.implicitWidth + 20
        implicitHeight: 28
        radius: 8
        color: hit.containsMouse ? "#303b48" : "transparent"
        Label { id: content; anchors.centerIn: parent; text: chip.label; color: chip.foreground }
        MouseArea {
            id: hit; anchors.fill: parent; hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: mouse => { if (mouse.button === Qt.RightButton) chip.secondaryClicked(); else chip.clicked(); }
            onWheel: wheel => chip.scrolled(wheel.angleDelta.y > 0 ? 1 : -1)
        }
    }
    PanelWindow {
        id: rail
        property bool revealed: false
        anchors.right: true
        implicitWidth: 60; implicitHeight: 380
        exclusiveZone: 0
        color: "transparent"
        WlrLayershell.namespace: "iris-rail"
        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
        mask: Region { item: hitbox }
        Item {
            id: railArea; anchors.fill: parent
            HoverHandler { id: railHover; onHoveredChanged: { if (hovered) { closeRail.stop(); rail.revealed = true; } else closeRail.restart(); } }
            Timer { id: closeRail; interval: 100; onTriggered: rail.revealed = false }
            Item { id: hitbox; x: rail.revealed ? 0 : 54; width: rail.revealed ? 60 : 6; height: rail.height }
            Rectangle {
                x: rail.revealed ? 5 : 58; y: 4; width: 48; height: 372
                radius: 15; color: root.glass; border.width: 1; border.color: "#3c4652"
                Behavior on x { NumberAnimation { duration: rail.revealed ? 90 : 110; easing.type: Easing.OutExpo } }
                Column {
                    anchors.horizontalCenter: parent.horizontalCenter; y: 8; spacing: 4
                    Chip { label: "󰍜"; implicitWidth: 36; implicitHeight: 32; foreground: root.accent; tip: "Applications · Right-click for dashboard"; onClicked: root.execute(["/home/iris/.local/bin/iris-launcher"]); onSecondaryClicked: { rail.revealed = false; root.drawer("dashboard"); } }
                    Rectangle { width: 22; height: 1; color: "#3c4652"; anchors.horizontalCenter: parent.horizontalCenter }
                    Repeater {
                        model: root.apps
                        delegate: Rectangle {
                            id: app; required property var modelData
                            Accessible.name: modelData.name
                            Accessible.role: Accessible.Button
                            width: 36; height: 36; radius: 10
                            color: appHit.containsMouse ? "#313e4c" : "transparent"
                            IconImage { anchors.centerIn: parent; implicitSize: 22; source: Quickshell.iconPath(app.modelData.icon, "application-x-executable") }
                            MouseArea { id: appHit; anchors.fill: parent; hoverEnabled: true; onClicked: { root.execute(app.modelData.command); rail.revealed = false; } }
                        }
                    }
                    Rectangle { width: 22; height: 1; color: "#3c4652"; anchors.horizontalCenter: parent.horizontalCenter }
                    Chip { label: "󰂚"; implicitWidth: 36; implicitHeight: 32; tip: "Notifications"; onClicked: { rail.revealed=false; root.drawer("sidebar"); } }
                    Chip { label: "󰐥"; implicitWidth: 36; implicitHeight: 32; tip: "Session menu"; onClicked: { rail.revealed=false; root.drawer("session"); } }
                }
            }
        }
    }
}
