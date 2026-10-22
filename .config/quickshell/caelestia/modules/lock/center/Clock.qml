import QtQuick
import Caelestia.Config
import qs.components
import qs.services
Item {
    id: root
    required property real centerScale
    implicitWidth: clock.implicitWidth
    implicitHeight: clock.implicitHeight
    StyledText {
        id: clock
        text: Time.format("HH:mm")
        font.family: "Adwaita Sans"
        font.pixelSize: Math.max(34, 94 * root.centerScale)
        font.weight: Font.DemiBold
        font.letterSpacing: -1
        color: "#edf3fa"
    }
}
