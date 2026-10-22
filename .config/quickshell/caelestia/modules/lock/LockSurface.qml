pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import Quickshell
import Caelestia
import Quickshell.Wayland
import Caelestia.Config
import qs.components
import qs.components.images
import qs.services

WlSessionLockSurface {
    id: root

    required property WlSessionLock lock
    required property Pam pam

    property bool captureActive: false
    property string captureOutput
    property string captureSnapshot
    function beginCapture(output: string, region: bool, snapshot: string): void {
        if (captureActive) return;
        captureOutput = output;
        captureSnapshot = snapshot;
        if (!region) {
            CUtils.saveItem(root.contentItem, Qt.resolvedUrl(output));
            return;
        }
        CUtils.saveItem(root.contentItem, Qt.resolvedUrl(snapshot), () => {
            frozen.source = Qt.resolvedUrl(snapshot);
            captureActive = true;
        });
    }
    function cancelCapture(): void {
        if (!captureActive) return;
        captureActive = false;
        frozen.source = "";
        Quickshell.execDetached(["touch", captureSnapshot + ".cancelled"]);
    }
    function finishCapture(x: real, y: real, width: real, height: real): void {
        if (!captureActive || width < 1 || height < 1) return;
        CUtils.saveItem(frozen, Qt.resolvedUrl(captureOutput), Qt.rect(Math.round(x), Math.round(y), Math.round(width), Math.round(height)), () => {
            captureActive = false;
            frozen.source = "";
        });
    }
    Item {
        id: selection
        anchors.fill: parent
        z: 10000
        visible: root.captureActive
        property real sx: 0
        property real sy: 0
        property real ex: 0
        property real ey: 0
        readonly property real rx: Math.min(sx, ex)
        readonly property real ry: Math.min(sy, ey)
        readonly property real rw: Math.abs(sx - ex)
        readonly property real rh: Math.abs(sy - ey)
        Image { id: frozen; anchors.fill: parent; fillMode: Image.Stretch }
        Rectangle { x: 0; y: 0; width: parent.width; height: selection.ry; color: "#66000000" }
        Rectangle { x: 0; y: selection.ry; width: selection.rx; height: selection.rh; color: "#66000000" }
        Rectangle { x: selection.rx + selection.rw; y: selection.ry; width: parent.width - x; height: selection.rh; color: "#66000000" }
        Rectangle { x: 0; y: selection.ry + selection.rh; width: parent.width; height: parent.height - y; color: "#66000000" }
        Rectangle { x: selection.rx; y: selection.ry; width: selection.rw; height: selection.rh; color: "transparent"; border.width: 1; border.color: "#c7d6e6" }
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.CrossCursor
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onPressed: event => {
                if (event.button === Qt.RightButton) { root.cancelCapture(); return; }
                selection.sx = selection.ex = event.x;
                selection.sy = selection.ey = event.y;
            }
            onPositionChanged: event => { if (pressed) { selection.ex = Math.max(0, Math.min(width, event.x)); selection.ey = Math.max(0, Math.min(height, event.y)); } }
            onReleased: event => { if (event.button === Qt.LeftButton) root.finishCapture(selection.rx, selection.ry, selection.rw, selection.rh); }
        }
    }

    readonly property alias unlocking: unlockAnim.running

    contentItem.Config.screen: screen.name
    contentItem.Tokens.screen: screen.name

    color: "transparent"

    Connections {
        function onUnlock(): void {
            unlockAnim.start();
        }

        target: root.lock
    }

    SequentialAnimation {
        id: unlockAnim

        ParallelAnimation {
            Anim {
                target: lockContent
                properties: "implicitWidth,implicitHeight"
                to: lockContent.size
            }
            Anim {
                target: lockBg
                property: "radius"
                to: lockContent.radius
            }
            Anim {
                target: content
                property: "scale"
                to: 0
            }
            Anim {
                target: content
                property: "opacity"
                to: 0
                type: Anim.StandardSmall
            }
            Anim {
                target: lockIcon
                property: "opacity"
                to: 1
                type: Anim.StandardLarge
            }
            Anim {
                target: background
                property: "opacity"
                to: 0
                type: Anim.StandardLarge
            }
            SequentialAnimation {
                PauseAnimation {
                    duration: Tokens.anim.durations.small
                }
                Anim {
                    type: Anim.Standard
                    target: lockContent
                    property: "opacity"
                    to: 0
                }
            }
        }
        PropertyAction {
            target: root.lock
            property: "locked"
            value: false
        }
    }

    ParallelAnimation {
        id: initAnim

        running: true

        Anim {
            target: background
            property: "opacity"
            to: 1
            type: Anim.StandardLarge
        }
        SequentialAnimation {
            ParallelAnimation {
                Anim {
                    target: lockContent
                    property: "scale"
                    to: 1
                    type: Anim.FastSpatial
                }
                Anim {
                    target: lockContent
                    property: "rotation"
                    to: 360
                    duration: Tokens.anim.durations.expressiveFastSpatial
                    easing: Tokens.anim.standardAccel
                }
            }
            ParallelAnimation {
                Anim {
                    target: lockIcon
                    property: "rotation"
                    to: 360
                    easing: Tokens.anim.standardDecel
                }
                Anim {
                    type: Anim.DefaultEffects
                    target: lockIcon
                    property: "opacity"
                    to: 0
                }
                Anim {
                    type: Anim.DefaultEffects
                    target: content
                    property: "opacity"
                    to: 1
                }
                Anim {
                    target: content
                    property: "scale"
                    to: 1
                }
                Anim {
                    target: lockBg
                    property: "radius"
                    to: lockContent.Tokens.rounding.extraLarge * 1.5
                }
                Anim {
                    target: lockContent
                    property: "implicitWidth"
                    to: (root.screen?.height ?? 0) * lockContent.Tokens.sizes.lock.heightMult * lockContent.Tokens.sizes.lock.ratio
                }
                Anim {
                    target: lockContent
                    property: "implicitHeight"
                    to: (root.screen?.height ?? 0) * lockContent.Tokens.sizes.lock.heightMult
                }
            }
        }
    }

    Item {
        id: background

        anchors.fill: parent
        opacity: 0

        layer.enabled: true
        layer.effect: MultiEffect {
            autoPaddingEnabled: false
            blurEnabled: true
            blur: 1
            blurMax: 64
            blurMultiplier: 1
        }

        Loader {
            anchors.fill: parent
            sourceComponent: Config.lock.useWallpaper ? wallpaperBackground : screencopyBackground
        }
    }

    Component {
        id: screencopyBackground

        ScreencopyView {
            captureSource: root.screen
        }
    }

    Component {
        id: wallpaperBackground

        CachingImage {
            path: Wallpapers.current
        }
    }

    Item {
        id: lockContent

        readonly property int size: lockIcon.implicitHeight + Tokens.padding.large * 4
        readonly property int radius: size / 4 * Tokens.rounding.scale

        anchors.centerIn: parent
        implicitWidth: size
        implicitHeight: size

        visible: Config.lock.enabled
        rotation: 180
        scale: 0

        StyledRect {
            id: lockBg

            anchors.fill: parent
            color: "#1b2532"
            radius: parent.radius
            opacity: Colours.transparency.enabled ? Colours.transparency.base : 1

            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                blurMax: 15
                shadowColor: Qt.alpha(Colours.palette.m3shadow, 0.7)
            }
        }

        MaterialIcon {
            id: lockIcon

            anchors.centerIn: parent
            text: "lock"
            fontStyle: Tokens.font.icon.builders.extraLarge.scale(4).weight(Font.Bold).build()
            rotation: 180
        }

        Content {
            id: content

            anchors.centerIn: parent
            width: (root.screen?.height ?? 0) * Tokens.sizes.lock.heightMult * Tokens.sizes.lock.ratio - Tokens.padding.extraLargeIncreased
            height: (root.screen?.height ?? 0) * Tokens.sizes.lock.heightMult - Tokens.padding.extraLargeIncreased

            lock: root
            opacity: 0
            scale: 0
        }
    }
}
