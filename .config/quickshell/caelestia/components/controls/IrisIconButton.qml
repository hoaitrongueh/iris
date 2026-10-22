import QtQuick
import qs.services
IconButton {
    activeColour: type === IconButton.Text ? IrisStyle.hover : IrisStyle.ink
    inactiveColour: type === IconButton.Text ? "transparent" : IrisStyle.surface
    activeOnColour: type === IconButton.Text ? IrisStyle.ink : IrisStyle.paper
    inactiveOnColour: IrisStyle.ink
}
