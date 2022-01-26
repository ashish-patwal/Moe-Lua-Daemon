local gears = require("gears")
local wibox = require("wibox")

-- Set colors
local title_color = x.color7
local artist_color = x.color7
local paused_color = x.color8

local mpd_title = wibox.widget{
    text = "---------",
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox
}

local mpd_artist = wibox.widget{
    text = "---------",
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox
}

-- Main widget
local mpd_song = wibox.widget{
    mpd_title,
    mpd_artist,
    layout = wibox.layout.fixed.vertical
}

local artist_fg
local artist_bg
awesome.connect_signal("daemon::mpd", function(artist, title, status)
    if status == "paused" then
        artist_fg = paused_color
        title_fg = paused_color
    else
        artist_fg = artist_color
        title_fg = title_color
    end

    -- Escape &'s
    title = string.gsub(title, "&", "&amp;")
    artist = string.gsub(artist, "&", "&amp;")

    mpd_title.markup =
        "<span foreground='" .. title_fg .."'>"
        .. title .. "</span>"
    mpd_artist.markup =
        "<span foreground='" .. artist_fg .."'>"
        .. artist .. "</span>"
end)

return mpd_song
