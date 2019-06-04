local ffi = require("ffi")
local C = ffi.C 

local FontMonger = require("FontMonger")
local GraphicGroup = require("GraphicGroup")
local Gradient = require("Gradient")


local GFontFaceIcon = {}
---[[
setmetatable(GFontFaceIcon, {
    __index = GraphicGroup
})
--]]
local GFontFaceIcon_mt = {
    __index = GFontFaceIcon;
}

function GFontFaceIcon.getPreferredSize()
    return {width = 150, height = 160};
end

function GFontFaceIcon.new(self, obj)
    local size = GFontFaceIcon:getPreferredSize()

    local obj = GraphicGroup:new(obj)

    obj.fontMonger = obj.fontMonger or FontMonger:new()
    obj.frame = {x=0,y=0,width = size.width, height = size.height}
    obj.gradient = Gradient.LinearGradient({
        values = {obj.frame.width/4, 0, obj.frame.width/2, obj.frame.height};
        stops = {
            {offset = 0.0, uint32 = 0xFFf0f0f0},
            {offset = 1.0, uint32 = 0xFFb0bcb0},
        }
      });


    setmetatable(obj, GFontFaceIcon_mt)

    return obj;
end


--[[
    Mouse Action
]]
function GFontFaceIcon.mouseExit(self, event)
    --print("GFontFaceIcon.mouseExit:")
    self.isHovering = false;
end

function GFontFaceIcon.mouseMove(self, event)
    --print("GFontFaceIcon.mousemove: ", event.x, event.y, event.subactivity)

    if event.subactivity == "mousehover" then
        self.isHovering = true
    end
end
--[[
function GFontFaceIcon.mouseEvent(self, event)
    print("GFontFaceIcon.mouseEvent: ", event.activity, event.subactivity)
end
--]]

function GFontFaceIcon.drawPlaccard(self, ctx)
    -- first draw white backround for whole cell
    -- when hovering
    if self.isHovering then
        --print("DRAW HOVER")
        ctx:stroke(0xC0)
        ctx:strokeWidth(1)
        ctx:fill(0x00, 0xff, 0xff, 0x7f)
        ctx:rect(0, 0, self.frame.width, self.frame.height)
    end

    -- now draw a sub-rectangle to show the font style
    ctx:strokeWidth(1)
    ctx:stroke(30)
    ctx:strokeJoin(C.BL_STROKE_JOIN_ROUND)
    --ctx:fill(210)
    ctx:setFillStyle(self.gradient)

    local p = BLPath()
    p:moveTo(0,0)
    p:lineTo(self.frame.width - 30, 0)
    p:quadTo(self.frame.width-20,0, self.frame.width-20, 20)

    p:quadTo(self.frame.width,20, self.frame.width, 30)
    --p:lineTo(self.frame.width, 20)
    p:lineTo(self.frame.width, 100)
    p:lineTo(0, 100)
    p:close()
    ctx:fillPath(p)
    ctx:strokePath(p)

    -- make a little triangle tab
    local p2 = BLPath()
    ctx:stroke(30)
    ctx:fill(160)   -- should be gradient
    p2:moveTo(self.frame.width-30,0)
    p2:lineTo(self.frame.width,30)
    --p2:lineTo(self.frame.width-20, 20)
    --p2:close()
    --ctx:fillPath(p2)
    ctx:strokePath(p2)
end

function GFontFaceIcon.drawSampleText(self, ctx)
    -- draw a little bit of text on the background
    ctx:textAlign(MIDDLE, BASELINE)
    ctx:textFont(self.familyName);
    ctx:textSize(32)
    ctx:stroke(0)
    ctx:fill(0)
    ctx:text("Abg", self.frame.width/2, 68)
end

function GFontFaceIcon.drawName(self, ctx)
    local face = ctx.FontFace
    ctx:textAlign(MIDDLE, BASELINE)
    ctx:textFont("segoe ui")
    ctx:textSize(10)
    ctx:text(face.info.fullName, self.frame.width/2, 140)
    --print("face: ", face.info.fullName, face.info.subFamilyName)
end

function GFontFaceIcon.drawBackground(self, ctx)
    self:drawPlaccard(ctx)
    self:drawSampleText(ctx)
    self:drawName(ctx)
end

function GFontFaceIcon.draw(self, ctx)
    self:drawBackground(ctx)
end

return GFontFaceIcon