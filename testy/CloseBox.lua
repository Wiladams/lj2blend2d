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
    setmetatable(obj, CloseBox_mt)

    return obj
end

function CloseBox.mouseUp(self, event)
    print("CloseBox.mouseUp")
end

function CloseBox.draw(self, ctx)
    ctx:stroke(0)
    ctx:strokeWidth(1)
    ctx:fill(0xff, 0,0)
    ctx:rect(self.frame.x, self.frame.y, self.frame.width, self.frame.height)

    return self;
end

return CloseBox
