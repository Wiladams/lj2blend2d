

local ffi = require("ffi")
local C = ffi.C 

local b2d = require("blend2d.b2d")

local function main() 
  local img = BLImage(480, 480);
  local ctx = BLContext(img);

  ctx:setCompOp(C.BL_COMP_OP_SRC_COPY);
  ctx:fillAll();

  local face, err = BLFontFace:createFromFile("resources/NotoSans-Regular.ttf");

  -- We must handle a possible error returned by the loader.
  if (not face) then
    print("Failed to load a font-face: ", err);
    return false;
  end


  local font = face:createFont(50.0)
  
  ctx:setFillStyle(BLRgba32(0xFFFFFFFF));
  ctx:fillTextUtf8(BLPoint(60, 80), font, "Hello Blend2D!", 14);

  ctx:rotate(0.785398);
  ctx:fillTextUtf8(BLPoint(250, 80), font, "Rotated Text", 12);


  ctx:finish();

  BLImageCodec("BMP"):writeImageToFile(img, "output/bl-getting-started-7.bmp")
end

main()

