local GraphicGroup = require("GraphicGroup")
local maths = require("maths")

local map = maths.map

local thumbWidth = 12
local thumbHeight = 18
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
    obj.lowValue = obj.lowValue or 0
    obj.highValue = obj.highValue or 255
    obj.position = obj.position or 0
    obj.dragging = false;
    obj.thumbRect = BLRoundRect(-thumbWidth/2,obj.frame.height/2-thumbHeight/2,thumbWidth,thumbHeight,2,2)

    setmetatable(obj,Slider_mt)

    return obj
end

function Slider.draw(self, ctx)
    -- draw horizontal line mid height
    ctx:strokeWidth(trackThickness)
    ctx:stroke(120)
    ctx:line(0,self.frame.height/2, self.frame.width, self.frame.height/2)

    -- draw a couple of circles at the ends
    ctx:noStroke()
    ctx:fill(10)
    ctx:circle(3, self.frame.height/2, 3)
    ctx:circle(self.frame.width-3, self.frame.height/2, 3)

    -- draw the thumb
    -- a lozinger rounded rect
    ctx:fill(0xC0, 0xC0, 0xff)
    ctx:fillRoundRect(self.thumbRect)

    
end

function Slider.calcThumbPosition(self, x, y)
    return map(x, 0, self.frame.width, 0, self.frame.width-thumbWidth)
end

function Slider.changeThumbPosition(self, x, y)
    self.thumbRect.x = self:calcThumbPosition(event.x, event.y)
    
    -- tell anyone who's interested that something has changed
    signalAll(self, self)
end

function Slider.mouseDown(self, event)
    self.dragging = true;
    self:changeThumbPosition(event.x, event.y)
end

function Slider.mouseUp(self, event)
    self.dragging = false;
end

function Slider.mouseMove(self, event)
    --print("Slider.mouseMove: ", event.x, event.y, self.dragging)
    if self.dragging then 
        self:changeThumbPosition(event.x, event.y)
    end
end

return Slider
