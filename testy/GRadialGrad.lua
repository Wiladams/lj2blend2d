local Gradient = require("Gradient")

local RadialGradient = Gradient.RadialGradient

GRadialGrad = {}
GRadialGrad.__index = GRadialGrad

function GRadialGrad.new(self, obj)
    obj = obj or {}
    obj.cx = obj.frame.x + obj.frame.width/2
    obj.cy = obj.frame.y + obj.frame.height/2

    obj.radial = RadialGradient({values = {obj.cx, obj.cy, obj.cx, obj.cy-300, obj.cx},
        stops = {
            {offset = 0.0, uint32 = 0xFFFFFFFF},
            {offset = 1.0, uint32 = 0xFFFF6F3F}
        }
    })

    setmetatable(obj, GRadialGrad)
    
    return obj;
end

function GRadialGrad.draw(self, ctx)
    ctx:fill(self.radial)
    ctx:circle(self.cx, self.cy, self.cx)

    return self;
end

return GRadialGrad
