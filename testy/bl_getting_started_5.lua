package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 

local b2d = require("blend2d.blend2d")

local Gradient = require("Gradient")
local LinearGradient, RadialGradient = Gradient.LinearGradient, Gradient.RadialGradient


local function main()
  local img = BLImage(480, 480);
  local ctx = BLContext(img);

  ctx:setCompOp(C.BL_COMP_OP_SRC_COPY);
  ctx:fillAll();


  -- First shape filld by a radial gradient.
  local radial = RadialGradient({values = {180, 180, 180, 180, 180},
    stops = {
      {offset = 0.0, uint32 = 0xFFFFFFFF},
      {offset = 1.0, uint32 = 0xFFFF6F3F}
    }
  })


  ctx:setCompOp(C.BL_COMP_OP_SRC_OVER);
  ctx:setFillStyle(radial);
  ctx:fillCircle(180, 180, 160);

  -- Second shape filled by a linear gradient.
  local linear = LinearGradient({values = {195, 195, 470, 470},
    stops = {
      {offset = 0.0, uint32 = 0xFFFFFFFF},
      {offset = 1.0, uint32 = 0xFF3F9FFF}
    }
  })

  ctx:setCompOp(C.BL_COMP_OP_DIFFERENCE);
  ctx:setFillStyle(linear);
  ctx:fillRoundRect(195, 195, 270, 270, 25);

  ctx:finish();


  BLImageCodec("BMP"):writeImageToFile(img, "output/bl-getting-started-5.bmp")
end

main()
