local floor = math.floor
local random = math.random

GRandomLines:draw(self, ctx)

	ctx:background(pLightGray);

	for i = 1, 100 do
	
		local x1 = random((width - 1));
		local y1 = random((height - 1));
		local x2 = random((width - 1));
		local y2 = random((height - 1));

		local r = floor(random(0,255));
		local g = floor(random(0,255));
		local b = floor(random(0,255));

		ctx:stroke(r, g, b, 255);
		ctx:fill(r, g, b, 255);

		ctx:strokeWidth(1.0);
		ctx:line(x1, y1, x2, y2);

		ctx:strokeWidth(8.0);
		ctx:circle(x1, y1, 4);
		ctx:circle(x2, y2, 4);
	}
end