theme = {}

-- Get the base dir
local baseDir = "/home/" .. os.getenv("USER") .. "/.config/awesome/brilliant/"

theme.wallpaper = baseDir .. "background.jpg"

theme.font          = "sans 8"

theme.bg_normal     = "#2e2e2e"--"#222222"
theme.bg_focus      = theme.bg_normal--"#535d6c"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = theme.bg_normal--"#444444"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#b95b3b"--"#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.border_width  = 0--1
theme.border_normal = "#000000"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

theme.menu_submenu_icon = baseDir .. "submenu.png"
theme.menu_height = 15
theme.menu_width  = 100

theme.layout_floating  = baseDir .. "layouts/floatingw.png"
theme.layout_max = baseDir .. "layouts/maxw.png"
theme.layout_fullscreen = baseDir .. "layouts/fullscreenw.png"
theme.layout_tilebottom = baseDir .. "layouts/tilebottomw.png"
theme.layout_tileleft   = baseDir .. "layouts/tileleftw.png"
theme.layout_tile = baseDir .. "layouts/tilew.png"
theme.layout_tiletop = baseDir .. "layouts/tiletopw.png"

theme.awesome_icon = "/usr/share/awesome/icons/awesome16.png"

theme.icon_theme = nil

-- Lain things
theme.useless_gap_width = 10

return theme
