local awful = require("awful")
local helpers = require("helpers")
local naughty = require("naughty")

local function emit_info (moe_script_output)
  local cover = moe_script_output:match('cover(.*)title')
  local title = moe_script_output:match('title(.*)artist')
  local artist = moe_script_output:match('artist(.*)end')
  awesome.emit_signal("evil::moe", cover, title, artist)
  -- naughty.notify({ title = "Moe | Now Playing", message = title.." by "..artist })
end

-- local interval = 60
-- local temp_file = "/tmp/ping"

-- local is_online = [[ 
--     sh -c '
--     ping -c 1 -W 3 -q archlinux.org >&/dev/null;
--     echo $?
--   ']]

-- local moe_exists = [[
--     sh -c '
--     ps x | grep \"python /home/lucifer/projects/moe.py\" | grep -v grep | awk "{print $1}"
--     ']]

local moe_script = [[ 
    sh -c 'python $HOME/projects/moe.py'
]]

-- helpers.remote_watch(is_online, interval, temp_file, function (stdout)
--   if stdout == "0\n" then
--     awful.spawn.easy_async_with_shell()
--   end
--   -- naughty.notify({title = "-"..stdout.."-"..type(stdout), message = "-"..stdout.."-"})
-- end)

awful.spawn.easy_async_with_shell("ps x | grep \"python /home/lucifer/projects/moe.py\" | grep -v grep | awk '{print $1}' | xargs kill", function()
  awful.spawn.with_line_callback(moe_script, {
    stdout = function (line)
        emit_info(line)
    end
})
end)


