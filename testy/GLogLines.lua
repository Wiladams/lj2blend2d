local maths = require("maths")
local map = maths.map
local log10 = math.log10

local GLogLines = {}

function GLogLines.new(self)
    self.lineIncrement = 0.5
    self.offsetIncrement = 0.05     -- increase/decrease this amount for speed
    self.offsetAmount = 0;

    return self;
end

function GLogLines.draw(self, ctx)
    ctx:stroke(255,0,0)
    local x1 = 0
    local x2 = width

    if self.offsetAmount < self.offsetIncrement then
        self.offsetAmount = self.lineIncrement
    end

    for i=1,10, self.lineIncrement do
        local y = map(log10(i+self.offsetAmount), 0, 1, height, height/2)
        ctx:line(x1, y, x2, y)
    end

    -- shift line a little bit
    self.offsetAmount = self.offsetAmount - self.offsetIncrement
end

return GLogLines
