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
local makeVideo = false;
if arg[2] == "video" then
    makeVideo = true;
end

if not appname then 
    print("you must specify a STOPlet name")
    return nil 
end

local app = require(appname)


local function startup()
    spawn(app, {frame = {x=10, y=10, width=1024, height=768}})
end

winman {width = 1920, height=1200, startup = startup, frameRate=10}