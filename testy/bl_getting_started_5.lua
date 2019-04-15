package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 


local b2d = require("blend2d.blend2d")
local function main()
  local img = BLImage(480, 480, C.BL_FORMAT_PRGB32);
  local ctx = BLContext(img);

  ctx:setCompOp(C.BL_COMP_OP_SRC_COPY);
  ctx:fillAll();


  -- First shape filld by a radial gradient.
  local radial = BLGradient(BLRadialGradientValues(180, 180, 180, 180, 180));
  radial:addStop(0.0, BLRgba32(0xFFFFFFFF));
  radial:addStop(1.0, BLRgba32(0xFFFF6F3F));

  ctx:setCompOp(C.BL_COMP_OP_SRC_OVER);
  ctx:setFillStyle(radial);
  ctx:fillCircle(180, 180, 160);

  -- Second shape filled by a linear gradient.
  local linear = BLGradient(BLLinearGradientValues(195, 195, 470, 470));
  linear:addStop(0.0, BLRgba32(0xFFFFFFFF));
  linear:addStop(1.0, BLRgba32(0xFF3F9FFF));

  ctx:setCompOp(C.BL_COMP_OP_DIFFERENCE);
  ctx:setFillStyle(linear);
  ctx:fillRoundRect(195, 195, 270, 270, 25);

  ctx:finish();


  img:writeToFile("output/bl-getting-started-5.bmp", BLImageCodec:findByName("BMP"));
end

main()
