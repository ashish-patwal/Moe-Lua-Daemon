local awful = require("awful")
local naughty = require("naughty")

local function emit_info (moe_script_output)
  local title = moe_script_output:match('title(.*)artist')
  local artist = moe_script_output:match('artist(.*)end')
  awesome.emit_signal("evil::moe", title, artist)
  -- naughty.notify({ title = "Moe | Now Playing", message = title.." by "..artist })
end

local moe_script = [[ 
    sh -c 'python $HOME/projects/moe.py'
]]

awful.spawn.easy_async_with_shell("ps x | grep \"python /home/lucifer/projects/moe.py\" | grep -v grep | awk '{print $1}' | xargs kill", function()
  awful.spawn.with_line_callback(moe_script, {
    stdout = function (line)
        emit_info(line)
    end
})
end)

