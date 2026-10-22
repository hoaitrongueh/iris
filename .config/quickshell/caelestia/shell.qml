//@ pragma Env QS_CRASHREPORT_URL=https://github.com/caelestia-dots/shell/issues/new?template=crash.yml
//@ pragma DefaultEnv QS_NO_RELOAD_POPUP=1
//@ pragma DefaultEnv QS_DROP_EXPENSIVE_FONTS=1
//@ pragma DefaultEnv QSG_RENDER_LOOP=threaded
//@ pragma DefaultEnv QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000

import "modules"
import "modules/drawers"
import "modules/background"
import "modules/areapicker"
import "modules/lock"
import QtQuick
import Quickshell
import Quickshell.Io
import qs.services

ShellRoot {
    id: root

    settings.watchFiles: false

    Binding {
        target: ShellState
        property: "shellRoot"
        value: root
    }

    IpcHandler {
        target: "irisDashboard"
        function tab(index: int): void { const s = ShellState.forActive(); if (!s) return; s.dashboardTab = Math.max(0, Math.min(2, index)); s.dashboard = true; }
        function show(): void { const s = ShellState.forActive(); if (s) s.dashboard = true; }
        function hide(): void { const s = ShellState.forActive(); if (s) s.dashboard = false; }
        function toggle(): void { const s = ShellState.forActive(); if (s) s.dashboard = !s.dashboard; }
        function position(edge: string): void {
            if (edge !== "top" && edge !== "bottom") return;
            const s = ShellState.forActive();
            if (s) s.dashboardPosition = edge;
        }
        function status(): string {
            const state = ShellState.forActive();
            if (!state) return "{}";
            return JSON.stringify({open: state.dashboard, tab: state.dashboardTab, position: state.dashboardPosition, playing: Players.active?.isPlaying ?? false, bins: Audio.cava.values.length, peak: Math.max(0, ...Audio.cava.values)});
        }
    }
    GSFLoader {}
    ServiceLoader {}

    Background {}
    Drawers {}
    AreaPicker {}
    Lock {
        id: lock
    }

    Shortcuts {}
    BatteryMonitor {}
    IdleMonitors {
        lock: lock
    }
}
