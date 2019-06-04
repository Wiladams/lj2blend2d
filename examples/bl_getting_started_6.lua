local ffi = require("ffi")
local C = ffi.C 


local blapi = require("blend2d.blend2d")

local function main()
  local img = BLImage(480, 480);
  local ctx = BLContext(img);

  ctx:setCompOp(C.BL_COMP_OP_SRC_COPY);
  ctx:fillAll();

  local values = BLLinearGradientValues(0, 0, 0, 480)
  local linear = BLGradient(values);
  linear:addStopRgba32(0, 0xFFFFFFFF);
  linear:addStopRgba32(1, 0xFF1F7FFF);
  
  local path = BLPath();
  path:moveTo(119, 49);
  path:cubicTo(259, 29, 99, 279, 275, 267);
  path:cubicTo(537, 245, 300, -170, 274, 430);

  ctx:setCompOp(C.BL_COMP_OP_SRC_OVER);

  ctx:setStrokeStyle(linear)
  ctx:setStrokeWidth(15);
  ctx:setStrokeStartCap(C.BL_STROKE_CAP_ROUND);
  ctx:setStrokeEndCap(C.BL_STROKE_CAP_TRIANGLE);
  ctx:strokePathD(path);

  BLImageCodec("BMP"):writeImageToFile(img, "output/bl-getting-started-6.bmp")
end

main()
