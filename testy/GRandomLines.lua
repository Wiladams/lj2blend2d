local floor = math.floor
local random = math.random
local pLightGray = 163

local GRandomLines = {}
GRandomLines.__index = GRandomLines

function GRandomLines.new(self, obj)
	obj = obj or {}
	
	if not obj.frame then return nil end
	
    setmetatable(obj, GRandomLines)

    return obj;
end

function GRandomLines.draw(self, ctx)

	for i = 1, 300 do
	
		local x1 = random((self.frame.width - 1));
		local y1 = random((self.frame.height - 1));
		local x2 = random((self.frame.width - 1));
		local y2 = random((self.frame.height - 1));

		local r = floor(random(0,255));
		local g = floor(random(0,255));
		local b = floor(random(0,255));

		ctx:stroke(r, g, b, 255);
		ctx:fill(r, g, b, 255);

		ctx:strokeWidth(1.0);
		ctx:line(x1, y1, x2, y2);

		--ctx:strokeWidth(8.0);
		ctx:circle(x1, y1, 4);
		ctx:circle(x2, y2, 4);
    end
end

return GRandomLines