local ffi = require("ffi")
local C = ffi.C 

local b2d = require("blend2d.blend2d")


local function  main()
    local ctx = BLContext(480,480)

    ctx:setCompOp(C.BL_COMP_OP_SRC_COPY);
    ctx:setFillStyle(BLRgba32(0xFFFFFFFF));

    ctx:fillAll();



  local face, err = BLFontFace:createFromFile("resources/NotoSans-Regular.ttf");

  -- We must handle a possible error returned by the loader.
  if (not face) then
    print("Failed to load a font-face: ", err);
    return false;
  end

  local font = face:createFont(20.0)


  local fm = font.metrics(); -- BLFontMetrics
  local tm = nil;    -- BLTextMetrics
  local gb;            -- BLGlyphBuffer

  local p = BLPoint(20, 190 + fm.ascent);
  local text = [[
Hello Blend2D!
I'm a simple multiline text example
that uses BLGlyphBuffer and fillGlyphRun!
]]

  while true do
    local ending = strchr(text, '\n');
    gb.setUtf8Text(text, end ? (size_t)(end - text) : SIZE_MAX);
    font:shape(gb);
    font:getTextMetrics(gb, tm);

    p.x = (480.0 - (tm.boundingBox.x1 - tm.boundingBox.x0)) / 2.0;
    ctx:fillGlyphRun(p, font, gb.glyphRun());
    p.y = p.y + fm.ascent + fm.descent + fm.lineGap;

    if not ending  then
      break;
    end
    
    text = ending + 1;
  end
  
  ctx:finish();

  BLImageCodec("BMP"):writeImageToFile(img, "output/bl-getting-started-8.bmp")
end

main()
