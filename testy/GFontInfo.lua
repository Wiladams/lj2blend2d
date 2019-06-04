-- Display information about a specified font
local Gradient = require("Gradient")


local maths = require("maths")
local map = maths.map

local fontDir = "c:\\windows\\fonts\\"

local GFontInfo = {}
local GFontInfo_mt = {
    __index = GFontInfo
}

function GFontInfo.new(self, obj)

    local obj = obj or {}
    obj.frame = obj.frame or {x=0,y=0,width=320,height=240}

    obj.FontFace = BLFontFace:createFromFile(fontDir.."consola.ttf")
    obj.Font = obj.FontFace:createFont(96)

    obj.gradient = Gradient.LinearGradient({
        values = {obj.frame.widht/2, 0, obj.frame/2, obj.frame.height};
        stops = {
            {offset = 0.0, uint32 = 0xFF4f4f4f},
            {offset = 1.0, uint32 = 0xFF9f9f9f},
        }
      });

    setmetatable(obj, GFontInfo_mt)

    local dmetrics = obj.FontFace:designMetrics()
    print("== font face ==")
    print("full name: ", obj.FontFace:fullName())
    print("family name: ", obj.FontFace:familyName())
    print("style: ", obj.FontFace:style());
    print("stretch: ", obj.FontFace:stretch());
    print("weight: ", obj.FontFace:weight());

    print("== dmetrics ==")
    print("unitsPerEm: ", dmetrics.unitsPerEm);
    print("   lineGap: ", dmetrics.lineGap);
    print("   xHeight: ", dmetrics.xHeight);
    print(" capHeight: ", dmetrics.capHeight);
    print("    ascent: ", dmetrics.ascent);
    print("   descent: ", dmetrics.descent);

    return obj;
end

function GFontInfo.draw(self, ctx)
    ctx:save()
    ctx:translate(20,20)

    ctx:stroke(0)
    ctx:strokeWidth(1)
    ctx:noFill();

    ctx:rect(0,0,640,480)

    local dmetrics = self.FontFace:designMetrics()
    local fullHeight = dmetrics.lineGap+dmetrics.descent+dmetrics.ascent

    local linegap = 470
    local baseline = map(dmetrics.lineGap+dmetrics.descent, 0,fullHeight, 470, 10)
    local descent = map(dmetrics.lineGap, 0,fullHeight, 470,10)
    local ascent = map(dmetrics.lineGap+dmetrics.descent+dmetrics.ascent, 0, fullHeight, 470,10)
    
    --print("baseline: ", baseline)
    --print("descent: ", descent)
    --print("ascent: ", ascent)

    -- baseline
    ctx:stroke(0xff,0, 0)
    ctx:line(10, baseline, 620,baseline)

    -- descent
    ctx:stroke(0,0,0xff)
    ctx:line(10, descent, 620, descent)

    -- ascent
    ctx:line(10, ascent, 620, ascent)

    -- line gap
    ctx:stroke(0,255,0)
    ctx:line(10, linegap, 620, linegap)

    ctx:restore()
end

return GFontInfo
