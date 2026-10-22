-- User-approved Zen whole-window opacity fallback, including webpage text.
-- Native Wayland class verified live; blur remains enabled.
hl.window_rule({
    name = "iris-zen-native-glass",
    match = { class = "^zen$" },
    opacity = "0.70 override 0.70 override",
    opaque = false,
    force_rgbx = false,
    no_blur = false,
})
-- Exact native class recorded in the existing compositor report. Current
-- launcher resolves to /usr/lib/chatgpt/ChatGPT, not a shared browser window.
-- Mild whole-window alpha includes text; retain 82% opacity; verify text contrast.
hl.window_rule({
    name = "iris-chatgpt-subtle-glass",
    match = { class = "^chatgpt$" },
    opacity = "0.82 override 0.82 override",
    opaque = false,
    force_rgbx = false,
    no_blur = false,
})

-- Discord separated from the editor rule; Code retains 0.94.
hl.window_rule({
    name = "iris-discord-subtle-glass",
    match = { class = "^(discord|Discord)$" },
    opacity = "0.82 override 0.82 override",
    no_blur = false,
})
