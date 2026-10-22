import QtQuick
import Caelestia.Config
import qs.components
import qs.components.controls
import qs.services
import qs.utils
import Caelestia.I18n
import Quickshell
import Caelestia.Services
Rectangle {
    id: root
    readonly property real percentage: Storage.primaryDisk?.perc ?? 0
    color: IrisStyle.surface; radius: IrisStyle.cardRadius
    implicitWidth: 250; implicitHeight: 164
    ServiceRef { service: Storage }
    IrisIcon { x: 16; y: 15; text: "hard_drive"; fontStyle: Tokens.font.icon.size(18).build() }
    IrisText { x: 42; y: 14; text: "Storage"; font: IrisStyle.face(15,"display") }
    IrisText { x: 16; y: 43; text: Strings.percentOne(root.percentage); font: IrisStyle.face(32,"display") }
    IrisText { x: 16; y: 87; width: parent.width - 32; text: Storage.primaryDisk ? Units.formatKibUsage(Storage.primaryDisk.used, Storage.primaryDisk.total) : "No disks detected"; font: IrisStyle.face(11,"data"); color: IrisStyle.muted; elide: Text.ElideRight }
    Rectangle {
        x: 16; y: 111; width: parent.width - 32; height: 4; radius: 2; color: IrisStyle.palette.m3outlineVariant
        Rectangle { width: parent.width * Math.max(0, Math.min(1, root.percentage)); height: 4; radius: 2; color: IrisStyle.ink }
    }
        SplitButton {
            menuPalette: IrisStyle.palette
            menuTextFont: IrisStyle.face(12,"body")
            colour: IrisStyle.surface
            textColour: IrisStyle.ink
            disabledColour: IrisStyle.surface
            disabledTextColour: IrisStyle.muted
            label.font.family: "Satoshi"
            label.font.weight: Font.Medium
            anchors.left: parent.left; anchors.leftMargin: 8; anchors.bottom: parent.bottom; anchors.bottomMargin: 6

            type: SplitButton.Tonal
            disabled: !Storage.disks.length
            fallbackIcon: "storage"
            fallbackText: Tr.tr("No disks")
            menuOnTop: true
            minLeftWidth: Math.min(180, root.width - 72)

            menuItems: disks.instances
            active: menuItems.find(m => m.modelData === Storage.primaryDisk) ?? menuItems[0] ?? null
            menu.onItemSelected: item => Storage.manualPrimaryDisk = (item as DiskItem).modelData

            Variants {
                id: disks

                model: Storage.disks

                DiskItem {}
            }
        }
    component DiskItem: MenuItem {
        required property var modelData
        icon: modelData === Storage.primaryDisk ? "check" : ""
        text: modelData.mount
        activeIcon: "storage"
    }
}
