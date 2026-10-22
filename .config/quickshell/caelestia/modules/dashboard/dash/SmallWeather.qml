import QtQuick
import Caelestia.Config
import qs.components
import qs.services

Item {
    id: root

    anchors.centerIn: parent

    implicitWidth: icon.implicitWidth + info.implicitWidth + info.anchors.leftMargin
    implicitHeight: Math.max(icon.implicitHeight, info.implicitHeight) + Tokens.padding.largeIncreased * 2

    Component.onCompleted: Weather.reload()

    IrisIcon {
        id: icon

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left

        animate: true
        text: Weather.icon
        color: IrisStyle.palette.m3secondary
        fontStyle: Tokens.font.icon.builders.extraLarge.scale(1.6).build()
    }

    Column {
        id: info

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: icon.right
        anchors.leftMargin: Tokens.spacing.largeIncreased

        spacing: Tokens.spacing.extraSmall

        IrisText {
            anchors.horizontalCenter: parent.horizontalCenter

            animate: true
            text: Weather.temp
            color: IrisStyle.palette.m3primary
            font: IrisStyle.typeface(Tokens.font.headline.builders.medium.width(110).weight(Font.DemiBold).build(), "display")
        }

        IrisText {
            anchors.horizontalCenter: parent.horizontalCenter

            animate: true
            text: Weather.description
            font: IrisStyle.typeface(Tokens.font.body.small, "body")

            elide: Text.ElideRight
            wrapMode: Text.WordWrap
            maximumLineCount: 2
            horizontalAlignment: Text.AlignHCenter
            width: Math.min(implicitWidth, root.parent.width - icon.implicitWidth - info.anchors.leftMargin - Tokens.padding.extraLargeIncreased)
        }
    }
}
