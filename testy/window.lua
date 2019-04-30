local GraphicGroup = require("GraphicGroup")
local b2d = require("blend2d.blend2d")
local DrawingContext = require("DrawingContext")


local Window = GraphicGroup:new()

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
    --obj.BackingBuffer = BLImage(obj.width,obj.height)
    --obj.DC = BLContext(obj.BackingBuffer)
    --obj.DC:clear();

    setmetatable(obj, self)
    self.__index = self;

    return obj;
end

function Window.show()
    isShown = true;
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

--function Window.drawBody(self, ctxt)
--    print("Window.drawBody")
--end

return Window
