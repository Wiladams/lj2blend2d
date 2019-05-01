package.path = "../?.lua;"..package.path;

local winman = require("WinMan")

local stopviews = require("STOP_views")

local function startup()
    spawn(stopviews,{x=100, y=100, width=1024, height=768})
end

winman {width = 1920, height=1080, startup = startup}