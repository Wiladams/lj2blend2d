package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 


local b2d = require("blend2d.blend2d")

local function main() 
  local img = BLImage(480, 480, C.BL_FORMAT_PRGB32);
  local ctx = BLContext(img);

  ctx:setCompOp(C.BL_COMP_OP_SRC_COPY);
  ctx:fillAll();

  local face, err = BLFontFace();
  local success, err = face:createFromFile("NotoSans-Regular.ttf");

  -- We must handle a possible error returned by the loader.
  if (not success) then
    print("Failed to load a font-face: ", err);
    return false;
  end


  local font = BLFont();
  font:createFromFace(face, 50.0);

  ctx:setFillStyle(BLRgba32(0xFFFFFFFF));
  ctx:fillUtf8Text(BLPoint(60, 80), font, "Hello Blend2D!", 14);

  ctx:rotate(0.785398);
  ctx:fillUtf8Text(BLPoint(250, 80), font, "Rotated Text", 12);


  ctx:finish();

  local codec = BLImageCodec();
  --codec.findByName(BLImageCodec::builtInCodecs(), "BMP");
  b2d.blImageCodecFindByName(codec, b2d.blImageCodecBuiltInCodecs(), "BMP");
  img:writeToFile("bl-getting-started-7.bmp", codec);

end

main()

