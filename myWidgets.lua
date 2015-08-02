local awful = require("awful")
local vicious = require("vicious")
local theme = require("brilliant/brilliant")
local wibox = require("wibox")

-- {{{ Clock
local clock = awful.widget.textclock()
-- }}}

-- {{{ MPD and music widget
local mpd = wibox.widget.textbox()
vicious.register(mpd, vicious.widgets.mpd,
  function (mpdwidget, args)
    if args["{state}"] == "Stop" then 
      return ""
    else 
      return args["{Artist}"]..' - '.. args["{Title}"]
    end
  end, 10)
-- }}}

-- {{{ Wibox
--  Network usage widget
-- Initialize widget, use widget({ type = "textbox" }) for awesome < 3.5
local netMon = wibox.widget.textbox()
-- Register widget
vicious.register(netMon, vicious.widgets.net, '<span color="#CC9393">${enp3s0 down_kb} ↓</span> <span color="#7F9F7F">↑ ${enp3s0 up_kb}</span>', 3)

widgets = {
  leftWidgets = { },
  middleWidgets = { mpd },
  rightWidgets = { wibox.widget.systray(), netMon, clock }
}
return widgets
