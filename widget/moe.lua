local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local helpers = require("helpers")

local default_image = os.getenv("HOME")..".config/awesome/default.jpg"

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
local moe_listeners_count = wibox.widget.textbox()

local moe_play_icon = wibox.widget.textbox()
moe_play_icon.markup = helpers.colorize_text("", x.color4)
moe_play_icon.font = "Material Icons medium 30"
moe_play_icon.align = "center"
moe_play_icon.valign = "center"

local moe_listeners_icon = wibox.widget.textbox()
moe_listeners_icon.markup = helpers.colorize_text("", x.color6)
moe_listeners_icon.font = "Material Icons medium 27"
moe_listeners_icon.align = "center"
moe_listeners_icon.valign = "center"

local function toggle_icon()
    if moe_play_icon.text == "" then
      moe_play_icon.markup = helpers.colorize_text("", x.color4)
    else
      moe_play_icon.markup = helpers.colorize_text("", x.color4)
    end
end

moe_play_icon:buttons(
    gears.table.join(
        awful.button({ }, 1, function ()
            toggle_icon()
            awful.spawn.with_shell("moe")
        end)
))

helpers.add_hover_cursor(moe_play_icon, "hand1")


local moe_widget = wibox.widget {
    -- Cover Image
    {
        {
            {
                image = default_image,
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
            font = "sans medium 14",
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
            font = "sans medium 12",
            widget = moe_artist
        },
        left = dpi(20),
        right = dpi(20),
        widget = wibox.container.margin
    },
    helpers.vertical_pad(dpi(5)),
    {
        {
        -- play icon
            {
                moe_play_icon,
                widget = wibox.container.background
            },
            helpers.horizontal_pad(dpi(70)),
        -- headphone icon
            {
                moe_listeners_icon,
                widget = wibox.container.background,
            },
        -- listener count
            {
                align = "center",
                text = "",
                font = "sans medium 12",
                widget = moe_listeners_count
            },
            spacing = 10,
            widget = wibox.layout.fixed.horizontal
        },
        align = "center",
        valign = "center",
        widget = wibox.container.place
    },
    spacing = 4,
    layout = wibox.layout.fixed.vertical
}

awesome.connect_signal("daemon::moe", function(count ,cover, title, artist)
    if tostring(cover) == "!Available" then
      moe_cover.image = default_image    
    else
      moe_cover.image = os.getenv("HOME").."/projects/"..cover
    end
    moe_title.markup = helpers.colorize_text(title, moe_playing_colors[math.random(6)])
    moe_artist.text = artist
    moe_listeners_count.text = tostring(count)
    naughty.notify({ title = "Moe | Now Playing", message = title.." by "..artist })
end)

return moe_widget
