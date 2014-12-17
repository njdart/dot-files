theme = {}

-- Get the base dir
local baseDir = "/home/" .. os.getenv("USER") .. "/.config/awesome/brilliant/"

theme.font          = "sans 8"

theme.bg_normal     = "#2e2e2e"
theme.bg_focus      = theme.bg_normal
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = theme.bg_normal
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#b95b3b"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.border_width  = 0
theme.border_normal = "#000000"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

theme.widgets_fg_normal = "#6b3624"

theme.menu_submenu_icon = baseDir .. "submenu.png"
theme.menu_height = 15
theme.menu_width  = 100

-- Define the image to load

theme.titlebar_close_button_normal = baseDir .. "titlebar/close_normal.png"
theme.titlebar_close_button_focus  = baseDir .. "titlebar/close_focus.png"
theme.titlebar_ontop_button_normal_inactive = baseDir .. "titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = baseDir .. "titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = baseDir .. "titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = baseDir .. "titlebar/ontop_focus_active.png"
theme.titlebar_sticky_button_normal_inactive = baseDir .. "titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = baseDir .. "titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = baseDir .. "titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = baseDir .. "titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = baseDir .. "titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = baseDir .. "titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = baseDir .. "titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = baseDir .. "titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = baseDir .. "titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = baseDir .. "titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = baseDir .. "titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = baseDir .. "titlebar/maximized_focus_active.png"

theme.wallpaper = "/home/nic/Dropbox/Backgrounds/ZVB9T40.jpg"

-- You can use your own layout icons like this:
theme.layout_fairh = baseDir .. "layouts/fairhw.png"
theme.layout_fairv = baseDir .. "layouts/fairvw.png"
theme.layout_floating  = baseDir .. "layouts/floatingw.png"
theme.layout_magnifier = baseDir .. "layouts/magnifierw.png"
theme.layout_max = baseDir .. "layouts/maxw.png"
theme.layout_fullscreen = baseDir .. "layouts/fullscreenw.png"
theme.layout_tilebottom = baseDir .. "layouts/tilebottomw.png"
theme.layout_tileleft   = baseDir .. "layouts/tileleftw.png"
theme.layout_tile = baseDir .. "layouts/tilew.png"
theme.layout_tiletop = baseDir .. "layouts/tiletopw.png"
theme.layout_spiral  = baseDir .. "layouts/spiralw.png"
theme.layout_dwindle = baseDir .. "layouts/dwindlew.png"

theme.awesome_icon = "/usr/share/awesome/icons/awesome16.png"

theme.icon_theme = nil

return theme
