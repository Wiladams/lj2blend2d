package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 


local b2d = require("blend2d.blend2d")

local function main()
  img = BLImage(480, 480, C.BL_FORMAT_PRGB32);
  ctx = BLContext(img);
  print("0.0")
  ctx:setCompOp(C.BL_COMP_OP_SRC_COPY);
  ctx:fillAll();


   -- Coordinates can be specified now or changed later.
  --local linear = BLGradient(BLLinearGradientValues(0, 0, 0, 480));
  local values = BLLinearGradientValues({ 0, 0, 0, 480 });
  local linear = BLGradientCore(C.BL_GRADIENT_TYPE_LINEAR, values, C.BL_EXTEND_MODE_PAD, nil, 0, nil);


   -- Color stops can be added in any order.
   print("1.0")
   linear:addStop(0.0, BLRgba32(0xFFFFFFFF).value);
   print("2.0")
   linear:addStop(0.5, BLRgba32(0xFF5FAFDF).value);
   print("3.0")
   linear:addStop(1.0, BLRgba32(0xFF2F5FDF).value);
   print("4.0")

   -- `setFillStyle()` can be used for both colors and styles.
  ctx:setFillStyle(linear);

  ctx:setCompOp(C.BL_COMP_OP_SRC_OVER);
  ctx:fillRoundRect(40.0, 40.0, 400.0, 400.0, 45.5);
  ctx:finish();

  local codec = BLImageCodec();
  b2d.blImageCodecFindByName(codec, b2d.blImageCodecBuiltInCodecs(), "BMP");
  img:writeToFile("bl-getting-started-2.bmp", codec);

end

main()