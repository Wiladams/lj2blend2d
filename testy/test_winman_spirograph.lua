package.path = "../?.lua;"..package.path;

local winman = require("WinMan")

local spiroapp = require("STOP_spiroapp")

local function startup()
    spawn(spiroapp,{frame = {x=100, y=100, width=640, height=480}})
    spawn(spiroapp, {frame = {x=300, y=400, width=400, height=400}})
end

winman {width = 1200, height=1024, startup = startup}