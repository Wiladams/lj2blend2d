-- Create a single seven segment digit
-- This is created within a 1x1 unit space starting with 0,0 at upper left
-- the segment is meant to be scaled before being displayed
local GSevenSegment = {}
GSevenSegment.__index = GSevenSegment

local segmentPaths = {}

function GSevenSegment.new(self, obj)
    obj = obj or {}

    local seg1 = BLPath()
    seg1:moveTo(0.01, 0.01)
    seg1:lineTo(0.49, 0.01)
    seg1:lineTo(0.309, 0.191)
    seg1:lineTo(0.191, 0.191)
    segmentPaths[1] = seg1;

    setmetatable(obj, GSevenSegment)

    return obj
end


function GSevenSegment.draw(self, ctx)

    local scalex = self.scalex or 100
    local scaley = self.scaley or 100

    ctx:fill(255,0,0)
    ctx:push()
        ctx:scale(scalex, scaley)
        for _, seg in ipairs(segmentPaths) do
            ctx:fillPath(seg)
        end
    ctx:pop()
end


return GSevenSegment

