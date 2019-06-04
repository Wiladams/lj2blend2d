--[[
    A simple shell of a test program for STOP_ apps.  Create a STOPlet, then
        execute it like this:

    > luajit test_STOP stoplet 

    Give the stoplet name without the trailing '.lua'.  This will create a default sized
    desktop (1280x1024) and a default window for the STOPlet to run in (1024x768)
--]]

package.path = "../?.lua;"..package.path;

local winman = require("WinMan")

local desktopWidth = 1920
local desktopHeight = 1200

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
    local gframe = {x=params.frame.x, y=params.frame.y,width=params.frame.width,height=params.frame.height}
    local g = graphic:new({frame = gframe})

    local win1 = WMCreateWindow(params)
--local william = color(58, 104, 108)
    win1.backgroundStyle = color(255)

    function win1.drawForeground(self, ctx)
        g:draw(ctx)
    end

    win1:show()

    local function drawproc()
        win1:draw()
        yield();
    end

    periodic(1000/params.frameRate, drawproc)

end


local function startup()
    spawn(app, {frame = {x=4, y=4, width=desktopWidth, height=desktopHeight}})
end

winman {width = desktopWidth, height=desktopHeight, startup = startup, frameRate=30}