hl.window_rule({
    name = "iris-zen-native-glass",
    match = { class = "^zen$" },
    opacity = "0.70 override 0.70 override",
    opaque = false,
    force_rgbx = false,
    no_blur = false,
})

hl.window_rule({
    name = "iris-chatgpt-subtle-glass",
    match = { class = "^chatgpt$" },
    opacity = "0.82 override 0.82 override",
    opaque = false,
    force_rgbx = false,
    no_blur = false,
})

hl.window_rule({
    name = "iris-discord-subtle-glass",
    match = { class = "^(discord|Discord)$" },
    opacity = "0.82 override 0.82 override",
    no_blur = false,
})
