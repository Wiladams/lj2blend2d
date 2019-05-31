--[[
    This test is to figure out what happens with the stroke
    attribute when you scale.  By default, the strokeWidth will
    scale with the rest of the graphic.

    This is undesirable in some situations, such as when you've drawn
    a unit sized figure, and you want the border to be a fixed width
    regardless of the scaling.

    This will show up as the graphic having the pen style rather than the 
    fill style if the scaling is large enough as the pen will ovewhelm the 
    size of the fill pattern.
]]
GScaleTest = {}
GScaleTest.__index = GScaleTest

local yoffset = 0;
local xoffset = 0;

local scaleX, scaleY = 64, 29

-- scale width, height
local whiteKeyWidth = 10
--local whiteKeyWidth = 0.143
local whiteKeyHeight = 10

function GScaleTest.new(self, obj)
    local obj = obj or {}
    obj.scale = obj.scale or {x=1, y=1}

    setmetatable(obj, GScaleTest)

    return obj;
end

function GScaleTest.draw(self, ctx)
    --ctx:noStroke()
    --ctx:fill(255, 127,127)
    --ctx:rect(0,0,94,292)

    ctx:push()
        ctx:fill(230)
        ctx:strokeWidth(1)
        
        ctx:scale(scaleX, scaleY)
        ctx:setTransformBeforeStroke();
        ctx:fillRectD(0,0,whiteKeyWidth, whiteKeyHeight)
        ctx:stroke(255,0,0)
        ctx:strokeRect(0,0,whiteKeyWidth, whiteKeyHeight)
        --ctx:rect(0,0,whiteKeyWidth, whiteKeyHeight)
    ctx:pop()
end

return GScaleTest
