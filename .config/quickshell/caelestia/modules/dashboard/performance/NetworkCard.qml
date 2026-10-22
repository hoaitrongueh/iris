import QtQuick
import QtQuick.Layouts
import Caelestia.Components
import Caelestia.Config
import Caelestia.I18n
import Caelestia.Services
import qs.components
import qs.services

StyledRect {
    id: root

    color: IrisStyle.palette.m3surfaceContainer
    radius: IrisStyle.cardRadius

    implicitWidth: 260
    implicitHeight: 164

    ServiceRef {
        service: NetworkUsage
    }

    ColumnLayout {
        id: layout

        anchors.fill: parent
        anchors.margins: 16
        anchors.bottomMargin: 12
        spacing: 0

        RowLayout {
            spacing: Tokens.spacing.small

            IrisIcon {
                text: "swap_vert"
                color: IrisStyle.palette.m3primary
                fontStyle: Tokens.font.icon.size(16).build()
            }

            IrisText {
                text: Tr.tr("Network")
                font: IrisStyle.face(15,"display")
            }
        }

        // Sparkline graph
        Item {
            Layout.topMargin: 8
            Layout.bottomMargin: 8
            Layout.fillWidth: true
            Layout.fillHeight: true

            SparklineItem {
                id: sparkline

                property real targetMax: 1024
                property real smoothMax: targetMax

                anchors.fill: parent
                line1: NetworkUsage.uploadBuffer // qmllint disable missing-type
                line1Color: "#92978c"
                line1FillAlpha: 0
                line2: NetworkUsage.downloadBuffer // qmllint disable missing-type
                line2Color: IrisStyle.ink
                line2FillAlpha: 0
                maxValue: smoothMax
                historyLength: NetworkUsage.historyLength
                lineWidth: 1.5

                Connections {
                    function onValuesChanged(): void {
                        sparkline.targetMax = Math.max(NetworkUsage.downloadBuffer.maximum, NetworkUsage.uploadBuffer.maximum, 1024);
                        slideAnim.restart();
                    }

                    target: NetworkUsage.downloadBuffer
                }

                NumberAnimation {
                    id: slideAnim

                    target: sparkline
                    property: "slideProgress"
                    from: 0
                    to: 1
                    easing.type: Easing.Linear
                    duration: GlobalConfig.dashboard.resourceUpdateInterval
                }

                Behavior on smoothMax {
                    Anim {}
                }
            }

            // "Collecting data" placeholder
            IrisText {
                anchors.centerIn: parent
                text: Tr.tr("Collecting data...")
                font: IrisStyle.face(11,"body")
                color: IrisStyle.palette.m3outline
                visible: NetworkUsage.downloadBuffer.count < 2
            }
        }

        // Download row
        RowLayout {
            Layout.fillWidth: true
            spacing: Tokens.spacing.small

            IrisIcon {
                text: "download"
                color: IrisStyle.palette.m3tertiary
                fontStyle: Tokens.font.icon.size(16).build()
            }

            IrisText {
                text: Tr.trCtx("Download", "network throughput")
                font: IrisStyle.face(11,"body")
                color: IrisStyle.palette.m3onSurfaceVariant
            }

            Item {
                Layout.fillWidth: true
            }

            IrisText {
                text: Units.formatBytes(NetworkUsage.downloadSpeed ?? 0, true)
                font: IrisStyle.face(11,"data")
                color: IrisStyle.palette.m3tertiary
            }
        }

        // Upload row
        RowLayout {
            Layout.fillWidth: true
            spacing: Tokens.spacing.small

            IrisIcon {
                text: "upload"
                color: IrisStyle.palette.m3secondary
                fontStyle: Tokens.font.icon.size(16).build()
            }

            IrisText {
                text: Tr.trCtx("Upload", "network throughput")
                font: IrisStyle.face(11,"body")
                color: IrisStyle.palette.m3onSurfaceVariant
            }

            Item {
                Layout.fillWidth: true
            }

            IrisText {
                text: Units.formatBytes(NetworkUsage.uploadSpeed ?? 0, true)
                font: IrisStyle.face(11,"data")
                color: IrisStyle.palette.m3secondary
            }
        }

        // Session totals
        RowLayout {
            Layout.fillWidth: true
            spacing: Tokens.spacing.small

            IrisIcon {
                text: "history"
                color: IrisStyle.palette.m3onSurfaceVariant
                fontStyle: Tokens.font.icon.size(16).build()
            }

            IrisText {
                text: Tr.trCtx("Total", "total network data transferred")
                font: IrisStyle.face(11,"body")
                color: IrisStyle.palette.m3onSurfaceVariant
            }

            Item {
                Layout.fillWidth: true
            }

            IrisText {
                text: {
                    const downText = Units.formatBytes(NetworkUsage.downloadTotal ?? 0);
                    const upText = Units.formatBytes(NetworkUsage.uploadTotal ?? 0);
                    // TRANSLATORS: %1 = downloaded total, %2 = uploaded total
                    return Tr.tr("↓%1  ↑%2").arg(downText).arg(upText);
                }
                font: IrisStyle.face(11,"data")
                color: IrisStyle.palette.m3onSurfaceVariant
            }
        }
    }
}
