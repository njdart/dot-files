local awful = require("awful")
local vicious = require("vicious")
local theme = require("brilliant/brilliant")
local wibox = require("wibox")

-- Use a common width for all non-icon widgets
local commonWidgetWidth = 50

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
memory:set_background_color(theme.bg_normal)
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

leftFloating = {}
middleFloating = {}
rightFloating = {}

table.insert(rightFloating, clock)

table.insert(middleFloating, mpd)

widgets = {
  leftWidgets = leftFloating,
  middleWidgets = middleFloating,
  rightWidgets = rightFloating
}
return widgets
