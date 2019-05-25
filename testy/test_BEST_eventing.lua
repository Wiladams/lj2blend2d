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

-- Generic app that puts up a window
local function app(params)
    local win1 = WMCreateWindow(params)
    --win1:setUseTitleBar(true)
    local g = GraphicGroup:new({frame = {x=64,y=64,width=200,height=200}})
    g.title = params.title..":graphic"

    function g.printMouseEvent(self, event)
        print(string.format("Title: %10s  %15s Drag: %s  screen: %d %d  window: %d %d", 
        tostring(self.title), 
        event.activity, 
        tostring(event.isDragging), 
        event.screenX, event.screenY,
        event.x, event.y))
    end

    function g.mouseDown(self, event)
        self:printMouseEvent(event)
    end
    
    function g.mouseUp(self, event)
        self:printMouseEvent(event)
    end

    function g.mouseHover(self, event)
        self:printMouseEvent(event)
    end

    function g.mouseMove(self, event)
        self:printMouseEvent(event)
    end

    function g.draw(self, ctx)
        ctx:noStroke();
        ctx:fill(0xC0)
        ctx:rect(0,0,200,200)
    end

    win1:add(g)

    function win1.printMouseEvent(self, event)
        print(string.format("%10s  %15s %s  screen: %d %d  window: %d %d", 
            self.title, 
            event.activity, 
            tostring(event.isDragging), 
            event.screenX, event.screenY,
            event.x, event.y))
    end

    function win1.mouseDown(self, event)
        self:printMouseEvent(event)
    end
    
    function win1.mouseUp(self, event)
        self:printMouseEvent(event)
    end

    function win1.mouseHover(self, event)
        self:printMouseEvent(event)
    end

    function win1.mouseMove(self, event)
        self:printMouseEvent(event)
    end

    win1:show()

    while true do
        win1:draw()
        yield();
    end
end




local function startup()
    spawn(app, {title="app1", frame = {x=40, y=40, width=640, height=480}})
    spawn(app, {title="app2", frame = {x=720, y=40, width=640, height=480}})
end

winman {width = desktopWidth, height=desktopHeight, startup = startup, frameRate=10}