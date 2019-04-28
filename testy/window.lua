local GraphicGroup = require("GraphicGroup")
local b2d = require("blend2d.blend2d")

local Window = GraphicGroup:new()

function Window.new(self, obj)
    if not obj then
        return nil, 'must specify parameters'
    end

    -- must have a width and height

    obj.x = obj.x or 0
    obj.y = obj.y or 0

    obj.isShown = true;
    
    -- add a drawing context
    --print("Window.new: ", obj.width, obj.height)
    obj.BackingBuffer = BLImage(obj.width,obj.height)
    obj.DC = BLContext(obj.BackingBuffer)

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

function Window.getReadyBuffer(self)
    return self.BackingBuffer
end

function Window.background(self, c)
    self.background = c;
    self.DC:setFillStyle(c)
    self.DC:fillAll()
end


function Window.drawBody(self, ctxt)
    print("Window.drawBody")

    -- draw red frame around ourself
    --self.DC:setFillStyle(BLRgba32(0xff00ff00))
    --self.DC:fillRectD(0,0,self.width, self.height)
end


return Window
