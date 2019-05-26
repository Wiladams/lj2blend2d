package.path = "../?.lua;"..package.path;

local winman = require("WinMan")

local keyboardapp = require("BEST_CompKeyboard")
local pianoapp = require("BEST_pianoapp")

local GImage = require("GIMage")

local desktopWidth = 1200
local desktopHeight = 1024


local bkgnd, err = GImage:createFromFile("resources/heic1501b.jpg")

WMSetWallpaper(bkgnd)

local function startup()
    spawn(pianoapp, {frame = {x= 280, y = 200, width=640, height=290}})
    spawn(keyboardapp, {frame = {x= 280, y = 600, width=610, height=290}})
end

winman {width = desktopWidth, height=desktopHeight, startup = startup}