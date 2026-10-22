import "performance"
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import Caelestia.Config
import Caelestia.I18n
import Caelestia.Services
import qs.components
import qs.services

Item {
    id: root

    implicitWidth: placeholder.active ? Tokens.sizes.dashboard.perfPlaceholderWidth : content.implicitWidth
    implicitHeight: placeholder.active ? placeholder.implicitHeight + Tokens.padding.extraLarge * 2 : content.implicitHeight

    Loader {
        id: placeholder

        anchors.centerIn: parent
        active: !Config.dashboard.performance.showCpu && !(Config.dashboard.performance.showGpu && Gpu.type !== GpuType.None) && !Config.dashboard.performance.showMemory && !Config.dashboard.performance.showStorage && !Config.dashboard.performance.showNetwork && !(UPower.displayDevice.isLaptopBattery && Config.dashboard.performance.showBattery)
        asynchronous: true

        sourceComponent: ColumnLayout {
            spacing: IrisStyle.moduleGap

            IrisIcon {
                Layout.alignment: Qt.AlignHCenter
                text: "tune"
                fontStyle: Tokens.font.icon.builders.extraLarge.scale(2).build()
                color: IrisStyle.palette.m3onSurfaceVariant
            }

            IrisText {
                Layout.topMargin: -Tokens.spacing.small
                Layout.alignment: Qt.AlignHCenter
                text: Tr.tr("No widgets enabled")
                font: IrisStyle.typeface(Tokens.font.title.large, "display")
                color: IrisStyle.palette.m3onSurface
            }

            IrisText {
                Layout.alignment: Qt.AlignHCenter
                text: Tr.tr("Enable widgets in the dashboard settings")
                font: IrisStyle.typeface(Tokens.font.body.small, "body")
                color: IrisStyle.palette.m3onSurfaceVariant
            }
        }
    }

    RowLayout {
        id: content

        anchors.left: parent.left
        anchors.right: parent.right
        spacing: IrisStyle.moduleGap
        visible: !placeholder.active

        ColumnLayout {
            id: mainColumn

            Layout.fillWidth: true
            spacing: IrisStyle.moduleGap

            RowLayout {
                spacing: IrisStyle.moduleGap
                visible: cpuCard.active || gpuCard.active

                WrappedLoader {
                    id: cpuCard

                    active: Config.dashboard.performance.showCpu

                    sourceComponent: HeroCard {
                        icon: "memory"
                        label: Tr.tr("CPU")
                        subLabel: Cpu.name
                        usage: Cpu.percentage
                        temperature: Cpu.temperature
                        accent: IrisStyle.palette.m3primary

                        ServiceRef {
                            service: Cpu
                        }
                    }
                }

                WrappedLoader {
                    id: gpuCard

                    active: Config.dashboard.performance.showGpu && Gpu.type !== GpuType.None

                    sourceComponent: HeroCard {
                        icon: "desktop_windows"
                        label: Tr.tr("GPU")
                        subLabel: Gpu.name || (Gpu.detecting ? Tr.tr("Detecting GPU...") : Tr.trCtx("None", "GPU name"))
                        usage: Gpu.percentage
                        temperature: Gpu.temperature
                        accent: IrisStyle.palette.m3secondary

                        ServiceRef {
                            service: Gpu
                        }
                    }
                }
            }

            RowLayout {
                spacing: IrisStyle.moduleGap
                visible: storageCard.active || networkCard.active || memoryCard.active

                WrappedLoader {
                    id: storageCard

                    active: Config.dashboard.performance.showStorage
                    sourceComponent: StorageCard {}
                }

                WrappedLoader {
                    id: networkCard

                    active: Config.dashboard.performance.showNetwork
                    sourceComponent: NetworkCard {}
                }

                WrappedLoader {
                    id: memoryCard

                    active: Config.dashboard.performance.showMemory
                    sourceComponent: MemoryCard {}
                }
            }
        }

        WrappedLoader {
            Layout.fillWidth: false
            active: UPower.displayDevice.isLaptopBattery && Config.dashboard.performance.showBattery
            sourceComponent: BatteryTank {}
        }
    }

    component WrappedLoader: Loader {
        Layout.fillWidth: true
        Layout.fillHeight: true
        visible: active
    }
}
