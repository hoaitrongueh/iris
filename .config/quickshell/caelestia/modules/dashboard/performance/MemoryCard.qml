import QtQuick
import Caelestia.I18n
import Caelestia.Config
import qs.components
import qs.services
import qs.utils
import Caelestia.Services
Rectangle {
    id: root
    color: IrisStyle.surface; radius: IrisStyle.cardRadius
    implicitWidth: 160; implicitHeight: 164
    ServiceRef { service: Memory }
    IrisIcon { x: 16; y: 15; text: "memory_alt"; fontStyle: Tokens.font.icon.size(18).build() }
    IrisText { x: 42; y: 14; text: "Memory"; font: IrisStyle.face(15,"display") }
    IrisText { x: 16; y: 43; text: Strings.percentOne(Memory.percentage); font: IrisStyle.face(32,"display") }
    Row {
        x: 16; y: 94; width: parent.width - 32; spacing: 2
        Repeater {
            model: 16
            Rectangle {
                required property int index
                width: (parent.width - 30) / 16; height: 10; radius: 1
                color: index < Math.ceil(Memory.percentage * 16) ? IrisStyle.ink : IrisStyle.palette.m3outlineVariant
            }
        }
    }
    IrisText { x: 16; y: 126; width: parent.width - 32; text: Units.formatKibUsage(Memory.used, Memory.total); font: IrisStyle.face(11,"data"); color: IrisStyle.muted; elide: Text.ElideRight }
}
