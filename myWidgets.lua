local awful = require("awful")
local vicious = require("vicious")
local theme = require("brilliant/brilliant")
local wibox = require("wibox")

widgets = {}

local commonWidgetWidth = 30

-- {{{ Memory Widgets
widgets.memory = awful.widget.graph()
widgets.memory:set_width(commonWidgetWidth)
widgets.memory:set_background_color(theme.bg_normal)
widgets.memory:set_color(theme.widgets_fg_normal)
vicious.register(widgets.memory, vicious.widgets.cpu, "$1")

widgets.memIcon = wibox.widget.imagebox()
widgets.memIcon:set_image("/home/nic/.config/awesome/icons/memory.png")

-- }}}

-- {{{ CPU widgets
widgets.cpu = awful.widget.graph()
widgets.cpu:set_width(commonWidgetWidth)
widgets.cpu:set_background_color(theme.bg_normal)
widgets.cpu:set_color(theme.widgets_fg_normal)
vicious.register(widgets.cpu, vicious.widgets.cpu, "$1")

widgets.cpuIcon = wibox.widget.imagebox()
widgets.cpuIcon:set_image("/home/nic/.config/awesome/icons/cpu.png")

-- }}}

-- {{{ MPD and music widget
widgets.mpd = wibox.widget.textbox()
vicious.register(widgets.mpd, vicious.widgets.mpd,
    function (mpdwidget, args)
        if args["{state}"] == "Stop" then 
            return " - "
        else 
            return args["{Artist}"]..' - '.. args["{Title}"]
        end
    end, 10)

widgets.mpdIcon = wibox.widget.imagebox()
widgets.mpdIcon:set_image("/home/nic/.config/awesome/icons/music.png")
-- }}}


-- {{{ Misc widgets
widgets.spacer = wibox.widget.imagebox()
widgets.spacer:set_image("/home/nic/.config/awesome/icons/spacer.png")
-- }
