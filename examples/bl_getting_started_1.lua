

local ffi = require("ffi")
local C = ffi.C 


local b2d = require("blend2d.b2d")

local function main()
  local img = BLImage(480, 480)
  local ctx, err = BLContext(img)

  -- Clear the image.
  ctx:setCompOp(C.BL_COMP_OP_SRC_COPY);
  ctx:fillAll();

  -- Fill some path.
  local path = BLPath();
  path:moveTo(26, 31);
  path:cubicTo(642, 132, 587, -136, 25, 464);
  path:cubicTo(882, 404, 144, 267, 27, 31);


  ctx:setCompOp(C.BL_COMP_OP_SRC_OVER);
  ctx:setFillStyle(BLRgba32(0xFFFFFFFF));
  ctx:fillPathD(path);

  -- Detach the rendering context from `img`.
  ctx:finish();


  BLImageCodec("BMP"):writeImageToFile(img, "output/bl-getting-started-1.bmp")
end

main()
