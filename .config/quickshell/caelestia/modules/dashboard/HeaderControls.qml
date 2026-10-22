pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Networking
import Quickshell.Services.SystemTray
import Quickshell.Services.UPower
import Caelestia.Config
import qs.components
import qs.components.effects
import qs.services
import qs.utils

Item {
    id: root
    readonly property bool connected: Networking.devices.values.some(device => device.connected)
    required property ScreenState screenState
    implicitWidth: controls.implicitWidth
    implicitHeight: 30
    Row {
        id: controls
        anchors.verticalCenter: parent.verticalCenter
        spacing: 7
        Row {
            spacing: 2
            Repeater {
                model: [...new Set([1, 2, 3, Hypr.activeWsId])].sort((a,b) => a-b)
                delegate: Rectangle {
                    id: workspace
                    required property int modelData
                    readonly property bool current: Hypr.activeWsId === modelData
                    width: 22; height: 28; radius: 6
                    color: wsHit.containsMouse || activeFocus ? IrisStyle.hover : "transparent"
                    activeFocusOnTab: true
                    Accessible.role: Accessible.Button
                    Accessible.name: "Workspace " + modelData
                    Accessible.pressed: current
                    Keys.onReturnPressed: Hypr.focusWorkspace(modelData)
                    Keys.onSpacePressed: Hypr.focusWorkspace(modelData)
                    IrisText { anchors.centerIn: parent; text: workspace.modelData; color: workspace.current ? IrisStyle.ink : IrisStyle.muted; font: IrisStyle.face(11,"data") }
                    Rectangle { anchors.horizontalCenter: parent.horizontalCenter; anchors.bottom: parent.bottom; width: workspace.current ? 9 : 0; height: 2; radius: 1; color: IrisStyle.ink }
                    MouseArea {
                        id: wsHit; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                        onClicked: Hypr.focusWorkspace(workspace.modelData)
                        onWheel: wheel => Hypr.focusWorkspace(Math.max(1, Hypr.activeWsId + (wheel.angleDelta.y < 0 ? 1 : -1)))
                    }
                }
            }
        }
        Control { label: "Overview"; text: Time.format("HH:mm"); width: 45; onActivated: root.screenState.dashboardTab = 0 }
        Control {
            label: root.connected ? "Network connected" : "Network disconnected"
            icon: root.connected ? "wifi" : "wifi_off"
            onActivated: { Quickshell.execDetached(["nm-connection-editor"]); root.screenState.dashboard = false; }
        }
        Control {
            label: Audio.muted ? "Unmute audio" : "Mute audio"; icon: Icons.getVolumeIcon(Audio.volume, Audio.muted)
            onActivated: { if (Audio.sink?.audio) Audio.sink.audio.muted = !Audio.muted; }
            onSecondary: Quickshell.execDetached(["qs", "-c", "workstation-controls", "ipc", "call", "controls", "reveal"])
            onAdjusted: direction => direction > 0 ? Audio.incrementVolume() : Audio.decrementVolume()
        }
        Control {
            visible: UPower.displayDevice.isLaptopBattery
            width: 55; label: "Battery " + Math.round(UPower.displayDevice.percentage * 100) + "%"
            icon: UPower.onBattery ? "battery_full" : "battery_charging_full"
            text: Math.round(UPower.displayDevice.percentage * 100) + "%"
            onActivated: root.screenState.dashboardTab = 2
        }
        Row {
            spacing: 2
            Repeater {
                model: SystemTray.items.values
                delegate: Rectangle {
                    id: tray
                    required property SystemTrayItem modelData
                    width: 24; height: 28; radius: 6
                    color: trayHit.containsMouse ? IrisStyle.hover : "transparent"
                    Accessible.role: Accessible.Button
                    Accessible.name: modelData.title || modelData.id
                    ColouredIcon {
                        anchors.centerIn: parent; implicitWidth: 15; implicitHeight: 15
                        source: Icons.getTrayIcon(tray.modelData.id, tray.modelData.icon)
                        colour: IrisStyle.ink
                    }
                    MouseArea {
                        id: trayHit; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                        acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
                        onClicked: event => {
                            if (event.button === Qt.MiddleButton) { tray.modelData.secondaryActivate(); return; }
                            if (event.button === Qt.RightButton || tray.modelData.onlyMenu) {
                                const win = tray.QsWindow.window;
                                const point = tray.mapToItem(win.contentItem, 0, tray.height);
                                tray.modelData.display(win, Math.round(point.x), Math.round(point.y));
                            } else tray.modelData.activate();
                        }
                        onWheel: wheel => tray.modelData.scroll(wheel.angleDelta.y, false)
                    }
                }
            }
        }
    }
    component Control: Rectangle {
        id: button
        property string icon: ""
        property string text: ""
        required property string label
        signal activated()
        signal secondary()
        signal adjusted(int direction)
        width: 26; height: 28; radius: 6
        color: hit.containsMouse || activeFocus ? IrisStyle.hover : "transparent"
        activeFocusOnTab: true
        Accessible.role: Accessible.Button
        Accessible.name: label
        Keys.onReturnPressed: activated()
        Keys.onSpacePressed: activated()
        Row {
            anchors.centerIn: parent; spacing: 3
            IrisIcon { visible: button.icon.length > 0; text: button.icon; fontStyle: Tokens.font.icon.size(15).build() }
            IrisText { visible: button.text.length > 0; text: button.text; font: IrisStyle.face(11,"data") }
        }
        MouseArea {
            id: hit; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: event => event.button === Qt.RightButton ? button.secondary() : button.activated()
            onWheel: wheel => button.adjusted(wheel.angleDelta.y > 0 ? 1 : -1)
        }
    }
}
