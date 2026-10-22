import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.components
import qs.services
import qs.utils

Item {
    id: root

    readonly property var today: Weather.forecast && Weather.forecast.length > 0 ? Weather.forecast[0] : null

    implicitWidth: layout.implicitWidth > 800 ? layout.implicitWidth : 840
    implicitHeight: layout.implicitHeight
    Component.onCompleted: Weather.reload()

    ColumnLayout {
        id: layout

        anchors.fill: parent
        spacing: Tokens.spacing.medium

        RowLayout {
            Layout.leftMargin: Tokens.padding.large
            Layout.rightMargin: Tokens.padding.large
            Layout.fillWidth: true

            Column {
                spacing: Tokens.spacing.extraSmall

                IrisText {
                    text: Weather.city || Tr.tr("Loading...")
                    font: IrisStyle.typeface(Tokens.font.body.builders.large.size(28).weight(Font.DemiBold).build(), "body")
                    color: IrisStyle.palette.m3onSurface
                }

                IrisText {
                    text: new Date().toLocaleDateString(Qt.locale(), "dddd, MMMM d")
                    font: IrisStyle.typeface(Tokens.font.body.small, "body")
                    color: IrisStyle.palette.m3onSurfaceVariant
                }
            }

            Item {
                Layout.fillWidth: true
            }

            Row {
                spacing: Tokens.spacing.largeIncreased

                WeatherStat {
                    icon: "wb_twilight"
                    label: Tr.tr("Sunrise")
                    value: Weather.sunrise
                    colour: IrisStyle.palette.m3tertiary
                }

                WeatherStat {
                    icon: "bedtime"
                    label: Tr.tr("Sunset")
                    value: Weather.sunset
                    colour: IrisStyle.palette.m3tertiary
                }
            }
        }

        StyledRect {
            Layout.fillWidth: true
            implicitHeight: bigInfoRow.implicitHeight + Tokens.padding.small

            radius: Tokens.rounding.extraLarge * 2
            color: IrisStyle.palette.m3surfaceContainer

            RowLayout {
                id: bigInfoRow

                anchors.centerIn: parent
                spacing: Tokens.spacing.largeIncreased

                IrisIcon {
                    Layout.alignment: Qt.AlignVCenter
                    text: Weather.icon
                    fontStyle: Tokens.font.icon.builders.extraLarge.scale(3).build()
                    color: IrisStyle.palette.m3secondary
                    animate: true
                }

                ColumnLayout {
                    Layout.alignment: Qt.AlignVCenter
                    spacing: -Tokens.spacing.small

                    IrisText {
                        text: Weather.temp
                        font: IrisStyle.typeface(Tokens.font.body.builders.large.size(28 * 2).weight(Font.Medium).build(), "body")
                        color: IrisStyle.palette.m3primary
                    }

                    IrisText {
                        Layout.leftMargin: Tokens.padding.extraSmall
                        text: Weather.description
                        font: IrisStyle.typeface(Tokens.font.body.medium, "body")
                        color: IrisStyle.palette.m3onSurfaceVariant
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Tokens.spacing.medium

            DetailCard {
                icon: "water_drop"
                label: Tr.tr("Humidity")
                value: Strings.percent(Weather.humidity)
                colour: IrisStyle.palette.m3secondary
            }
            DetailCard {
                icon: "thermostat"
                label: Tr.trCtx("Feels like", "apparent temperature")
                value: Weather.feelsLike
                colour: IrisStyle.palette.m3primary
            }
            DetailCard {
                icon: "air"
                label: Tr.tr("Wind")
                value: Weather.windSpeed ? Tr.tr("%1 km/h").arg(Weather.windSpeed) : "--"
                colour: IrisStyle.palette.m3tertiary
            }
        }

        IrisText {
            Layout.topMargin: Tokens.spacing.medium
            Layout.leftMargin: Tokens.padding.medium
            visible: forecastRepeater.count > 0
            text: Tr.tr("7-day forecast")
            font: IrisStyle.typeface(Tokens.font.body.builders.medium.weight(Font.DemiBold).build(), "body")
            color: IrisStyle.palette.m3onSurface
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Tokens.spacing.medium

            Repeater {
                id: forecastRepeater

                model: Weather.forecast

                StyledRect {
                    id: forecastItem

                    required property int index
                    required property var modelData

                    Layout.fillWidth: true
                    implicitHeight: forecastItemColumn.implicitHeight + Tokens.padding.medium * 2

                    radius: Tokens.rounding.large
                    color: IrisStyle.palette.m3surfaceContainer

                    ColumnLayout {
                        id: forecastItemColumn

                        anchors.centerIn: parent
                        spacing: Tokens.spacing.small

                        IrisText {
                            Layout.alignment: Qt.AlignHCenter
                            text: forecastItem.index === 0 ? Tr.trCtx("Today", "forecast column") : new Date(forecastItem.modelData.date).toLocaleDateString(Qt.locale(), "ddd")
                            font: IrisStyle.typeface(Tokens.font.body.builders.medium.weight(Font.DemiBold).build(), "body")
                            color: IrisStyle.palette.m3primary
                        }

                        IrisText {
                            Layout.topMargin: -Tokens.spacing.extraSmall
                            Layout.alignment: Qt.AlignHCenter
                            text: new Date(forecastItem.modelData.date).toLocaleDateString(Qt.locale(), "MMM d")
                            font: IrisStyle.typeface(Tokens.font.body.small, "body")
                            opacity: 0.7
                            color: IrisStyle.palette.m3onSurfaceVariant
                        }

                        IrisIcon {
                            Layout.alignment: Qt.AlignHCenter
                            text: forecastItem.modelData.icon
                            fontStyle: Tokens.font.icon.extraLarge
                            color: IrisStyle.palette.m3secondary
                        }

                        IrisText {
                            Layout.alignment: Qt.AlignHCenter
                            text: {
                                const min = Weather.formatTemp(forecastItem.modelData.minTempC, true);
                                const max = Weather.formatTemp(forecastItem.modelData.maxTempC, true);
                                return Tr.trCtx("%1 / %2", "min/max temperature").arg(min).arg(max);
                            }
                            font: IrisStyle.typeface(Tokens.font.body.builders.small.weight(Font.DemiBold).build(), "body")
                            color: IrisStyle.palette.m3tertiary
                        }
                    }
                }
            }
        }
    }

    component DetailCard: StyledRect {
        id: detailRoot

        property string icon
        property string label
        property string value
        property color colour

        Layout.fillWidth: true
        Layout.preferredHeight: 60
        radius: Tokens.rounding.medium
        color: IrisStyle.palette.m3surfaceContainer

        Row {
            anchors.centerIn: parent
            spacing: Tokens.spacing.medium

            IrisIcon {
                text: detailRoot.icon
                color: detailRoot.colour
                fontStyle: Tokens.font.icon.large
                anchors.verticalCenter: parent.verticalCenter
            }

            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 0

                IrisText {
                    text: detailRoot.label
                    font: IrisStyle.typeface(Tokens.font.body.small, "body")
                    opacity: 0.7
                    horizontalAlignment: Text.AlignLeft
                }
                IrisText {
                    text: detailRoot.value
                    font: IrisStyle.typeface(Tokens.font.body.builders.small.weight(Font.DemiBold).build(), "body")
                    horizontalAlignment: Text.AlignLeft
                }
            }
        }
    }

    component WeatherStat: Row {
        id: weatherStat

        property string icon
        property string label
        property string value
        property color colour

        spacing: Tokens.spacing.small

        IrisIcon {
            text: weatherStat.icon
            fontStyle: Tokens.font.icon.extraLarge
            color: weatherStat.colour
        }

        Column {
            IrisText {
                text: weatherStat.label
                font: IrisStyle.typeface(Tokens.font.body.small, "body")
                color: IrisStyle.palette.m3onSurfaceVariant
            }
            IrisText {
                text: weatherStat.value
                font: IrisStyle.typeface(Tokens.font.body.builders.small.weight(Font.DemiBold).build(), "body")
                color: IrisStyle.palette.m3onSurface
            }
        }
    }
}
