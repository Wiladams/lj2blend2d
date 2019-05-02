package.path = "../?.lua;"..package.path;

local winman = require("WinMan")

local circleapp = require("STOP_circle")


local function startup()
    spawn(circleapp, {x=10, y=10, width=320, height=240})
end

winman {width = 640, height=480, startup = startup}