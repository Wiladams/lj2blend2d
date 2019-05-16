local Drawable = require("Drawable")

local MouseTarget = Drawable:new()
setmetatable(MouseTarget, {
    __index = Drawable
})
local MouseTarget_mt = {
    __index = MouseTarget;
}


function MouseTarget.new(self, obj)
    --print("MouseTarget.new")
    obj = obj or {}
    obj.color = obj.color or 0
    obj.weight = obj.weight or 1
    obj.positionX = 0;
    obj.positionY = 0;

    setmetatable(obj, MouseTarget_mt)
    
    return obj;
end

function MouseTarget.mouseEvent(self, event)
    print("MouseTarget.mouseEvent: ", event.activity, event.x, event.y)
    self.positionX = event.x;
    self.positionY = event.y;
end

function MouseTarget.draw(self, ctx)
    --print("MouseTarget.draw: ", self.color, self.weight)
    ctx:stroke(self.color)
    ctx:strokeWidth(self.weight)

    -- vertical line
    ctx:line(self.positionX, 0, self.positionX, self.frame.height-1)
    -- horizontal line
    ctx:line(0,  self.positionY, self.frame.width-1, self.positionY)
end

return MouseTarget