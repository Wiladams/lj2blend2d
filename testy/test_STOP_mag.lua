package.path = "../?.lua;"..package.path;

local winman = require("WinMan")

local mainapp = require("STOP_mag")


local function startup()
    spawn(mainapp, {x=10, y=10, width=1024, height=768})
end

winman {width = 1920, height=1200, startup = startup}