local FontMonger = require("FontMonger")

local GFontFaceIcon = {}
local GFontFaceIcon_mt = {
    __index = GFontFaceIcon;
}

function GFontFaceIcon.getPreferredSize()
    return {width = 160, height = 160};
end

function GFontFaceIcon.new(self, params)
    local size = GFontFaceIcon:getPreferredSize()

    local obj = obj or {}

    --obj.familyName = obj.familyName or "chiller"
    --obj.familyName = obj.familyName or "mistral"
    --obj.familyName = obj.familyName or "showcard gothic"
    --obj.familyName = obj.familyName or "mongolian baiti"
    --obj.familyName = obj.familyName or "pristina"
    --obj.familyName = obj.familyName or "courier"
    obj.familyName = obj.familyName or "jokerman"
    --obj.familyName = obj.familyName or "script MT bold"
    --obj.subfamilyName = "regular"
    
    obj.fontMonger = obj.fontMonger or FontMonger:new()
    obj.frame = obj.frame or {x=0,y=0,width = size.width, height = size.height}
    
    setmetatable(obj, GFontFaceIcon_mt)

    return obj;
end

function GFontFaceIcon.drawBackground(self, ctx)
    -- first draw white backround for whole cell
    ctx:stroke(0xC0)
    ctx:strokeWidth(1)
    ctx:fill(255)
    --ctx:rect(self.frame.x, self.frame.y, self.frame.width, self.frame.height)

    -- now draw a sub-rectangle to show the font style
    ctx:stroke(0x00)
    ctx:fill(210)
    ctx:rect(2,2, self.frame.width-4, 100)
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

function GFontFaceIcon.draw(self, ctx)
    self:drawBackground(ctx)
    self:drawSampleText(ctx)


    local face = ctx.FontFace
    ctx:textAlign(MIDDLE, BASELINE)
    ctx:textFont("segoe ui")
    ctx:textSize(10)
    ctx:text(face.info.fullName, self.frame.width/2, 140)
    --print("face: ", face.info.fullName, face.info.subFamilyName)
end


return GFontFaceIcon