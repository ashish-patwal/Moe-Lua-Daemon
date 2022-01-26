local awful = require("awful")

local function emit_info (moe_script_output)
  local count = moe_script_output:match('count(%d*)cover')
  local cover = moe_script_output:match('cover(.*)title')
  local title = moe_script_output:match('title(.*)artist')
  local artist = moe_script_output:match('artist(.*)end')
  awesome.emit_signal("daemon::moe", count, cover, title, artist)
end

local moe_script = [[
    sh -c 'python $HOME/projects/moe.py'
]]

awful.spawn.easy_async_with_shell("ps x | grep \"python /home/lucifer/projects/moe.py\" | grep -v grep | awk '{print $1}' | xargskill", function()
  awful.spawn.with_line_callback(moe_script, {
    stdout = function (line)
        emit_info(line)
    end
})
end)
