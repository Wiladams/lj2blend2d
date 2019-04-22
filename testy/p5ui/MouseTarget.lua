local MouseTarget = {}
setmetatable(MouseTarget, {
    __call = function (self, ...)
        return self:new(...)
    end;
})
local MouseTarget_mt = {
    __index = MouseTarget;
}

function MouseTarget.new(self, params)
    params = params or {
        color = color(0);
        weight = 1;
    }


    local obj = {
        color = params.color or color(0);
        weight = params.weight or 1;
    }
    setmetatable(obj, MouseTarget_mt)

    return obj;
end

function MouseTarget.draw(self)
    if not mouseX then return end

    stroke(self.color)
    strokeWeight(self.weight)
    
    -- vertical line
    line(mouseX, 0, mouseX, height-1)
    -- horizontal line
    line(0,  mouseY, width-1, mouseY)
end

return MouseTarget