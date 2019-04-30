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
    if not obj.width or not obj.height then
        return nil, "must specify window dimensions"
    end

    obj.x = obj.x or 0
    obj.y = obj.y or 0

    obj.isShown = true;
    
    -- add a drawing context
    --print("Window.new: ", obj.width, obj.height)
    obj.DC = DrawingContext:new(obj.width, obj.height);
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

function Window.drawBegin(self, ctxt)
    --ctxt:fill(0x7f,0x7f)
    --ctxt:fillAll()

    ctxt:stroke(BLRgba32(0xff000000))
    ctxt:strokeWidth(4)
    ctxt:strokeRect(0,0,self.width, self.height)

    -- draw title bar
end

function Window.drawBody(self, ctxt)
end

function Window.drawEnd(self, ctxt)
end

function Window.draw(self, dc)
    dc = dc or self:getDC()

    self:drawBegin(dc)
    self:drawChildren(dc)
    self:drawBody(dc)
    self:drawEnd(dc)
end

return Window
