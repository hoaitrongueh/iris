import QtQuick
import Caelestia.I18n
import Caelestia.Config
import qs.components
import qs.services
import qs.utils

Rectangle {
    id: root
    required property string icon
    required property string label
    required property string subLabel
    required property color accent
    required property real usage
    required property real temperature
    color: IrisStyle.surface
    radius: IrisStyle.cardRadius
    implicitWidth: 292
    implicitHeight: 112
    IrisIcon { x: 16; y: 15; text: root.icon; fontStyle: Tokens.font.icon.size(18).build() }
    IrisText { x: 42; y: 14; text: root.label; font: IrisStyle.face(15, "display") }
    IrisText {
        anchors.right: parent.right; anchors.rightMargin: 16; y: 10
        text: isNaN(root.usage) ? "—" : Strings.percentOne(root.usage)
        font: IrisStyle.face(30, "display")
    }
    IrisText {
        x: 16; y: 43; width: parent.width - 32
        text: root.subLabel; font: IrisStyle.face(11, "data"); color: IrisStyle.muted
        elide: Text.ElideRight; maximumLineCount: 1
    }
    Row {
        x: 16; y: 71; spacing: 5
        IrisIcon { text: root.temperature > 90 ? "thermometer_alert" : "thermometer"; fontStyle: Tokens.font.icon.size(14).build(); color: root.temperature > 90 ? IrisStyle.palette.m3error : IrisStyle.muted }
        IrisText { text: isNaN(root.temperature) ? "—" : Units.formatSensorTemp(root.temperature); font: IrisStyle.face(11,"data"); color: IrisStyle.muted }
    }
    Rectangle {
        x: 16; y: 97; width: parent.width - 32; height: 3; radius: 1.5
        color: IrisStyle.palette.m3outlineVariant
        Rectangle { width: parent.width * Math.max(0, Math.min(1, isNaN(root.usage) ? 0 : root.usage)); height: parent.height; radius: 1.5; color: IrisStyle.ink
            Behavior on width { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
        }
    }
}
