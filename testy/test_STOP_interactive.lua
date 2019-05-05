package.path = "../?.lua;"..package.path;

local winman = require("WinMan")

local spiroapp = require("STOP_spiroapp")
local framestatapp = require("STOP_framestat")
local keyboardapp = require("STOP_CompKeyboard")

local GImage = require("GIMage")
local GRandomLines = require("GRandomlines")

local desktopWidth = 1200
local desktopHeight = 1024


local bkgnd, err = GImage:createFromFile("resources/heic1501b.jpg")

WMSetBackground(bkgnd)


local function startup()
    spawn(framestatapp, {x=0, y=0, width=1200, height=20})
    spawn(keyboardapp, {x= 280, y = 600, width=640, height=290})
end

winman {width = desktopWidth, height=desktopHeight, startup = startup}