local ffi = require("ffi")
local C = ffi.C 

local FontMonger = require("FontMonger")

local GFontFaceIcon = {}
local GFontFaceIcon_mt = {
    __index = GFontFaceIcon;
}

function GFontFaceIcon.getPreferredSize()
    return {width = 150, height = 160};
end

function GFontFaceIcon.new(self, obj)
    local size = GFontFaceIcon:getPreferredSize()

    local obj = obj or {}

    obj.fontMonger = obj.fontMonger or FontMonger:new()
    obj.frame = obj.frame or {x=0,y=0,width = size.width, height = size.height}
    
    setmetatable(obj, GFontFaceIcon_mt)

    return obj;
end

function GFontFaceIcon.drawBackground(self, ctx)
    -- first draw white backround for whole cell
    --ctx:stroke(0xC0)
    --ctx:strokeWidth(1)
    --ctx:fill(255)
    --ctx:rect(self.frame.x, self.frame.y, self.frame.width, self.frame.height)

    -- now draw a sub-rectangle to show the font style
    ctx:stroke(30)
    ctx:strokeJoin(C.BL_STROKE_JOIN_ROUND)
    ctx:fill(210)

    local p = BLPath()
    p:moveTo(0,0)
    p:lineTo(self.frame.width - 20, 0)
    --p:lineTo(self.frame.width-20, 20)
    p:lineTo(self.frame.width, 20)
    p:lineTo(self.frame.width, 100)
    p:lineTo(0, 100)
    p:close()
    ctx:fillPath(p)

    -- make a little triangle tab
    local p2 = BLPath()
    ctx:stroke(30)
    ctx:fill(160)   -- should be gradient
    p2:moveTo(self.frame.width-20,0)
    p2:lineTo(self.frame.width,20)
    p2:lineTo(self.frame.width-20, 20)
    p2:close()
    ctx:fillPath(p2)

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

function GFontFaceIcon.draw(self, ctx)
    self:drawBackground(ctx)
    self:drawSampleText(ctx)
    self:drawName(ctx)
end


return GFontFaceIcon