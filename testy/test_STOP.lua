--[[
    A simple shell of a test program for STOP_ apps.  Create a STOPlet, then
        execute it like this:

    > luajit test_STOP stoplet 

    Give the stoplet name without the trailing '.lua'.  This will create a default sized
    desktop (1280x1024) and a default window for the STOPlet to run in (1024x768)
--]]

package.path = "../?.lua;"..package.path;

local winman = require("WinMan")

local appname = arg[1]

if not appname then 
    print("you must specify a STOPlet name")
    return nil 
end

local app = require(appname)


local function startup()
    spawn(app, {x=10, y=10, width=1024, height=768})
end

winman {width = 1280, height=1024, startup = startup, frameRate=30}