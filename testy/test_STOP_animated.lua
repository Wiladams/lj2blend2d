package.path = "../?.lua;"..package.path;

local winman = require("WinMan")

local spiroapp = require("STOP_spiroapp")
local framestatapp = require("STOP_framestat")

local function startup()
    spawn(framestatapp, {x=0, y=0, width=1200, height=20})
    spawn(spiroapp,{x=100, y=100, width=640, height=480})
    --spawn(spiroapp, {x=300, y=400, width=400, height=400})
end

winman {width = 1200, height=768, startup = startup}