local awful = require("awful")
local vicious = require("vicious")
local theme = require("brilliant/brilliant")
local wibox = require("wibox")

-- Use a common width for all non-icon widgets
local commonWidgetWidth = 50
widgets = {}

-- {{{ spacers and misc reusable widgets
local spacer = wibox.widget.imagebox()
spacer:set_image("/home/nic/.config/awesome/icons/spacer.png")
-- }}}

-- {{{ Clock
local clock = awful.widget.textclock()
-- }}}

-- {{{ Memory Widgets
local memory = awful.widget.graph()
memory:set_width(commonWidgetWidth)
memory:set_background_color("3D5266")
memory:set_color(theme.widgets_fg_normal)
vicious.register(memory, vicious.widgets.cpu, "$1")
memIcon = wibox.widget.imagebox()
memIcon:set_image("/home/nic/.config/awesome/icons/memory.png")
-- }}}

-- {{{ CPU widgets
local cpu = awful.widget.graph()
cpu:set_width(commonWidgetWidth)
cpu:set_background_color(theme.bg_normal)
cpu:set_color(theme.widgets_fg_normal)
vicious.register(cpu, vicious.widgets.cpu, "$1")

local cpuIcon = wibox.widget.imagebox()
cpuIcon:set_image("/home/nic/.config/awesome/icons/cpu.png")

-- }}}

-- {{{ MPD and music widget
local mpd = wibox.widget.textbox()
vicious.register(mpd, vicious.widgets.mpd,
    function (mpdwidget, args)
        if args["{state}"] == "Stop" then 
            return " - "
        else 
            return args["{Artist}"]..' - '.. args["{Title}"]
        end
    end, 10)

local mpdIcon = wibox.widget.imagebox()
mpdIcon:set_image("/home/nic/.config/awesome/icons/music.png")
-- }}}

-- insert at bottom will add items to left

table.insert(widgets, spacer)
table.insert(widgets, mpd)
table.insert(widgets, spacer)
table.insert(widgets, cpuIcon)
table.insert(widgets, cpu)
table.insert(widgets, spacer)
table.insert(widgets, memIcon)
table.insert(widgets, memory)
table.insert(widgets, spacer)
table.insert(widgets, clock)

return widgets
