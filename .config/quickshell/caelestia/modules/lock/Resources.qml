pragma ComponentBehavior: Bound
import "../dashboard" as Dashboard
import QtQuick
import Quickshell.Services.UPower
import Caelestia.Services
import qs.services

Item {
    id: root
    implicitHeight: (width - 10) / 2 * 1.14 * 2 + 10
    ServiceRef { service: Cpu }
    ServiceRef { service: Memory }
    ServiceRef { service: Storage }
    Grid {
        anchors.fill: parent; columns: 2; spacing: 10
        Dashboard.ResourceDial { width: (root.width - 10) / 2; height: width * 1.14; label: "CPU"; value: Cpu.percentage }
        Dashboard.ResourceDial { width: (root.width - 10) / 2; height: width * 1.14; label: "Memory"; value: Memory.percentage; accent: "#c1bfdc" }
        Dashboard.ResourceDial { width: (root.width - 10) / 2; height: width * 1.14; label: "Storage"; value: Storage.percentage; accent: "#b4c9c4" }
        Dashboard.ResourceDial { width: (root.width - 10) / 2; height: width * 1.14; label: UPower.onBattery ? "Battery" : "Charging"; value: UPower.displayDevice.percentage; accent: "#d0c5b5" }
    }
}
