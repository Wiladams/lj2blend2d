

local ffi = require("ffi")
local C = ffi.C 

local blapi = require("blend2d.blend2d")

local Gradient = require("Gradient")
local LinearGradient, RadialGradient = Gradient.LinearGradient, Gradient.RadialGradient


local function main()
  local img = BLImage(480, 480);
  local ctx = BLContext(img);

  ctx:setCompOp(C.BL_COMP_OP_SRC_COPY);
  ctx:fillAll();

--[[
  local values = BLRadialGradientValues({ 180, 180, 180, 180, 180 });
  print("radialgradientvalues: ", values.x0,values.y0,values.x1,values.y1, values.r0)
  local radial = BLGradient(C.BL_GRADIENT_TYPE_RADIAL, values, C.BL_EXTEND_MODE_PAD, nil, 0, nil);
  radial:addStopRgba32(0.0, 0xFFFFFFFF);
  radial:addStopRgba32(0.5, 0xFFFF6F3F);
--]]

  -- First shape filld by a radial gradient.
  local radial = ffi.new("struct BLGradientCore")
--[[
  blapi.blGradientInit(radial)


  blapi.blGradientSetType(radial, C.BL_GRADIENT_TYPE_RADIAL)
  blapi.blGradientSetExtendMode(radial, C.BL_EXTEND_MODE_PAD)

-- Add values
  blapi.blGradientSetValue(radial, 0, 180) 
  blapi.blGradientSetValue(radial, 1, 180) 
  blapi.blGradientSetValue(radial, 2, 180) 
  blapi.blGradientSetValue(radial, 3, 180) 
  blapi.blGradientSetValue(radial, 4, 180) 

 
  -- Add stops
  print(blapi.blGradientAddStopRgba32(radial, 0, 0xFFFFFFFF))
  print(blapi.blGradientAddStopRgba32(radial, 0.5, 0xFFFF6F3F))



  ctx:setCompOp(C.BL_COMP_OP_SRC_OVER);
  --ctx:setFillStyle(radial);
  print("blContextSetFillStyle: ", blapi.blContextSetFillStyle(ctx, radial))


  local circle = BLCircle();
  circle.cx = 180;
  circle.cy = 180;
  circle.r = 160;
 
  ctx:fillGeometry(C.BL_GEOMETRY_TYPE_CIRCLE, circle)



 
 ctx:fillCircle(180,180,160)


  --ctx:fillCircle(180, 180, 160);

  -- Second shape filled by a linear gradient.
  local linear = LinearGradient({values = {195, 195, 470, 470},
    stops = {
      {offset = 0.0, uint32 = 0xFFFFFFFF},
      {offset = 1.0, uint32 = 0xFF3F9FFF}
    }
  })

  ctx:setCompOp(C.BL_COMP_OP_DIFFERENCE);
  ctx:setFillStyle(linear);
  ctx:fillRoundRect(BLRoundRect(195, 195, 270, 270, 25));
--]]
  ctx:finish();


  BLImageCodec("BMP"):writeImageToFile(img, "output/bl-getting-started-5.bmp")
end

main()
