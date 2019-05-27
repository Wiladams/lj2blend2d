--[[
    A simple shell of a test program for STOP_ apps.  Create a STOPlet, then
        execute it like this:

    > luajit test_STOP stoplet 

    Give the stoplet name without the trailing '.lua'.  This will create a default sized
    desktop (1280x1024) and a default window for the STOPlet to run in (1024x768)
--]]

package.path = "../?.lua;"..package.path;

local winman = require("WinMan")

local desktopWidth = 1200
local desktopHeight = 1024

local AnalogClock = require("AnalogClock")
local ContextRecorder = require("ContextRecorder")



-- Simple app to put up a window
-- with a graphic embedded
local function app(params)
    params.frameRate = params.frameRate or 30
    local clock = AnalogClock:new({frame={x=0,y=0,width=200,height=200}})
    local win1 = WMCreateWindow(params)
    win1:add(clock)

    local recorder = ContextRecorder:new({
        maxFrames = 300,
        basename="media\\record", 
        frameRate=30, 
        drawingContext = win1.drawingContext})




    win1:show()
    recorder:record()

    local function drawproc()
        win1:draw()
        yield();
    end

    periodic(1000/params.frameRate, drawproc)

end


local function startup()
    spawn(app, {frame = {x=4, y=4, width=320, height=240}})
end

winman {width = 1280, height=1200, startup = startup, frameRate=30}
