pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.components
import qs.services

Item {
    id: root

    anchors.top: parent.top
    anchors.bottom: parent.bottom
    implicitWidth: Tokens.sizes.dashboard.dateTimeWidth

    ColumnLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: 0

        IrisText {
            Layout.bottomMargin: -(font.pointSize * 0.4)
            Layout.alignment: Qt.AlignHCenter
            text: Time.hourStr
            color: IrisStyle.palette.m3secondary
            font: IrisStyle.typeface(Tokens.font.clock.size(28).weight(Font.DemiBold).build(), "body")
        }

        IrisText {
            Layout.alignment: Qt.AlignHCenter
            text: "•••"
            color: IrisStyle.palette.m3primary
            font: IrisStyle.typeface(Tokens.font.clock.size(28 * 0.9).build(), "body")
        }

        IrisText {
            Layout.topMargin: -(font.pointSize * 0.4)
            Layout.alignment: Qt.AlignHCenter
            text: Time.minuteStr
            color: IrisStyle.palette.m3secondary
            font: IrisStyle.typeface(Tokens.font.clock.size(28).weight(Font.DemiBold).build(), "body")
        }

        Loader {
            Layout.topMargin: -(((item as StyledText)?.font.pointSize ?? 0) * 0.4)
            Layout.alignment: Qt.AlignHCenter
            asynchronous: true
            active: Config.dashboard.showClockSeconds
            visible: active

            sourceComponent: IrisText {
                text: "•••"
                color: IrisStyle.palette.m3primary
                font: IrisStyle.typeface(Tokens.font.clock.size(28 * 0.9).build(), "body")
            }
        }
        Loader {
            Layout.topMargin: -(((item as StyledText)?.font.pointSize ?? 0) * 0.4)
            Layout.alignment: Qt.AlignHCenter
            asynchronous: true
            active: Config.dashboard.showClockSeconds
            visible: active

            sourceComponent: IrisText {
                text: Time.format("ss")
                color: IrisStyle.palette.m3secondary
                font: IrisStyle.typeface(Tokens.font.clock.size(28).weight(Font.DemiBold).build(), "body")
            }
        }

        Loader {
            asynchronous: true
            Layout.alignment: Qt.AlignHCenter

            active: Units.twelveHourClock
            visible: active

            sourceComponent: IrisText {
                text: Time.amPmStr
                color: IrisStyle.palette.m3primary
                font: IrisStyle.typeface(Tokens.font.clock.size(18).weight(Font.DemiBold).build(), "body")
            }
        }
    }
}
