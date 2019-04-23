local Drawable = require("p5ui.Drawable")

local MouseTarget = Drawable:new()
MouseTracker.__index = MouseTarget

--setmetatable(MouseTarget, {
--    __call = function (self, ...)
--        return self:new(...)
--    end;
--})

function MouseTarget.new(self, obj)
    print("MouseTarget.new")
    obj = obj or {
        color = 0;
        weight = 1;
    }
    obj.color = obj.color or 0
    obj.weight = obj.weight or 0.5

    setmetatable(obj, self)
    --self.__index = self;
    
    return obj;
end


function MouseTarget:drawBody(drawingContext)
    if not mouseX then return end

    stroke(self.color)
    strokeWeight(self.weight)

    -- vertical line
    line(mouseX, 0, mouseX, height-1)
    -- horizontal line
    line(0,  mouseY, width-1, mouseY)
end

return MouseTarget