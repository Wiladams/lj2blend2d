package.path = "../?.lua;"..package.path;

local winman = require("WinMan")

local framestatapp = require("STOP_framestat")
local keyboardapp = require("STOP_CompKeyboard")
local pianoapp = require("STOP_pianoapp")

local GImage = require("GIMage")
local GScaleTest = require("GScaleTest")

local desktopWidth = 1200
local desktopHeight = 1024


local bkgnd, err = GImage:createFromFile("resources/heic1501b.jpg")
--local bkgnd = GScaleTest:new()

WMSetBackground(bkgnd)

local function startup()
    --spawn(framestatapp, {x=0, y=0, width=1200, height=20})
    --spawn(keyboardapp, {x= 280, y = 600, width=640, height=290})
    spawn(pianoapp, {x= 280, y = 200, width=640, height=290})
end

winman {width = desktopWidth, height=desktopHeight, startup = startup}