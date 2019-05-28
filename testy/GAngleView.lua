--[[
    Draws a view of angles as blend2d knows them
    This is just a simple graphic to answer the questions
    1) where does the zero angle start?
    2) Which direction do positive angles go around the circle?
]]
local maths = require("maths")
local radians = maths.radians
local degrees = maths.degrees
local map = maths.map
local cos = math.cos
local sin = math.sin
local clamp = maths.clamp

local GAngleView = {}
local GAngleView_mt = {
    __index = GAngleView
}

function GAngleView.new(self, obj)
    obj = obj or {
        frame = {x=0, y=0, width=500, height=500};
    }
    obj.frame = obj.frame or {x=0, y=0, width=500, height=500}
    
    obj.centerX = obj.frame.width / 2;
    obj.centerY = obj.frame.height/2;
    obj.radius = obj.frame.width/2;

    setmetatable(obj, GAngleView_mt)

    return obj;
end

function GAngleView.drawDegreeTickmarks(self, ctx)
    local segmentRads = radians(360/72)
    
    ctx:save()

    ctx:translate(self.centerX, self.centerY)

    ctx:strokeWidth(2)
    ctx:stroke(30)

    for i=0,71 do
        ctx:line(self.radius-10,0,self.radius-4, 0)
        ctx:rotate(segmentRads)
    end

    ctx:restore()
end



function GAngleView.drawDegreeNumbers(self, ctx)
    -- 10 markers around the circle
    local segmentDegs = 360/36;
    local segmentRads = radians(segmentDegs)

    ctx:save()

    ctx:translate(self.centerX, self.centerY)

    ctx:strokeWidth(2)
    ctx:stroke(30)
    ctx:fill(30)
    ctx:textAlign(MIDDLE, BASELINE)

    local cumulativeRads = 0;

    for i=0,35 do
        -- draw line
        ctx:line(30,0,self.radius-44, 0)

        -- draw the number
        ctx:save()
        ctx:translate(self.radius-25, 0)
        ctx:rotate(-cumulativeRads)
        ctx:text(tostring(i*segmentDegs), 0, 0)
        ctx:restore()
        ctx:rotate(segmentRads)

        cumulativeRads = cumulativeRads + segmentRads
    end
 
    ctx:restore()
end

function GAngleView.drawCenterSection(self, ctx)
    ctx:save()
    ctx:stroke(255, 0,0)
    ctx:strokeWidth(0.5)
    ctx:translate(self.centerX, self.centerY)
    ctx:line(-20,0,20,0)
    ctx:line(0,-20,0,20)
    ctx:restore()
end


function GAngleView.draw(self, ctx)
    ctx:save();
    
    -- fill background
    ctx:ellipseMode(RADIUS);
    ctx:stroke(255);
    ctx:strokeWidth(2);
    ctx:fill(210,210,210);

    ctx:circle(self.centerX, self.centerY, self.frame.width/2)

    -- draw a little cross-hair in the center
    self:drawCenterSection(ctx)

    self:drawDegreeTickmarks(ctx);
    --self:drawMajorDegreeLines(ctx);
    self:drawDegreeNumbers(ctx);

    ctx:restore()
end

return GAngleView
