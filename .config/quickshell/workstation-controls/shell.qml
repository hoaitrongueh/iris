//@ pragma DefaultEnv QS_NO_RELOAD_POPUP=1
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Wayland

ShellRoot {
    id: root
    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property real volume: sink?.audio?.volume ?? 0
    readonly property bool muted: !!sink?.audio?.muted
    property real brightness: 0
    property bool brightnessReady: false
    property bool revealed: false

    function show(): void {
        revealed = true;
        hideTimer.restart();
    }
    function adjustVolume(value: real): void {
        if (sink?.ready && sink?.audio) {
            sink.audio.muted = false;
            sink.audio.volume = Math.max(0, Math.min(1, value));
        } else {
            Quickshell.execDetached(["wpctl", "set-volume", "-l", "1", "@DEFAULT_AUDIO_SINK@", Math.round(Math.max(0, Math.min(1, value)) * 100) + "%"]);
        }
        show();
    }
    function adjustBrightness(value: real): void {
        Quickshell.execDetached(["brightnessctl", "-e4", "set", Math.round(Math.max(0.02, Math.min(1, value)) * 100) + "%"]);
        brightness = Math.max(0.02, Math.min(1, value));
        show();
    }
    Timer { id: hideTimer; interval: 1800; onTriggered: { if (!hover.hovered) root.revealed = false; } }
    PwObjectTracker { objects: root.sink ? [root.sink] : [] }
    Connections {
        target: root.sink?.audio ?? null
        function onVolumeChanged(): void { root.show(); }
        function onMutedChanged(): void { root.show(); }
    }
    Timer {
        interval: 2000; repeat: true; running: true
        onTriggered: { if (!brightnessPoll.running) brightnessPoll.running = true; }
    }
    Process {
        id: brightnessPoll
        command: ["brightnessctl", "-m", "info"]
        stdout: StdioCollector {
            onStreamFinished: {
                const match = this.text.match(/,([0-9]+)%/);
                if (match) {
                    const value = Number(match[1]) / 100;
                    if (root.brightnessReady && Math.abs(root.brightness - value) > 0.009) root.show();
                    root.brightness = value;
                    root.brightnessReady = true;
                }
            }
        }
    }
    IpcHandler {
        target: "controls"
        function reveal(): void { root.show(); }
        function hide(): void { root.revealed = false; }
        function setVolume(percent: int): void { root.adjustVolume(percent / 100); }
        function setBrightness(percent: int): void { root.adjustBrightness(percent / 100); }
    }
    PanelWindow {
        id: panel
        anchors.right: true
        anchors.top: true
        margins.right: 68
        margins.top: 4
        implicitWidth: 294
        implicitHeight: 92
        exclusiveZone: 0
        color: "transparent"
        WlrLayershell.namespace: "workstation-controls"
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
        mask: Region { item: body }
        Rectangle {
            id: body
            x: 0
            y: root.revealed ? 0 : -100
            width: panel.width
            height: 88
            radius: 11
            color: "#e0141414"
            border.color: "#776e6e6e"
            border.width: 1
            Behavior on y { NumberAnimation { duration: 165; easing.type: Easing.OutCubic } }
            HoverHandler { id: hover; onHoveredChanged: { if (hovered) hideTimer.stop(); else if (root.revealed) hideTimer.restart(); } }
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 11
                spacing: 8
                Metric {
                    label: root.muted ? "MUTED" : "VOLUME"
                    value: root.volume
                    onChangedByUser: v => root.adjustVolume(v)
                    onWheelByUser: delta => root.adjustVolume(root.volume + delta * 0.05)
                }
                Metric {
                    label: "LIGHT"
                    value: root.brightness
                    onChangedByUser: v => root.adjustBrightness(v)
                    onWheelByUser: delta => root.adjustBrightness(root.brightness + delta * 0.05)
                }
            }
        }
    }
    component Metric: Item {
        id: metric
        required property string label
        required property real value
        signal changedByUser(real value)
        signal wheelByUser(int delta)
        Layout.fillWidth: true
        Layout.preferredHeight: 28
        Text { x: 0; y: 5; text: metric.label; color: "#d8d8d8"; font.family: "Adwaita Sans"; font.pixelSize: 10; font.weight: Font.DemiBold }
        Rectangle {
            id: track
            x: 66; y: 11
            width: metric.width - 111; height: 5; radius: 2
            color: "#555555"
            Rectangle { width: parent.width * Math.max(0, Math.min(1, metric.value)); height: parent.height; radius: 2; color: "#d5d5d5" }
            MouseArea {
                anchors.fill: parent
                anchors.topMargin: -9; anchors.bottomMargin: -9
                onPressed: mouse => metric.changedByUser(Math.max(0, Math.min(1, mouse.x / width)))
                onPositionChanged: mouse => { if (pressed) metric.changedByUser(Math.max(0, Math.min(1, mouse.x / width))); }
                onWheel: wheel => metric.wheelByUser(wheel.angleDelta.y > 0 ? 1 : -1)
            }
        }
        Text { anchors.right: parent.right; y: 3; text: Math.round(metric.value * 100) + "%"; color: "#eeeeee"; font.family: "CaskaydiaCove Nerd Font"; font.pixelSize: 12 }
    }
}
