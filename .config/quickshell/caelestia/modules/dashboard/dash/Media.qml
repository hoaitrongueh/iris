pragma ComponentBehavior: Bound
import ".." as Dashboard
import QtQuick
import Caelestia.I18n
import qs.components.controls
import Caelestia.Config
import qs.components
import qs.services

Item {
    id: root
    anchors.fill: parent
    readonly property var player: Players.active
    Item {
        width: parent.width; height: 90
        Rectangle {
            id: art
            x: 0; y: 5; width: 64; height: 64; radius: 8; color: "#dedfd8"; clip: true
            Image { anchors.fill: parent; source: Players.getArtUrl(root.player); fillMode: Image.PreserveAspectCrop; asynchronous: true }
            IrisIcon { visible: !root.player; anchors.centerIn: parent; text: "music_note"; fontStyle: Tokens.font.icon.size(28).build(); color: "#626660" }
        }
        Column {
            x: 78; y: 10; width: parent.width - 78; spacing: 8
            IrisText { width: parent.width; text: root.player?.trackTitle || "—"; color: "#292c2a"; font.pixelSize: 14; font.weight: Font.Bold; elide: Text.ElideRight; maximumLineCount: 2; wrapMode: Text.Wrap }
            IrisText { width: parent.width; text: root.player?.trackArtist || ""; color: "#626660"; font.pixelSize: 12; elide: Text.ElideRight }
        }
    }
    Row {
        y: 94; anchors.horizontalCenter: parent.horizontalCenter; spacing: 14
        Control { icon: "skip_previous"; accessibleName: "Previous track"; available: root.player?.canGoPrevious ?? false; onActivated: root.player.previous() }
        Control { icon: root.player?.isPlaying ? "pause" : "play_arrow"; accessibleName: root.player?.isPlaying ? "Pause" : "Play"; primary: true; available: root.player?.canTogglePlaying ?? false; onActivated: root.player.togglePlaying() }
        Control { icon: "skip_next"; accessibleName: "Next track"; available: root.player?.canGoNext ?? false; onActivated: root.player.next() }
    }
    function lengthString(seconds) {
        if (!Number.isFinite(seconds) || seconds < 0) return "—";
        return Math.floor(seconds / 60) + ":" + Math.floor(seconds % 60).toString().padStart(2,"0");
    }
    Timer {
        interval: 1000; repeat: true
        running: root.visible && (root.player?.isPlaying ?? false)
        onTriggered: root.player?.positionChanged()
    }
    StyledSlider {
        id: timeline
        x: 0; y: 158; width: parent.width; implicitHeight: 3
        fgColour: IrisStyle.ink; bgColour: IrisStyle.palette.m3outlineVariant
        value: root.player ? root.player.position / (root.player.length || 1) : 0
        enabled: (root.player?.canSeek ?? false) && (root.player?.length ?? 0) > 0
        interactionOnMove: false; wavy: false
        onInteraction: value => { if (root.player?.canSeek && root.player?.positionSupported) root.player.position = value * root.player.length; }
    }
    IrisText { x: 0; y: 174; text: root.lengthString(root.player?.position ?? -1); font: IrisStyle.face(11,"data"); color: IrisStyle.muted }
    IrisText { anchors.right: parent.right; y: 174; text: root.lengthString(root.player?.length ?? -1); font: IrisStyle.face(11,"data"); color: IrisStyle.muted }
    Dashboard.Spectrum { x: 0; y: 208; width: parent.width; height: Math.max(28, parent.height - 216) }
    component Control: Rectangle {
        id: control
        required property string icon
        required property string accessibleName
        property bool available: true
        property bool primary: false
        signal activated()
        width: 44; height: 44; radius: 22
        color: primary ? (hit.containsMouse ? "#40473c" : "#292c2a") : hit.containsMouse ? "#dedfd8" : "transparent"
        opacity: available ? 1 : 0.3
        Accessible.name: accessibleName
        Accessible.role: Accessible.Button
        IrisIcon { anchors.centerIn: parent; text: control.icon; fontStyle: Tokens.font.icon.size(23).build(); color: control.primary ? "#f6f5f1" : "#292c2a" }
        MouseArea { id: hit; anchors.fill: parent; hoverEnabled: true; enabled: control.available; cursorShape: Qt.PointingHandCursor; onClicked: control.activated() }
    }
}
