local GraphicGroup = require("GraphicGroup")
local maths = require("maths")

local map = maths.map
local constrain = maths.constrain



local MotionConstraint = {}
local MotionConstraint_mt = {
    __index = MotionConstraint
}

function MotionConstraint.new(self, obj)
    obj = obj or {}
    obj.minX = obj.minX or 0;
    obj.minY = obj.minY or 0;
    obj.maxX = obj.maxX or 1;
    obj.maxY = obj.maxY or 1;

    setmetatable(obj, MotionConstraint_mt)
    
    return obj;
end

function MotionConstraint.tryChange(self, subject, change)
    --print("tryChange: ", change.dx, change.dy)
    local x = constrain(subject.x+change.dx, self.minX, self.maxX)
    local y = constrain(subject.y+change.dy, self.minY, self.maxY)
    --print("tryChange, 2.0: ", x, y)

    local dx = x - subject.x;
    local dy = y - subject.y;

    return {dx = dx,dy = dy}
end


--[[
    Basic slider class
]]
local thumbWidth = 40
local halfThumbWidth = thumbWidth/2

local thumbHeight = 18
local halfThumbHeight = thumbHeight/2
local thumbRadius = 4;

local trackThickness = 4


local Slider = {}
setmetatable(Slider, {
    __index = GraphicGroup;
})
local Slider_mt = {
    __index = Slider;
}

function Slider.new(self, obj)
    obj = GraphicGroup:new(obj)

    local yMidline = obj.frame.height/2

    obj.bgColor = obj.bgColor or color(0xC0, 0xC0, 0xff)
    obj.lowValue = obj.lowValue or 0
    obj.highValue = obj.highValue or 255
    obj.position = obj.position or 0
    obj.dragging = false;
    obj.midline = yMidline;
    obj.lastPosition = {x = halfThumbWidth, y = yMidline};
    obj.thumbRect = BLRoundRect(0,yMidline-halfThumbHeight,thumbWidth,thumbHeight,thumbRadius, thumbRadius)
    obj.constraint = MotionConstraint:new({
        minX = 0, maxX = obj.frame.width-thumbWidth,
        minY = obj.thumbRect.y, maxY = obj.thumbRect.y})

    setmetatable(obj,Slider_mt)

    obj:setPosition(obj.position)

    return obj
end

function Slider.draw(self, ctx)
    -- draw horizontal line mid height
    ctx:strokeWidth(trackThickness)
    ctx:stroke(120)
    ctx:line(halfThumbWidth,self.midline, self.frame.width-halfThumbWidth, self.midline)

---[[
    -- draw a couple of circles at the ends
    ctx:noStroke()
    ctx:fill(10)
    ctx:circle(halfThumbWidth, self.midline, trackThickness/2+2)
    ctx:circle(self.frame.width-halfThumbWidth, self.frame.height/2, 3)
--]]

    -- draw the thumb
    -- a lozinger rounded rect

    ctx:fill(self.bgColor)
    ctx:fillRoundRect(self.thumbRect)
end

--[[
    Returns a number in range  [0..1]
]]
function Slider.getPosition(self)
    return map(self.thumbRect.x, self.constraint.minX, self.constraint.maxX, 0, 1)
end

function Slider.setPosition(self, pos)
    self.thumbRect.x = map(pos, 0,1, self.constraint.minX, self.constraint.maxX)
end

function Slider.getValue(self)
    return map(self:getPosition(), 0, 1, self.lowValue, self.highValue);
end

function Slider.changeThumbPosition(self, change)
    local movement = self.constraint:tryChange(self.thumbRect, change)
--print("movement: ", movement.dx, movement.dy)

    self.thumbRect.x = self.thumbRect.x + movement.dx;
    self.thumbRect.y = self.thumbRect.y + movement.dy
    
    -- tell anyone who's interested that something has changed
    signalAll(self, self, "changeposition")
end

function Slider.mouseDown(self, event)
    self.dragging = true;
    self.lastPosition = {x=event.x, y=event.y};
    -- local change = {dx = centrx - event.x, dy = centery.event.y}
    --self:changeThumbPosition({dy=0,dx=0})
    --self:setThumbPosition()
end

function Slider.mouseUp(self, event)
    self.dragging = false;
end

function Slider.mouseMove(self, event)
    --print("Slider.mouseMove: ", event.x, event.y, self.dragging)
    local change = {
        dy = event.y - self.lastPosition.y;
        dx = event.x - self.lastPosition.x;    
    }
    if self.dragging then 
        self:changeThumbPosition(change)
    end
    self.lastPosition = {x = event.x, y = event.y}
end

return Slider
