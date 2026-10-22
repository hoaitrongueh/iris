pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Caelestia
import qs.services
import Quickshell.Wayland
import qs.components.misc

Scope {
    id: lockScope
    property var surfaces: []
    property alias lock: lock

    WlSessionLock {
        id: lock

        signal unlock

        LockSurface {
            id: surface
            Component.onCompleted: lockScope.surfaces.push(surface)
            Component.onDestruction: lockScope.surfaces = lockScope.surfaces.filter(s => s !== surface)
            lock: lock
            pam: pam
        }
    }

    Pam {
        id: pam

        lock: lock
    }

    Loader {
        asynchronous: true
        active: true
        onLoaded: active = false

        // Force a load of a screencopy so the one in the lock works
        // My guess is the ICC backend loads async on first request, which if the lock is
        // the first request it fails to capture (because it's async and the compositor
        // refuses capture when locked)
        sourceComponent: ScreencopyView {
            captureSource: Quickshell.screens[0]
        }
    }

    // qmllint disable unresolved-type
    CustomShortcut {
        // qmllint enable unresolved-type
        name: "lock"
        description: "Lock the current session"
        onPressed: lock.locked = true
    }

    // qmllint disable unresolved-type
    CustomShortcut {
        // qmllint enable unresolved-type
        name: "unlock"
        description: "Unlock the current session"
        onPressed: lock.unlock()
    }

    IpcHandler {
        function lock(): void {
            lock.locked = true;
        }

        function unlock(): void {
            lock.unlock();
        }

        function capture(path: string, region: bool, snapshot: string): string {
            if (!lock.locked) return "not locked";
            const surface = lockScope.surfaces.find(s => s.screen?.name === Hypr.focusedMonitor?.name) ?? lockScope.surfaces[0];
            if (!surface || !surface.visible) return "lock surface unavailable";
            surface.beginCapture(path, region, snapshot);
            return "requested";
        }

        function selectCapture(x: int, y: int, width: int, height: int): void {
            const surface = lockScope.surfaces.find(s => s.captureActive);
            surface?.finishCapture(Math.max(0, x), Math.max(0, y), Math.min(width, surface.width - x), Math.min(height, surface.height - y));
        }
        function cancelCapture(): void {
            for (const surface of lockScope.surfaces) surface.cancelCapture();
        }
        function isLocked(): bool {
            return lock.locked;
        }

        target: "lock"
    }
}
