package.path = "../?.lua;"..package.path;

local winman = require("WinMan")

local mainapp = require("BEST_mag")

local desktopWidth = 1920
local desktopHeight = 1200


local function startup()
    spawn(mainapp, {frame={x=10, y=10, width=1024, height=768}})
end

winman {width = desktopWidth, height=desktopHeight, startup = startup}