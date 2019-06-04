--[[
    A simple shell of a test program for drawables.  

        execute it like this:

    > luajit test_BEST_Drawable.lua bestlet 

    Give the bestlet name without the trailing '.lua'.  This will create a default sized
    desktop (1280x1024) and a default window for the drawable to draw itself into.
    
    Great for testing out drawables in isolation
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


-- Environment to display drawables
-- no windows, no control, just give the 
-- drawable a chance to draw
local function app(params)
    local win = WMCreateWindow({frame={x=0,y=0,width=desktopWidth, height=desktopHeight}})
    --function win.drawBackground(self, ctx)
    --end

    local g = graphic:new(params)

    function win.drawForeground(self, ctx)
        g:draw(ctx)
    end

    local function drawproc()
        win:draw()
        --BLImageCodec("BMP"):writeImageToFile(win.drawingContext:getReadyBuffer(), "imageCapture.bmp")    
    end

    periodic(1000/30, drawproc)
end


local function startup()
    spawn(app)
end

winman {width = desktopWidth, height=desktopHeight, startup = startup, frameRate=10}