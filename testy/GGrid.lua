--[[
    Experiments in drawing a grid using very thin rectangles

    It is hard to control a stroke, as it wants to split across the centerline evenly.
    This makes it challenging to fit to pixels exactly.  Drawing rectangles will 
    give exact fit in some situations, so this experiment.
--]]

local GGrid = {}
local GGrid_mt = {
    __index = GGrid
}

function GGrid.new(self, obj)
    obj = obj or {}
    obj.cellWidth = obj.frame.width / 32
    obj.cellHeight = obj.frame.height / 32
    setmetatable(obj, GGrid_mt)
    return obj
end

function GGrid.draw(self, ctx)
    ctx:fill(255,255,0)
    ctx:noStroke();

    for row = 0, 31 do
        for vline = 1, 31 do
            ctx:rect(self.cellWidth*vline, row*self.cellHeight, 1, self.cellHeight)
            ctx:rect(self.cellWidth*(vline-1), (row+1)*self.cellHeight, self.cellWidth, 1)
        end
    end
end

return GGrid
