local wibox = require("wibox")
local naughty = require("naughty")
local helpers = require("helpers")

local moe_title = wibox.widget.textbox()
local moe_artist = wibox.widget.textbox()

local moe_widget = wibox.widget {
    -- Title widget
    {
        align = "center",
        markup = helpers.colorize_text("MoeChan", x.color4),
        font = "sans 14",
        widget = moe_title
    },
    -- Artist widget
    {
        align = "center",
        text = "unavailable",
        font = "sans 10",
        widget = moe_artist
    },
    spacing = 2,
    layout = wibox.layout.fixed.vertical
}

awesome.connect_signal("evil::moe", function(title, artist)
    moe_title.markup = helpers.colorize_text(title, x.color4)
    moe_artist.text = artist
    naughty.notify({ title = "Moe | Now Playing", message = title.." by "..artist })
end)

return moe_widget
