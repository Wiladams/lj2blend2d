package.path = "../?.lua;"..package.path;

local DeskTopper = require("DeskTopper")

local keyboardapp = require("BEST_CompKeyboard")
local pianoapp = require("BEST_pianoapp")
local clockapp = require("BEST_clock")


local function startup()
    print("SCREEN SIZE: ", width, height)
    print("DPI: ", WMGetDesktopDpi())
    spawn(pianoapp, {frame = {x= 280, y = 200, width=640, height=290}})
    spawn(keyboardapp, {frame = {x= 280, y = 600, width=610, height=290}})
    spawn(clockapp)

end

DeskTopper {startup = startup}