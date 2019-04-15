package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 


local b2d = require("blend2d.blend2d")

local function main()
  local img = BLImage(480, 480, C.BL_FORMAT_PRGB32);

  -- Attach a rendering context into `img`.
  local ctx, err = BLContext(img);


  -- Clear the image.
  ctx:setCompOp(C.BL_COMP_OP_SRC_COPY);
  ctx:fillAll();


  -- Fill some path.
  local path = BLPathCore();
  path:moveTo(26, 31);
  path:cubicTo(642, 132, 587, -136, 25, 464);
  path:cubicTo(882, 404, 144, 267, 27, 31);


  ctx:setCompOp(C.BL_COMP_OP_SRC_OVER);
  ctx:setFillStyle(BLRgba32(0xFFFFFFFF));
  --ctx:setFillStyleRgba32(BLRgba32(0xFFFFFFFF).value);
  ctx:fillPath(path);

  -- Detach the rendering context from `img`.
  ctx:finish();

  img:writeToFile("output/bl-getting-started-1.bmp", BLImageCodec:findByName("BMP"));

end

main()
