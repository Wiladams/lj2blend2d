package.path = "../?.lua;"..package.path;

local winman = require("WinMan")

local spiroapp = require("STOP_spiroapp")
local framestatapp = require("STOP_framestat")
local keyboardapp = require("STOP_CompKeyboard")

local GImage = require("GIMage")
local GRandomLines = require("GRandomlines")

local desktopWidth = 1200
local desktopHeight = 1024

local liner = GRandomLines:new({frame={width=desktopWidth, height=desktopHeight}})

local img, err = BLImageCodec:readImageFromFile("resources/kibera_1.jpg")
--print("readImage: ", img, err)

local bkgnd, err = GImage:new({image = img, frame = BLRect({0,0,desktopWidth, desktopHeight})})
--print("bkgnd: ", bkgnd, err)

--WMSetBackground(bkgnd)
WMSetBackground(liner)

local function startup()
    --spawn(framestatapp, {frame = {x=0, y=40, width=1200, height=40}})
    spawn(spiroapp,{frame = {x=100, y=100, width=640, height=480}})
    spawn(keyboardapp, {frame = {x= 280, y = 600, width=640, height=290}})
end

winman {width = desktopWidth, height=desktopHeight, startup = startup, frameRate=30}