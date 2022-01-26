-- modules
local awful = require("awful")
local helpers = require("helpers")
local wibox = require("wibox")

-- Moe
local moe = require("widget.moe")

-- Spotify
local spotify_buttons = require("widget.spotify_buttons")
local spotify = require("widget.spotify")
local spotify_widget_children = spotify:get_all_children()
local spotify_title = spotify_widget_children[1]
local spotify_artist = spotify_widget_children[2]
spotify_title.forced_height = dpi(22)
spotify_artist.forced_height = dpi(16)

-- Mpd
local mpd_buttons = require("widget.mpd_buttons")
local mpd_song = require("widget.mpd_song")
local mpd_widget_children = mpd_song:get_all_children()
local mpd_title = mpd_widget_children[1]
local mpd_artist = mpd_widget_children[2]
mpd_title.font = "sans medium 14"
mpd_artist.font = "sans medium 10"

-- Set forced height in order to limit the widgets to one line.
-- Might need to be adjusted depending on the font.
mpd_title.forced_height = dpi(22)
mpd_artist.forced_height = dpi(16)

mpd_song:buttons(gears.table.join(
    awful.button({ }, 1, function ()
        awful.spawn.with_shell("mpc -q toggle")
    end),
    awful.button({ }, 3, apps.music),
    awful.button({ }, 4, function ()
        awful.spawn.with_shell("mpc -q prev")
    end),
    awful.button({ }, 5, function ()
        awful.spawn.with_shell("mpc -q next")
    end)
))



-- Create the music sidebar
music_sidebar = wibox({visible = false, ontop = true, type = "dock", screen = screen.primary})
music_sidebar.bg = "#00000000" -- For anti aliasing
music_sidebar.fg = x.color7
music_sidebar.opacity = 1
music_sidebar.height = screen.primary.geometry.height/1.5
music_sidebar.width = dpi(300)
music_sidebar.y = 0

awful.placement.right(music_sidebar)
awful.placement.maximize_vertically(sidebar, { honor_workarea = true, margins = { top = dpi(5) * 2 } })

music_sidebar:buttons(gears.table.join(
    -- Middle click - Hide sidebar
    awful.button({ }, 2, function ()
        music_sidebar_hide()
    end)
))

music_sidebar:connect_signal("mouse::leave", function ()
        music_sidebar_hide()
end)

music_sidebar_show = function()
    music_sidebar.visible = true
end

music_sidebar_hide = function()
    music_sidebar.visible = false
end

music_sidebar_toggle = function()
    if music_sidebar.visible then
        music_sidebar_hide()
    else
        music_sidebar.visible = true
    end
end

-- Activate sidebar by moving the mouse at the edge of the screen

local music_sidebar_activator = wibox({y = music_sidebar.y, width = 1, visible = true, ontop = false, opacity = 0, below = true, screen = screen.primary})
    music_sidebar_activator.height = music_sidebar.height
    music_sidebar_activator:connect_signal("mouse::enter", function ()
        music_sidebar.visible = true
    end)
        awful.placement.right(music_sidebar_activator)

-- Music sidebar placement
music_sidebar:setup {
            {
                {
                    {
                        {
                          helpers.vertical_pad(dpi(25)),
                          moe,
                          helpers.vertical_pad(dpi(15)),
                          layout = wibox.layout.fixed.vertical
                        },
                      halign = 'center',
                      valign = 'center',
                      layout = wibox.container.place
                    },
                  shape = helpers.prrect(dpi(40), true, false, false, true),
                  bg = x.color8.."30",
                  widget = wibox.container.background
                },
                {
                  {
                    helpers.vertical_pad(dpi(30)),
                    {
                      spotify_buttons,
                      spotify,
                      spacing = dpi(5),
                      layout = wibox.layout.fixed.vertical
                    },
                    layout = wibox.layout.fixed.vertical
                  },
                  left = dpi(20),
                  right = dpi(20),
                  widget = wibox.container.margin
                },
                {
                   {
                        mpd_buttons,
                        mpd_song,
                        spacing = dpi(5),
                        layout = wibox.layout.fixed.vertical
                    },
                    top = dpi(40),
                    bottom = dpi(20),
                    left = dpi(20),
                    right = dpi(20),
                    widget = wibox.container.margin
                },
                helpers.vertical_pad(dpi(25)),
                layout = wibox.layout.fixed.vertical
            },
    shape = helpers.prrect(dpi(40), true, false, false, true),
    bg = x.background,
    widget = wibox.container.background
} 
