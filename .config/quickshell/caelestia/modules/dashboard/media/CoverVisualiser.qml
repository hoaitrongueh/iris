pragma ComponentBehavior: Bound
import ".." as Dashboard
import QtQuick
import Caelestia.Config
import qs.components
import qs.services

Item {
    id: root
    Rectangle {
        id: art
        width: Math.min(parent.width - 16, parent.height - 54)
        height: width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top; anchors.topMargin: 6
        radius: 12; color: "#eaeae5"; clip: true
        Image { anchors.fill: parent; source: Players.getArtUrl(Players.active); asynchronous: true; fillMode: Image.PreserveAspectCrop }
    }
    Dashboard.Spectrum {
        anchors.top: art.bottom; anchors.topMargin: 12
        anchors.bottom: parent.bottom; anchors.bottomMargin: 8
        anchors.left: parent.left; anchors.right: parent.right; anchors.margins: 10
    }
}
