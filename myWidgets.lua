local awful = require("awful")
local vicious = require("vicious")
local theme = require("brilliant/brilliant")

widgets = {}

-- {{{ Memory Widget
widgets.memory = awful.widget.graph()
widgets.memory:set_width(30)
widgets.memory:set_background_color(theme.bg_normal)
widgets.memory:set_color(theme.widgets_fg_normal)
vicious.register(widgets.memory, vicious.widgets.cpu, "$1")

-- }}}

-- {{{ CPU widget
cpuwidget = awful.widget.graph()
cpuwidget:set_width(30)
cpuwidget:set_background_color("#494B4F")
vicious.register(cpuwidget, vicious.widgets.cpu, "$1")
-- }}}
