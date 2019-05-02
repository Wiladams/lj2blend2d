package.path = "../?.lua;"..package.path;


--local b2d = require("blend2d.blend2d")
local DrawingContext = require("DrawingContext")
DrawingContext:exportConstants()
local Gradient = require("Gradient")


local function main()

  local ctx = DrawingContext:new({width=480, height=480})

  ctx:setCompOp(BL_COMP_OP_SRC_COPY);
  ctx:fillAll();

  local linear = Gradient.LinearGradient({
    values = {0, 0, 0, 480};
    stops = {
      {offset = 0, uint32 = 0xFFFFFFFF},
      {offset = 1, uint32 = 0xFF1F7FFF}
    }
  });
  
  local path = BLPath();
  path:moveTo(119, 49);
  path:cubicTo(259, 29, 99, 279, 275, 267);
  path:cubicTo(537, 245, 300, -170, 274, 430);

  ctx:setCompOp(BL_COMP_OP_SRC_OVER);

  ctx:stroke(linear);
  ctx:strokeWidth(15);
  ctx:strokeStartCap(BL_STROKE_CAP_ROUND);
  ctx:strokeEndCap(BL_STROKE_CAP_TRIANGLE);
  ctx:noFill()
  ctx:strokePath(path);


  BLImageCodec("BMP"):writeImageToFile(ctx:getReadyBuffer(), "output/bl-getting-started-6.bmp")
end

main()
