package.path = "../?.lua;"..package.path;

local winman = require("WinMan")

local stopviews = require("STOP_views")
--local framestatapp = require("STOP_framestat")

local function startup()
    --spawn(framestatapp, {x=0, y=0, width=1200, height=20})
    spawn(stopviews,{x=100, y=100, width=640, height=480})
end

winman {width = 1200, height=1024, startup = startup}