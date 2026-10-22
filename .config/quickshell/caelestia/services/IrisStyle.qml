pragma Singleton
import QtQuick
import Quickshell
Singleton {
    readonly property color paper: "#f6f5f1"
    readonly property color surface: "#eaeae5"
    readonly property color ink: "#292c2a"
    readonly property color muted: "#626660"
    readonly property color hover: "#dedfd8"
    readonly property var palette: ({
        m3onSurface: "#292c2a", m3onSurfaceVariant: "#626660",
        m3primary: "#292c2a", m3onPrimary: "#f6f5f1", m3primaryContainer: "#e1e5db", m3onPrimaryContainer: "#292c2a",
        m3secondary: "#555e51", m3secondaryContainer: "#dedfd8", m3onSecondaryContainer: "#292c2a",
        m3tertiary: "#626660", m3tertiaryContainer: "#e2e3dc", m3onTertiaryContainer: "#292c2a",
        m3surfaceContainerLow: "#f6f5f1", m3surfaceContainer: "#eaeae5", m3surfaceContainerHighest: "#dedfd8",
        m3outline: "#626660", m3outlineVariant: "#cdd0c7", m3error: "#8b352e", m3scrim: "#292c2a"
    })
    readonly property int cardRadius: 14
    readonly property int cardPadding: 16
    readonly property int moduleGap: 8
    function face(size, role, weight) {
        return Qt.font({family: role === "display" ? "Space Grotesk" : role === "data" ? "JetBrains Mono" : "Satoshi",
            pixelSize: size, weight: weight || (role === "display" ? Font.Bold : Font.Medium),
            letterSpacing: role === "display" ? -0.3 : 0, features: {"tnum": 1}});
    }
    function typeface(base, role) {
        return Qt.font({family: role === "display" ? "Space Grotesk" : role === "data" ? "JetBrains Mono" : "Satoshi",
            pixelSize: Math.max(11, base.pixelSize), weight: role === "display" ? Font.Bold : Font.Medium,
            letterSpacing: role === "display" ? -0.3 : 0,
            features: {"tnum": 1}});
    }
}
