//@ pragma DefaultEnv QS_NO_RELOAD_POPUP=1
import QtQuick
import Quickshell
import Quickshell.Wayland

ShellRoot {
    id: root
    readonly property var capture: JSON.parse(Quickshell.env("IRIS_CAPTURE_GEOMETRY"))
    property int ready: 0
    Variants {
        model: Quickshell.screens
        PanelWindow {
            id: window
            required property ShellScreen modelData
            screen: modelData
            visible: frame.status === Image.Ready
            anchors.top: true; anchors.bottom: true; anchors.left: true; anchors.right: true
            exclusiveZone: 0
            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            WlrLayershell.namespace: "iris-capture-freeze"
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
            color: "black"
            Image {
                id: frame
                anchors.fill: parent
                source: "file://" + Quickshell.env("IRIS_CAPTURE_IMAGE")
                sourceClipRect: Qt.rect((window.modelData.x - root.capture.x) * root.capture.scale, (window.modelData.y - root.capture.y) * root.capture.scale, window.modelData.width * root.capture.scale, window.modelData.height * root.capture.scale)
                fillMode: Image.Stretch
                smooth: false
                Timer {
                    interval: 40
                    running: frame.status === Image.Ready
                    onTriggered: { root.ready++; if (root.ready === Quickshell.screens.length) console.info("IRIS_CAPTURE_READY"); }
                }
            }
        }
    }
}
