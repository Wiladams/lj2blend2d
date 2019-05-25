local GraphicGroup = require("GraphicGroup")

local CloseBox = {}
setmetatable(CloseBox, {
    __index = GraphicGroup;
})

local CloseBox_mt = {
    __index = CloseBox;
}

function CloseBox.new(self, obj)
    obj = obj or {frame={x=0,y=0,width=30, height=30}}
    obj.lastMouseTime = millis()

    setmetatable(obj, CloseBox_mt)

    return obj
end

function CloseBox.mouseUp(self, event)
    --print("CloseBox.mouseUp")
    signalAll(self, self)
end

function CloseBox.mouseMove(self, event)
    --print("CloseBox.mousemove: ", event.x, event.y)
    self.lastMouseTime = millis()

end

function CloseBox.draw(self, ctx)
    -- draw an X
    ctx:stroke(60)
    ctx:strokeWidth(4)
    ctx:line(4,4,self.frame.width-4, self.frame.height-4)
    ctx:line(self.frame.width-4, 4, 4, self.frame.height-4)
    -- check last time mouse was moved
    -- if it's been a while, don't draw
    -- the highlight
    -- maybe fade out over time
    if millis() - self.lastMouseTime < 500 then
        -- semi-transparent red
        ctx:noStroke()
        ctx:fill(0xff, 0,0, 0x7f)
        ctx:rect(0, 0, self.frame.width, self.frame.height)
    end

    return self;
end

return CloseBox
