import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

ShellRoot {
    id: root
    readonly property var applications: [
                        { label: "Terminal", glyph: ">_", command: ["kitty"] },
                        { label: "Files", glyph: "▱", command: ["/home/iris/.local/bin/dolphin"] },
                        { label: "Code", glyph: "{}", command: ["code-oss"] },
                        { label: "Browser", glyph: "◉", command: ["/home/iris/.local/bin/workstation-zen"] },
                        { label: "Codex", glyph: "◎", command: ["/home/iris/.local/bin/chatgpt"] },
                        { label: "Apps", glyph: "⋮", command: ["caelestia", "shell", "drawers", "toggle", "launcher"] }
                    ]
    function launchApp(index: int): void {
        if (index >= 0 && index < applications.length)
            Quickshell.execDetached(applications[index].command);
    }
    IpcHandler {
        target: "dock"
        function launch(index: int): void { root.launchApp(index); }
        function reveal(): void { panel.revealed = true; }
    }

    PanelWindow {
        id: panel
        property bool revealed: false
        anchors.bottom: true
        margins.bottom: 0
        implicitWidth: 316
        implicitHeight: 64
        exclusiveZone: 0
        color: "transparent"
        WlrLayershell.namespace: "workstation-dock"
        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
        mask: Region { item: hitbox }

        Item {
            id: dockArea
            anchors.fill: parent
            HoverHandler {
                id: dockHover
                blocking: false
                onHoveredChanged: panel.revealed = hovered
            }
            Item {
                id: hitbox
                x: 0; y: panel.revealed ? 0 : 58
                width: panel.width; height: panel.revealed ? 64 : 6
            }
            Rectangle {
                id: body
                x: 2; y: panel.revealed ? 4 : 14
                opacity: panel.revealed ? 1 : 0
                enabled: panel.revealed

                Behavior on y {
                    NumberAnimation { duration: panel.revealed ? 180 : 120; easing.type: Easing.OutCubic }
                }
                Behavior on opacity {
                    NumberAnimation { duration: panel.revealed ? 180 : 120; easing.type: Easing.OutCubic }
                }
                width: 312; height: 48; radius: 10
                color: "#ad121212"
                border.width: 1; border.color: "#665f5f5f"
                Row {
                    anchors.centerIn: parent
                    spacing: 3
                    Repeater {
                        model: root.applications
                        delegate: Rectangle {
                            required property var modelData
                            required property int index
                            width: 46; height: 36; radius: 7
                            color: mouse.containsMouse ? "#505050" : "transparent"
                            Text { anchors.centerIn: parent; text: modelData.glyph; color: "#e0e0e0"; font.family: "Adwaita Sans"; font.pixelSize: 21 }
                            MouseArea {
                                id: mouse
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: root.launchApp(index)
                            }
                        }
                    }
                }
            }
        }
    }
}
