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

local graphicname = arg[1]

if not graphicname then 
    print("usage: luajit test_BEST_Graphic.lua graphicname")
    return nil 
end

local graphic = require(graphicname)


-- Simple app to put up a window
-- with a graphic embedded
local function app(params)
    params.frameRate = params.frameRate or 30

    local win1 = WMCreateWindow(params)

    win1:add(graphic:new({frame = params.frame}))
    win1:show()

    local function drawproc()
        win1:draw()
    end

--    periodic(1000/params.frameRate, drawproc)
---[[
    while true do 
        win1:draw()
        yield()
    end
--]]
end


local function startup()
    spawn(app, {frame = {x=4, y=4, width=1200, height=1080}})
end

winman {width = 1280, height=1200, startup = startup, frameRate=60}