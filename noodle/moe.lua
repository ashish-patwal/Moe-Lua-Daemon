local wibox = require("wibox")
local naughty = require("naughty")
local helpers = require("helpers")

local moe_playing_colors = {
    x.color7,
    x.color8,
    x.color9,
    x.color10,
    x.color11,
    x.color12,
}

local moe_cover = wibox.widget.imagebox()
local moe_title = wibox.widget.textbox()
local moe_artist = wibox.widget.textbox()

local moe_widget = wibox.widget {
    -- Cover Image
    {
        {
            {
                image = user.not_available,
                clip_shape = helpers.rrect(dpi(16)),
                widget = moe_cover
            },
            halign = 'center',
            valign = 'center',
            layout = wibox.container.place
         },
      ---shape = helpers.rrect(box_radius / 2),
      ---widget = wibox.container.background
     height = dpi(250),
     width = dpi(250),
     layout = wibox.container.constraint
    },
    helpers.vertical_pad(dpi(10)),
    -- Title widget
    {
        {
            align = "center",
            markup = helpers.colorize_text("MoeChan", x.color4),
            font = "sans 14",
            widget = moe_title
        },
        left = dpi(20),
        right = dpi(20),
        widget = wibox.container.margin
    },
    -- Artist widget
    {
        {
            align = "center",
            text = "unavailable",
            font = "sans 12",
            widget = moe_artist
        },
        left = dpi(20),
        right = dpi(20),
        widget = wibox.container.margin
    },
    spacing = 4,
    layout = wibox.layout.fixed.vertical
}

awesome.connect_signal("evil::moe", function(cover, title, artist)
    if cover ~= 'Not Available' then
      moe_cover.image = os.getenv("HOME").."/projects/"..cover
    else
      moe_cover.image = user.not_available
    end
    moe_title.markup = helpers.colorize_text(title, moe_playing_colors[math.random(6)])
    moe_artist.text = artist
    naughty.notify({ title = "Moe | Now Playing", message = title.." by "..artist })
end)

return moe_widget
