--[[
    The 7 original 'getting-started' examples as independent graphic objects
]]

local Gradient = require("Gradient")
local LinearGradient, RadialGradient = Gradient.LinearGradient, Gradient.RadialGradient


--[[
    Getting started sample 1
]]
local GS1 = {}
GS1.__index = GS1;

function GS1.new(self, obj)
    obj = obj or {}
    obj.Frame = obj.Frame or {x=0, y=0, width = 480, height=480}

    obj.path = BLPath();
    obj.path:moveTo(26, 31);
    obj.path:cubicTo(642, 132, 587, -136, 25, 464);
    obj.path:cubicTo(882, 404, 144, 267, 27, 31);


    setmetatable(obj, GS1)
    return obj
end

function GS1.draw(self, ctx)
    -- Fill some path.
    ctx:setCompOp(BL_COMP_OP_SRC_OVER);
    ctx:setFillStyle(BLRgba32(0xFFFFFFFF));
    ctx:fillPath(self.path);    
end

--[[
    Getting Started example 2
]]
local GS2= {}
GS2.__index = GS2

function GS2.new(self, ...)
    local obj = {}
    obj.linear = Gradient.LinearGradient({
        values = { 0, 0, 0, 480 };
        stops = {
            {offset = 0.0, uint32 = 0xFFFFFFFF};
            {offset = 0.5, uint32 = 0xFF5FAFDF};
            {offset = 1.0, uint32 = 0xFF2F5FDF}
        }
    })
    setmetatable(obj, GS2)

    return obj;
end

function GS2.draw(self, ctx)  
     -- `setFillStyle()` can be used for both colors and styles.
    ctx:setFillStyle(self.linear);
  
    ctx:setCompOp(BL_COMP_OP_SRC_OVER);
    ctx:fillRoundRect(40.0, 40.0, 400.0, 400.0, 45.5);  
  end

--[[
    Getting Started Example 3
]]
local GS3 = {}
GS3.__index = GS3

function GS3.new(self, obj)
    obj = obj or {}
    obj.texture, err = BLImageCodec:readImageFromFile("resources/texture.jpeg")

    setmetatable(obj, GS3)
    return obj
end

function GS3.draw(self, ctx)
     -- Create a pattern and use it to fill a rounded-rect.
    local pattern = BLPattern(self.texture);
  
  
    ctx:setCompOp(BL_COMP_OP_SRC_OVER);
    ctx:setFillStyle(pattern);
    ctx:fillRoundRect(40.0, 40.0, 400.0, 400.0, 45.5);
end

--[[
    Getting Started Example 4
]]
local GS4 = {}
GS4.__index = GS4;

function GS4.new(self, obj)
    obj = obj or {
        width = 480;
        height = 480;
    }
    obj.texture, err = BLImageCodec:readImageFromFile("resources/texture.jpeg")
    obj.pattern = BLPattern(obj.texture)

    setmetatable(obj, GS4)
    return obj;
end

function GS4.draw(self, ctx)
    --ctx:push()
    -- Rotate by 45 degrees about a point at [240, 240].
    ctx:rotate(0.785398, self.width/2, self.height/2);
  
    -- Create a pattern.
    ctx:setCompOp(BL_COMP_OP_SRC_OVER);
    ctx:setFillStyle(self.pattern);
    ctx:fillRoundRect(50.0, 50.0, 380.0, 380.0, 80.5);
    --ctx:pop()
end

--[[
    Getting Started Example 5
]]
local GS5 = {}
GS5.__index = GS5

function GS5.new(self, obj)
    obj = obj or {

    }
    obj.radial = obj.radial or RadialGradient({values = {180, 180, 180, 180, 180},
      stops = {
        {offset = 0.0, uint32 = 0xFFFFFFFF},
        {offset = 1.0, uint32 = 0xFFFF6F3F}
      }
    })

    obj.linear = obj.linear or LinearGradient({values = {195, 195, 470, 470},
        stops = {
            {offset = 0.0, uint32 = 0xFFFFFFFF},
            {offset = 1.0, uint32 = 0xFF3F9FFF}
        }
    })


    setmetatable(obj, GS5)
    return obj;
end

function GS5.draw(self, ctx)
  
    -- First shape filld by a radial gradient.
    ctx:setCompOp(BL_COMP_OP_SRC_OVER);
    ctx:setFillStyle(self.radial);
    ctx:fillCircle(180, 180, 160);
  
    -- Second shape filled by a linear gradient.
    ctx:setCompOp(BL_COMP_OP_DIFFERENCE);
    ctx:setFillStyle(self.linear);
    ctx:fillRoundRect(195, 195, 270, 270, 25);
end

--[[
    Getting Started Example 6 as an independent graphic
]]
local GS6 = {}
local GS6_mt = {
    __index = GS6;
}

function GS6.new(self, obj)
    local obj = obj or {}
    
    obj.x = obj.x or 0
    obj.y = obj.y or 0
    obj.width = obj.width or 480
    obj.height = obj.height or 480

    obj.linear = Gradient.LinearGradient({
        values = {0, 0, 0, 480};
        stops = {
          {offset = 0, uint32 = 0xFFFFFFFF},
          {offset = 1, uint32 = 0xFF1F7FFF}
        }
      });

    obj.path = BLPath();
    obj.path:moveTo(119, 49);
    obj.path:cubicTo(259, 29, 99, 279, 275, 267);
    obj.path:cubicTo(537, 245, 300, -170, 274, 430);
    
    setmetatable(obj, GS6_mt)
    
    return obj
end

function GS6.draw(self, ctx)
    ctx:push()
    ctx:translate(self.x, self.y)

    ctx:setCompOp(BL_COMP_OP_SRC_OVER);

    ctx:stroke(self.linear);
    ctx:strokeWidth(15);
    ctx:strokeStartCap(BL_STROKE_CAP_ROUND);
    ctx:strokeEndCap(BL_STROKE_CAP_TRIANGLE);
    ctx:noFill()
    ctx:strokePath(self.path);

    ctx:pop()
end

--[[
    Getting Started Example 7
]]
local GS7 = {}
GS7.__index = GS7

function GS7.new(self, obj)
    obj = obj or {

    }
    obj.face = obj.face or BLFontFace:createFromFile("resources/NotoSans-Regular.ttf");
    obj.font = obj.face:createFont(50.0)

    setmetatable(obj, GS7)
    return obj;
end

function GS7.draw(self, ctx) 
    ctx:setFillStyle(BLRgba32(0xFFFFFFFF));
    ctx:fillUtf8Text(BLPoint(60, 80), self.font, "Hello Blend2D!", 14);
  
    ctx:rotate(0.785398);
    ctx:fillUtf8Text(BLPoint(250, 80), self.font, "Rotated Text", 12);
end


local exports = {
    GS1 = GS1;
    GS2 = GS2;
    GS3 = GS3;
    GS4 = GS4;
    GS5 = GS5;
    GS6 = GS6;
    GS7 = GS7;
}

return exports
