--local b2d = require("blend2d.blend2d")

local GraphicGroup = require("GraphicGroup")
local DrawingContext = require("DrawingContext")
local TitleBar = require("TitleBar")


local Window = {}
setmetatable( Window, 
    { __index = GraphicGroup } 
)

local Window_mt = {
    __index = Window
}



function Window.new(self, obj)
    obj = GraphicGroup:new(obj)

    obj.isShown = true;
    
    -- add a drawing context
    obj.drawingContext = DrawingContext:new({width = obj.frame.width, height = obj.frame.height});
    obj.titleBar = TitleBar:new({
        frame = {x=0,y=0,width = obj.frame.width, height=36};
        window = obj;
    })
    obj.clientArea = GraphicGroup:new({frame = {
        x=0;y=0;
        width = obj.frame.width;
        heigh = obj.frame.height;
    }})
    obj.useTitleBar = obj.useTitleBar or false;
    obj.continueRunning = true;

    setmetatable(obj, Window_mt)

    obj:add(obj.clientArea)
    obj:setUseTitleBar(obj.useTitleBar)

    return obj;
end

--[[
function Window.setup(self)
end
--]]
function Window.close(self)
    --print("Window.close: ", self)
    signalAll(self, self, "windowclose")
end

function Window.destroy(self)
    --print("Window.destroy")
end

function Window.show(self)
    self.isShown = true;
end

function Window.hide(self)
    self.isShown = false;
end

function Window.setTitle(self, value)
    return self.titleBar:setTitle(value)
end

function Window.setUseTitleBar(self, useit)
    self.useTitleBar = useit;

    local clientFrame = nil

    if useit then
        self:add(self.titleBar)
        clientFrame = {
            x=0,y=self.titleBar.frame.height,
            width = self.frame.width, height = self.frame.height-self.titleBar.frame.height}
    else
        -- remove title bar
        clientFrame = {
            x=0,y=0,
            width = self.frame.width, height = self.frame.height
        }
    end
    
    self.clientArea.frame = clientFrame

    return self;
end

-- A window could be using as many buffers as it wants
-- getReadyBuffer() returns the one the window wants the
-- compositor to use in rendering it's current view
function Window.getReadyBuffer(self)
    return self.drawingContext:getReadyBuffer()
end



function Window.moveTo(self, x, y)
    self.frame.x = x
    self.frame.y = y;

    return self;
end

function Window.moveBy(self, dx, dy)
    self.frame.x = self.frame.x + dx;
    self.frame.y = self.frame.y + dy;

    return self;
end

--[[
function Window.drawBegin(self, ctxt)
    ctxt:save()

    if self.useTitleBar then
        self.titleBar:draw(ctxt)
    end

    -- adjust the coordinates for the clientArea and set clientArea clipping
    --print("drawBegin, clientArea.frame: ", self.clientArea.frame)
    --print("  x, y: ", self.clientArea.frame.x, self.clientArea.frame.y)
    --print(" width, height: ", self.clientArea.frame.width, self.clientArea.frame.height)

    ctxt:clip(self.clientArea.frame.x, self.clientArea.frame.y,
        self.clientArea.frame.width, self.clientArea.frame.height)
    ctxt:translate(self.clientArea.frame.x, self.clientArea.frame.y)
end
--]]


--william = {58, 104, 108},
function Window.drawBackground(self, ctxt)
    -- doing the clear might waste some time
    -- need to be more aware of whether there is
    -- a background to be drawn, and whether clearing
    -- is the desired behavior or not
    ctxt:clear()
    if self.backgroundStyle then
        ctxt:fill(self.backgroundStyle)    -- light gray
        ctxt:fillAll()
    end

    -- draw a black border
    local border = 0xff000000
    if self.isFocus then
        border = 0xffff0000
    end

    ctxt:stroke(BLRgba32(border))
    ctxt:strokeWidth(4)
    ctxt:strokeRect(0,0,self.frame.width, self.frame.height)
end


return Window