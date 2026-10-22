import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import Caelestia.Config
import Caelestia.I18n
import Caelestia.Services
import qs.components
import qs.services
import qs.utils

StyledClippingRect {
    id: root

    property real animPerc: UPower.displayDevice.percentage

    color: "#eeede8"
    radius: IrisStyle.cardRadius

    implicitWidth: Config.dashboard.performance.showCpu || (Config.dashboard.performance.showGpu && Gpu.type !== GpuType.None) || Config.dashboard.performance.showStorage || Config.dashboard.performance.showMemory ? 104 : Tokens.sizes.dashboard.perfBattWidthSingle
    implicitHeight: Tokens.sizes.dashboard.perfBattHeight

    Behavior on animPerc {
        Anim {}
    }

    Contents {
        id: layout

        anchors.fill: parent
        anchors.margins: 14

        accentColour: "#292c2a"
        textColour: "#292c2a"
        subTextColour: "#626660"
    }

    StyledRect {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        implicitHeight: parent.height * root.animPerc

        color: "#dedfd8"
        radius: Tokens.rounding.extraSmall
        clip: true

        Contents {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: layout.anchors.margins
            height: layout.height

            accentColour: "#292c2a"
            textColour: "#292c2a"
            subTextColour: "#626660"
        }
    }

    component Contents: ColumnLayout {
        id: contents

        required property color accentColour
        required property color textColour
        required property color subTextColour
        readonly property bool charging: [UPowerDeviceState.Charging, UPowerDeviceState.FullyCharged, UPowerDeviceState.PendingCharge].includes(UPower.displayDevice.state)

        spacing: 0

        IrisIcon {
            Layout.leftMargin: -Tokens.padding.extraSmall
            text: "battery_full"
            color: contents.accentColour
            fontStyle: Tokens.font.icon.large
        }

        IrisText {
            Layout.fillWidth: true
            text: Tr.tr("Battery")
            color: contents.textColour
            font: IrisStyle.typeface(Tokens.font.body.medium, "body")
        }

        Item {
            Layout.fillHeight: true
        }

        IrisText {
            Layout.fillWidth: true
            elide: Text.ElideRight
            text: {
                if (UPower.displayDevice.state === UPowerDeviceState.FullyCharged)
                    return Tr.trCtx("Full", "battery state");

                if (contents.charging)
                    return Tr.trCtx("Charging", "battery state");

                const s = UPower.displayDevice.timeToEmpty;
                if (s === 0)
                    return "...";

                const hr = Math.floor(s / 3600);
                const min = Math.floor((s % 3600) / 60);
                if (hr > 0)
                    // TRANSLATORS: %1 = hours, %2 = minutes
                    return Tr.trCtx("%1h %2m", "battery time remaining").arg(hr).arg(min);

                // TRANSLATORS: %1 = minutes
                return Tr.trCtx("%1m", "battery time remaining").arg(min);
            }
            color: contents.subTextColour
            font: IrisStyle.typeface(Tokens.font.body.small, "data")
            animate: true
        }

        RowLayout {
            Layout.topMargin: -Tokens.padding.extraSmall
            Layout.bottomMargin: -Tokens.padding.small
            Layout.rightMargin: -Tokens.padding.extraSmall
            Layout.alignment: Qt.AlignLeft
            spacing: Tokens.spacing.extraSmall

            IrisIcon {
                visible: false
                text: "bolt"
                color: contents.accentColour
                fontStyle: Tokens.font.icon.large
                fill: 1

                scale: contents.charging ? 1 : 0
                opacity: contents.charging ? 1 : 0

                Behavior on scale {
                    Anim {
                        type: Anim.FastSpatial
                    }
                }

                Behavior on opacity {
                    Anim {
                        type: Anim.FastEffects
                    }
                }
            }

            IrisText {
                text: Strings.percentOne(UPower.displayDevice.percentage)
                color: contents.accentColour
                font.family: "Space Grotesk"
                font.pixelSize: 25
                font.weight: Font.Bold
            }
        }
    }
}
