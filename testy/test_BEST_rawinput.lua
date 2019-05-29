package.path = "../?.lua;"..package.path;

--[[
    A simple app to help test mouse and keyboard input

    Run this, perform various mouse activities, tracking
    where the mouse is, what coordinates, what clicks, what
    happens with focus between windows, etc.
--]]

local winman = require("WinMan")
local GraphicGroup = require("GraphicGroup")

local desktopWidth = 1920
local desktopHeight = 1080

local function printMouseEvent(self, event)
    print(string.format("%10s  %15s %s  screen: %d %d  window: %d %d", 
        self.title, 
        event.activity, 
        tostring(event.isDragging), 
        event.screenX, event.screenY,
        event.x, event.y))
end

-- Generic app that puts up a window
local function app(params)
    WMRawInputOn()
    
    local continueRunning = true
    local win1 = WMCreateWindow(params)
    win1:setUseTitleBar(true)
    local g = GraphicGroup:new({frame = {x=64,y=64,width=200,height=200}})
    g.title = params.title..":graphic"

    function g.printMouseEvent(self, event)
        print(string.format("Title: %10s  %10s  %15s Drag: %s  screen: %d %d  window: %d %d", 
        tostring(self.title), 
        event.activity,
        tostring(event.subactivity),
        tostring(event.isDragging), 
        event.screenX, event.screenY,
        event.x, event.y))
    end

    function g.draw(self, ctx)
        ctx:noStroke();
        ctx:fill(0xC0)
        ctx:rect(0,0,200,200)
    end

    win1:add(g)


    function win1.drawBackground(self, ctxt)
        -- doing the clear might waste some time
        -- need to be more aware of whether there is
        -- a background to be drawn, and whether clearing
        -- is the desired behavior or not
        ctxt:clear()
        ctxt:fill(self.bgcolor, 180)
        --ctxt:fill(58,104,108)
        ctxt:fillAll()
    
        -- draw a black border
        local border = 0xff000000
        if self.isFocus then
            border = 0xffff0000
        end
    
        ctxt:stroke(BLRgba32(border))
        ctxt:strokeWidth(4)
        ctxt:strokeRect(0,0,self.frame.width, self.frame.height)
    end

    win1:show()


    while continueRunning do
        win1:draw()
        yield();
    end
end




local function startup()
    spawn(app, {bgcolor = color(60), title="app1", frame = {x=40, y=40, width=640, height=480}})
    --spawn(app, {bgcolor = 220, title="app2", frame = {x=720, y=40, width=640, height=480}})
end

winman {width = desktopWidth, height=desktopHeight, startup = startup, frameRate=30}