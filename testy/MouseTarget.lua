local Drawable = require("Drawable")

local MouseTarget = Drawable:new()
--MouseTracker.__index = MouseTarget


function MouseTarget.new(self, obj)
    --print("MouseTarget.new")
    local obj = Drawable:new(obj)
    obj.color = obj.color or 0
    obj.weight = obj.weight or 1

    setmetatable(obj, self)
    self.__index = self;
    
    return obj;
end


function MouseTarget.draw(self, ctx)
    if not mouseX then return end

    ctx:stroke(self.color)
    ctx:strokeWidth(self.weight)

    -- vertical line
    ctx:line(mouseX, 0, mouseX, height-1)
    -- horizontal line
    ctx:line(0,  mouseY, width-1, mouseY)
end

return MouseTarget