
local Graphic = require("Graphic")

local floor = math.floor
local random = math.random
local sin = math.sin;
local cos = math.cos

local SpiroGraphic = Graphic:new()

function SpiroGraphic.new(self, obj)
    obj = obj or {}
    
    obj.N = 36;
    obj.theta = 3.14159 * 2 / obj.N;
    obj.centerX = obj.centerX or obj.width/2;
    obj.centerY = obj.centerY or obj.height/2;

    setmetatable(obj, self)
    self.__index = self;
    
    return obj;
end


function SpiroGraphic:draw(ctxt)
    ctxt:stroke(255, 0,0)
    ctxt:setStrokeWidth(1)
    local x = 0;
    local y = 0;


	local Radius = (self.height / 2) - 5;

    for p = 0, self.N-1 do
		local num = floor((p / self.N) * 254.0);
        local r = random(0, num);
		local g = random(0, num);
		local b = random(0, num);
        ctxt:stroke(r, g, b)

		for q = 0, p-1 do
		    ctxt:line(floor(self.centerX + Radius * sin(p * self.theta)), floor(self.centerY + Radius * cos(p * self.theta)),
				floor(self.centerX + Radius * sin(q * self.theta)), floor(self.centerY + Radius * cos(q * self.theta)));
        end
    end
end

return SpiroGraphic
