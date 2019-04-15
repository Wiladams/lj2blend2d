package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 


local b2d = require("blend2d.blend2d")

local function main()
  local img = BLImage(480, 480, C.BL_FORMAT_PRGB32);
  local ctx = BLContext(img);

  ctx:setCompOp(C.BL_COMP_OP_SRC_COPY);
  ctx:fillAll();

  local linear = BLGradient(BLLinearGradientValues(0, 0, 0, 480));
  linear:addStop(0.0, BLRgba32(0xFFFFFFFF));
  linear:addStop(1.0, BLRgba32(0xFF1F7FFF));

  local path = BLPath();
  path:moveTo(119, 49);
  path:cubicTo(259, 29, 99, 279, 275, 267);
  path:cubicTo(537, 245, 300, -170, 274, 430);

  ctx:setCompOp(C.BL_COMP_OP_SRC_OVER);

  ctx:setStrokeStyle(linear);
  ctx:setStrokeWidth(15);
  ctx:setStrokeStartCap(C.BL_STROKE_CAP_ROUND);
  ctx:setStrokeEndCap(C.BL_STROKE_CAP_TRIANGLE);
  ctx:strokePath(path);


  ctx:finish();


  img:writeToFile("output/bl-getting-started-6.bmp", BLImageCodec:findByName("BMP"));
end

main()
