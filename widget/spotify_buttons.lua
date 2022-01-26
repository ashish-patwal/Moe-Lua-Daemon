local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local helpers = require("helpers")

local spotify_prev_symbol = wibox.widget.textbox()
spotify_prev_symbol.markup = helpers.colorize_text("≪", x.foreground.."33")
spotify_prev_symbol.font = "Material Icons Bold 18"
spotify_prev_symbol.align = "center"
spotify_prev_symbol.valign = "center"
local spotify_next_symbol = wibox.widget.textbox()
spotify_next_symbol.markup = helpers.colorize_text("≫", x.foreground.."33")
spotify_next_symbol.font = "Material Icons Bold 18"
spotify_next_symbol.align = "center"
spotify_next_symbol.valign = "center"

-- local note_symbol = ""
-- local note_symbol = "♫"
local note_symbol = "ッ"
local big_note = wibox.widget.textbox()
big_note.font = "Material Icons Bold 17"
big_note.align = "center"
big_note.markup = helpers.colorize_text(note_symbol, x.foreground.."33")
local small_note = wibox.widget.textbox()
small_note.align = "center"
small_note.markup = helpers.colorize_text(note_symbol, x.foreground.."55")
small_note.font = "Material Icons Bold 13"
-- small_note.valign = "bottom"
local double_note = wibox.widget {
    big_note,
    -- small_note,
    {
        small_note,
        top = dpi(11),
        widget = wibox.container.margin
    },
    spacing = dpi(-5),
    layout = wibox.layout.fixed.horizontal
}

local spotify_toggle_icon = wibox.widget {
    double_note,
    -- bg = "#00000000",
    widget = wibox.container.background
}
spotify_toggle_icon:buttons(gears.table.join(
    awful.button({ }, 1, function ()
        awful.spawn.with_shell("playerctl --player spotify play-pause")
    end)
))

local spotify_prev_icon = wibox.widget {
    spotify_prev_symbol,
    shape = gears.shape.circle,
    widget = wibox.container.background
}
spotify_prev_icon:buttons(gears.table.join(
    awful.button({ }, 1, function ()
        awful.spawn.with_shell("playerctl --player spotify previous")
    end)
))

local spotify_next_icon = wibox.widget {
    spotify_next_symbol,
    shape = gears.shape.circle,
    widget = wibox.container.background
}
spotify_next_icon:buttons(gears.table.join(
    awful.button({ }, 1, function ()
        awful.spawn.with_shell("playerctl --player spotify next")
    end)
))

local music_playing_colors = {
    x.color1,
    x.color2,
    x.color3,
    x.color4,
    x.color5,
    x.color6,
}

awesome.connect_signal("daemon::spotify", function(artist, title, status)
    local accent, small_note_color
    if string.lower(status) == "paused" then
        accent = x.foreground.."33"
        small_note_color = x.foreground.."55"
    else
        accent = music_playing_colors[math.random(6)]
        small_note_color = x.foreground
    end

    big_note.markup = helpers.colorize_text(note_symbol, accent)
    small_note.markup = helpers.colorize_text(note_symbol, small_note_color)

    spotify_prev_symbol.markup = helpers.colorize_text(spotify_prev_symbol.text, accent)
    spotify_next_symbol.markup = helpers.colorize_text(spotify_next_symbol.text, accent)
end)

local spotify_buttons = wibox.widget {
    nil,
    {
        spotify_prev_icon,
        spotify_toggle_icon,
        spotify_next_icon,
        spacing = dpi(14),
        layout  = wibox.layout.fixed.horizontal
    },
    expand = "none",
    layout = wibox.layout.align.horizontal,
}

-- Add clickable mouse effects on some widgets
helpers.add_hover_cursor(spotify_next_icon, "hand1")
helpers.add_hover_cursor(spotify_prev_icon, "hand1")
helpers.add_hover_cursor(spotify_toggle_icon, "hand1")

return spotify_buttons
