package.path = "../?.lua;"..package.path;

local winman = require("WinMan")

local stopviews = require("STOP_views")
local spiroapp = require("STOP_spiroapp")
local framestatapp = require("STOP_framestat")

local CheckerGraphic = require("CheckerGraphic")

local desktopWidth = 1920
local desktopHeight = 1080

-- create a graphic that will render the desktop background
local bkgnd = CheckerGraphic({
        width= desktopWidth, 
        height=desktopHeight,
        columns = 32,
        rows = 24,
        color1 = 30,
        color2 = 60
    })

WMSetBackground(bkgnd)

local function startup()
    spawn(framestatapp, {x=0, y=0, width=1920, height=20})
    spawn(stopviews,{x=100, y=100, width=1024, height=768})
    spawn(spiroapp,{x=800, y=300, width=640, height=480})
end

winman {width = 1920, height=1080, startup = startup}