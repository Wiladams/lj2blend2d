package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 


local b2d = require("blend2d.blend2d")

local function main(int argc, char* argv[])
  BLImage img(480, 480, C.BL_FORMAT_PRGB32);

  -- Attach a rendering context into `img`.
  local ctx = BLContext(img);

  -- Clear the image.
  ctx.setCompOp(C.BL_COMP_OP_SRC_COPY);
  ctx.fillAll();

  -- Fill some path.
  local path = BLPath();
  path:moveTo(26, 31);
  path:cubicTo(642, 132, 587, -136, 25, 464);
  path:cubicTo(882, 404, 144, 267, 27, 31);

  ctx:setCompOp(C.BL_COMP_OP_SRC_OVER);
  ctx:setFillStyle(BLRgba32(0xFFFFFFFF));
  ctx:fillPath(path);

  -- Detach the rendering context from `img`.
  ctx.finish();

  -- Lets use some built-in codecs provided by Blend2D.
  local codec = BLImageCodec();
  codec:findByName(b2d.blImageCodecBuiltInCodecs(), "BMP");
  img:writeToFile("bl-getting-started-1.bmp", codec);

end

main()
