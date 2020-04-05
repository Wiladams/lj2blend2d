

local ffi = require("ffi")
local C = ffi.C 


local b2d = require("blend2d.b2d")

local function main()
  img = BLImage(480, 480);
  ctx = BLContext(img);

  ctx:setCompOp(C.BL_COMP_OP_SRC_COPY);
  ctx:fillAll();


   -- Coordinates can be specified now or changed later.
  --local linear = BLGradient(BLLinearGradientValues(0, 0, 0, 480));
  local values = BLLinearGradientValues({ 0, 0, 0, 480 });
  local linear = BLGradient(C.BL_GRADIENT_TYPE_LINEAR, values, C.BL_EXTEND_MODE_PAD, nil, 0, nil);


   -- Color stops can be added in any order.
   linear:addStop(0.0, BLRgba32(0xFFFFFFFF));
   linear:addStop(0.5, BLRgba32(0xFF5FAFDF));
   linear:addStop(1.0, BLRgba32(0xFF2F5FDF));


   -- `setFillStyle()` can be used for both colors and styles.
  ctx:setFillStyle(linear);

  ctx:setCompOp(C.BL_COMP_OP_SRC_OVER);
  ctx:fillRoundRect(BLRoundRect(40.0, 40.0, 400.0, 400.0, 45.5, 45.5));
  ctx:finish();


  BLImageCodec("BMP"):writeImageToFile(img, "output/bl-getting-started-2.bmp")

end

main()