--[[
    The 7 original 'getting-started' examples as independent graphic objects
]]

local Gradient = require("Gradient")

local GS1 = {}
GS1.__index = GS1;

function GS1.new(self, obj)
    obj = obj or {}
    obj.Frame = obj.Frame or {x=0, y=0, width = 480, height=480}

    obj.path = BLPathCore();
    obj.path:moveTo(26, 31);
    obj.path:cubicTo(642, 132, 587, -136, 25, 464);
    obj.path:cubicTo(882, 404, 144, 267, 27, 31);


    setmetatable(obj, GS1)
    return obj
end

function GS1.draw(self, ctx)
--[[
    local img = BLImage(480, 480)
    local ctx, err = BLContext(img)
  
    -- Clear the image.
    ctx:setCompOp(C.BL_COMP_OP_SRC_COPY);
    ctx:fillAll();
 --]] 
  
    -- Fill some path.
    ctx:setCompOp(BL_COMP_OP_SRC_OVER);
    ctx:setFillStyle(BLRgba32(0xFFFFFFFF));
    ctx:fillPath(self.path);    
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

return {
    GS1 = GS1;
    GS6 = GS6;
}
