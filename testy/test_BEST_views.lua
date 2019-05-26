package.path = "../?.lua;"..package.path;

local winman = require("WinMan")

local stopviews = require("BEST_views")

local CheckerGraphic = require("CheckerGraphic")

local desktopWidth = 1920
local desktopHeight = 1080

-- create a graphic that will render the desktop background
local bkgnd = CheckerGraphic({
    frame = {
        width= desktopWidth, 
        height=desktopHeight,
    };
    columns = 32,
    rows = 24,
    color1 = 30,
    color2 = 60
})

WMSetWallpaper(bkgnd)

local function startup()
    spawn(stopviews,{frame = {x=100, y=100, width=1024, height=768}})
end

winman {width = 1920, height=1080, startup = startup}