--local GraphicGroup = require("GraphicGroup")
local b2d = require("blend2d.blend2d")
local DrawingContext = require("DrawingContext")


--local Window = GraphicGroup:new()

local Window = {}
setmetatable(Window, {
    __call = function(self, ...)
        return self:new(...)
    end;
})
local Window_mt = {
    __index = Window
}

function Window.new(self, obj)
    if not obj then
        return nil, 'must specify parameters'
    end

    -- must have a width and height
    if not obj.frame then
        return nil, "must specify a frame"
    end

    obj.isShown = true;
    
    -- add a drawing context
    --print("Window.new: ", obj.width, obj.height)
    obj.DC = DrawingContext:new({width = obj.frame.width, height = obj.frame.height});
    obj.children = {};


    setmetatable(obj, Window_mt)

    return obj;
end

function Window.show(self)
    self.isShown = true;
end

function Window.hide(self)
    self.isShown = false;
end

function Window.getDC(self)
    return self.DC;
end

-- A window could be using as many buffers as it wants
-- getReadyBuffer() returns the one the window wants the
-- compositor to use in rendering it's current view
function Window.getReadyBuffer(self)
    return self.DC:getReadyBuffer()
end

-- an iterator over the children at a particular location
-- iterate in reverse drawing order to receive the topmost
-- visible one first.
-- The iterator does not assume any functionality of the graphic
-- other than the fact that it has a specified frame.  This is good
-- because we might be iterating for different reasons.  Maybe to send
-- a mouse event, maybe to target specific drawing
function Window.childrenAt(self, x, y)
    local function contains(frame, x, y)
        return x >= frame.x and x < frame.x+frame.width and
            y >= frame.y and y < frame.y+frame.height
    end

    local function visitor()
    for i = #self.children, 1, -1 do
        child = self.children[i]
        if child.frame and contains(child.frame, x, y) then
            return win
        end
    end
    end

    return coroutine.wrap(visitor)
end

function Window.gainFocus(self)
    self.haveFocus = true;
end

function Window.loseFocus(self)
    self.haveFocus = false;
end


function Window.mouseEvent(self, event)
    print("Window.mouseEvent: ", event.activity, event.x, event.y)
end

function Window.add(self, child, after)
    table.insert(self.children, child)
end

function Window.drawChildren(self, ctxt)
    -- draw all the children
    for _, child in ipairs(self.children) do 

        -- set clip area to child
        -- translate the context to the child's frame
        child:draw(ctxt)

        -- untranslate
        -- unclip
    end
end

function Window.drawBackground(self, ctxt)
    ctxt:clear()
    ctxt:fill(127,180)
    ctxt:fillAll()

    -- draw a black border
    local border = 0xff000000
    if self.haveFocus then
        border = 0xffff0000
    end

    ctxt:stroke(BLRgba32(border))
    ctxt:strokeWidth(4)
    ctxt:strokeRect(0,0,self.frame.width, self.frame.height)

    -- draw title bar
end

function Window.drawBegin(self, ctxt)
end

function Window.drawBody(self, ctxt)
end

function Window.drawEnd(self, ctxt)
end

function Window.draw(self, dc)
    dc = dc or self:getDC()

    self:drawBackground(dc)
    self:drawBegin(dc)
    self:drawChildren(dc)
    self:drawBody(dc)
    self:drawEnd(dc)
end

return Window
