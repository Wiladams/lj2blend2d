package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 


local b2d = require("blend2d.blend2d")

local function main()
  local img = BLImageCore(480, 480, C.BL_FORMAT_PRGB32);

  -- Attach a rendering context into `img`.
  local ctx, err = BLContextCore(img);
print("BLContextCore: ", ctx, err)

  -- Clear the image.
  print("ctx:setCompOp: ", ctx:setCompOp(C.BL_COMP_OP_SRC_COPY));
  print("ctx:fillAll: ", ctx:fillAll());

  print("PATH, BEGIN")
  -- Fill some path.
  local path = BLPathCore();
  path:moveTo(26, 31);
  path:cubicTo(642, 132, 587, -136, 25, 464);
  path:cubicTo(882, 404, 144, 267, 27, 31);
  print("PATH, END")

  print("ctx:setCompOp: ", ctx:setCompOp(C.BL_COMP_OP_SRC_OVER));
  --print("setFillStyle: ", ctx:setFillStyle(BLRgba32(0xFFFFFFFF)));
  print("setFillStyleRgba32: ", ctx:setFillStyleRgba32(BLRgba32(0xFFFFFFFF).value));
  print("fillPath: ", ctx:fillPath(path));

  -- Detach the rendering context from `img`.
  ctx:finish();

  -- Let's use some built-in codecs provided by Blend2D.
  local codec = BLImageCodecCore();
  b2d.blImageCodecFindByName(codec, b2d.blImageCodecBuiltInCodecs(), "BMP");
  img:writeToFile("bl-getting-started-1.bmp", codec);


end

main()
