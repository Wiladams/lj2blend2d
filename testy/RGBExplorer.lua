local Slider = require("slider")
local GraphicGroup = require("GraphicGroup")
local functor = require("functor")
local CheckerGraphic = require("CheckerGraphic")


--[[
    This little graphic simply displays a square
    with a checkboard background, and the color
    overlayed atop that.  The checkboard pattern
    serves to display what the color looks like 
    with transparency.
]]
local ColorView = {}
local ColorView_mt = {
    __index = ColorView
}
function ColorView.new(self, obj)
    obj = obj or {
        frame = {x=0,y=0,width=100,height=100};
    }

    obj.value = obj.value or color(0,0,0,0)
    obj.background = obj.background or CheckerGraphic:new({
        color1 = 200,
        color2 = 172,
        frame = {x=0,y=0,width = obj.frame.width, height = obj.frame.height}
    })

    setmetatable(obj, ColorView_mt)

    return obj
end

function ColorView.setValue(self, value)
    self.value = value
end

function ColorView.draw(self, ctx)
    --print("colorview.draw: ", self.frame.width, self.frame.height, self.value.r, self.value.g, self.value.b, self.value.a)
    self.background:draw(ctx)

    -- now overlay the current color value atop the backgroud
    ctx:noStroke()
    ctx:fill(self.value)
    ctx:rect(0,0,self.frame.width, self.frame.height)

    -- lightly outline the color display area
    ctx:strokeWidth(0.5)
    ctx:stroke(0)
    ctx:noFill();
    ctx:rect(self.background.frame.x, self.background.frame.y, self.background.frame.width, self.background.frame.height)
end







local RGBExplorer = {}
setmetatable(RGBExplorer, {
    __index = GraphicGroup
})
local RGBExplorer_mt = {
    __index = RGBExplorer;
}

function RGBExplorer.getPreferredSize(self)
    return {width=320, height=260}
end

function RGBExplorer.new(self, obj)
    local size = RGBExplorer:getPreferredSize()

    obj = obj or {
        frame = {x=0, y=0, width = size.width, height=size.height};
    }
    
    --obj.bgColor = color(192)
    obj.bgColor = obj.bgColor or color(0xcf, 0xcd, 0xb1)

    obj = GraphicGroup:new(obj)

    -- create path to represent background
    local p = BLPath()
    p:moveTo(0,0)
    p:lineTo(60,0)
    p:lineTo(76,32)
    p:lineTo(320,32)
    p:lineTo(320,260)
    p:lineTo(0,260)
    p:close()
    obj.contour = p;
    obj.primaryColor = color(0,0,0,0)
    obj.colorViewer = ColorView:new({frame={x=20,y=150,width=100,height=100}})

    setmetatable(obj, RGBExplorer_mt)

    -- color component selectors
    obj.redSlider = Slider:new({title = "red", bgColor = color(0xff,0,0), position=0.5, frame={x=20, y=44, width=240, height=20}})
    obj.greenSlider = Slider:new({title = "green", bgColor = color(0,0xff,0), position=0.5, frame={x=20, y=68, width=240, height=20}})
    obj.blueSlider = Slider:new({title = "blue", bgColor = color(0,0,0xff), position=0.5, frame={x=20, y=92, width=240, height=20}})
    obj.alphaSlider = Slider:new({title = "alpha", bgColor = color(80,80,80), position=1.0, frame={x=20, y=116, width=240, height=20}})

    
    obj:add(obj.redSlider)
    obj:add(obj.greenSlider)
    obj:add(obj.blueSlider)
    obj:add(obj.alphaSlider)

    obj:add(obj.colorViewer)

    -- use signaling to know when individual components change value
    on(obj.redSlider, functor(obj.handleComponentChange, obj))
    on(obj.greenSlider, functor(obj.handleComponentChange, obj))
    on(obj.blueSlider, functor(obj.handleComponentChange, obj))
    on(obj.alphaSlider, functor(obj.handleComponentChange, obj))
    
    obj.colorViewer:setValue(obj:getSelectedColor())

    return obj
end

function RGBExplorer.getSelectedColor(self)
    local r = self.redSlider:getValue();
    local g = self.greenSlider:getValue();
    local b = self.blueSlider:getValue();
    local a = self.alphaSlider:getValue();

    return color(r,g,b,a), r, g, b, a
end

function RGBExplorer.handleComponentChange(self, comp, sig)
    --print(comp.title, sig)
    self.colorViewer:setValue(self:getSelectedColor())
end

function RGBExplorer.drawBackground(self, ctx)
    -- draw the contour
    ctx:fill(self.bgColor)
    ctx:stroke(30)
    ctx:strokeWidth(1)
    ctx:fillPath(self.contour)
    ctx:strokePath(self.contour)

    -- Draw Tab title
    ctx:fill(0)
    ctx:textSize(18)
    ctx:textAlign(MIDDLE, BASELINE)
    ctx:text("RGB", 30,32-4)

--[[
    -- draw outline of area
    ctx:stroke(0)
    ctx:noFill()
    ctx:strokeWidth(1)
    ctx:rect(0, 0, self.frame.width-1, self.frame.height-1)
--]]
end

function RGBExplorer.drawForeground(self, ctx)
    -- draw stuff that's not taken care of by child 
    -- graphics yet
    local c, r, g, b, a = self:getSelectedColor()

    ctx:textSize(14)
    ctx:textAlign(LEFT, BASELINE)
    -- Draw Web Color rep
    local webText = string.format("%-4s #%02X%02X%02X", "WEB", r, g, b)
    ctx:text(webText, 140, 200)

    local rgbaText = string.format("%-4s 0x%08X", "RGBA", c.value)
    ctx:text(rgbaText, 140, 220)
end


return RGBExplorer
