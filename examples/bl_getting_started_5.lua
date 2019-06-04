

local ffi = require("ffi")
local C = ffi.C 

local blapi = require("blend2d.blend2d")


local function main()
  local img = BLImage(480, 480);
  local ctx = BLContext(img);

  ctx:setCompOp(C.BL_COMP_OP_SRC_COPY);
  ctx:fillAll();

---[[
  local values = BLRadialGradientValues({ 180, 180, 180, 180, 180 });
  --print("radialgradientvalues: ", values.x0,values.y0,values.x1,values.y1, values.r0)
  local radial = BLGradient(C.BL_GRADIENT_TYPE_RADIAL, values, C.BL_EXTEND_MODE_PAD, nil, 0, nil);
  radial:addStopRgba32(0.0, 0xFFFFFFFF);
  radial:addStopRgba32(0.5, 0xFFFF6F3F);
--]]

  -- First shape filled by a radial gradient.
  ctx:setCompOp(C.BL_COMP_OP_SRC_OVER);
  ctx:setFillStyle(radial);
  ctx:fillCircle(BLCircle(180,180,160))


  -- Second shape filled by a linear gradient.
  local values = BLLinearGradientValues({195, 195, 470, 470})
  local linear = BLGradient(C.BL_GRADIENT_TYPE_LINEAR, values, C.BL_EXTEND_MODE_PAD, nil, 0, nil)
  linear:addStopRgba32(0.0, 0xFFFFFFFF);
  linear:addStopRgba32(1.0, 0xFF3F9FFF);

  ctx:setCompOp(C.BL_COMP_OP_DIFFERENCE);
  ctx:setFillStyle(linear);
  ctx:fillRoundRect(BLRoundRect(195, 195, 270, 270, 25,25));

  ctx:finish();


  BLImageCodec("BMP"):writeImageToFile(img, "output/bl-getting-started-5.bmp")
end

main()
