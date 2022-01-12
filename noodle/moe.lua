local wibox = require("wibox")
local naughty = require("naughty")
local helpers = require("helpers")

local moe_cover = wibox.widget.imagebox()
local moe_title = wibox.widget.textbox()
local moe_artist = wibox.widget.textbox()

local moe_widget = wibox.widget {
    -- Cover Image
    {
        {
            {
                {
                    image = user.profile_picture,
                    clip_shape = helpers.rrect(dpi(6)),
                    widget = moe_cover
                },
                -- shape = helpers.prrect(dpi(40), true, true, false, true),
                layout = wibox.container.background
            },
            halign = 'center',
            valign = 'center',
            layout = wibox.container.place
         },
      ---shape = helpers.rrect(box_radius / 2),
      ---widget = wibox.container.background
     height = dpi(200),
     width = dpi(200),
     layout = wibox.container.constraint
    },
    helpers.vertical_pad(dpi(10)),
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
    spacing = 4,
    layout = wibox.layout.fixed.vertical
}

awesome.connect_signal("evil::moe", function(cover, title, artist)
    if cover ~= 'NotAvailable' then
      moe_cover.image = os.getenv("HOME").."/projects/"..cover
    else
      moe_cover.image = user.profile_picture
    end
    moe_title.markup = helpers.colorize_text(title, x.color4)
    moe_artist.text = artist
    naughty.notify({ title = "Moe | Now Playing", message = title.." by "..artist })
end)

return moe_widget
