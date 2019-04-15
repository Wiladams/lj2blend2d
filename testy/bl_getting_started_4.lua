package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 


local b2d = require("blend2d.blend2d")

local function main()
  local img = BLImage(480, 480, C.BL_FORMAT_PRGB32);
  local ctx = BLContext(img);

  ctx:setCompOp(C.BL_COMP_OP_SRC_COPY);
  ctx:fillAll();

  -- Read an image from file.
  local texture = BLImage();
  local success, err = texture:readFromFile("resources/texture.jpeg");

  if (not success) then
    print("Failed to load a texture:", err);
    return false;
  end

  -- Rotate by 45 degrees about a point at [240, 240].
  ctx:rotate(0.785398, 240.0, 240.0);

  -- Create a pattern.
  ctx:setCompOp(C.BL_COMP_OP_SRC_OVER);
  ctx:setFillStyle(BLPattern(texture));
  ctx:fillRoundRect(50.0, 50.0, 380.0, 380.0, 80.5);

  ctx:finish();
  
  img:writeToFile("output/bl-getting-started-4.bmp", BLImageCodec:findByName("BMP"));
end

main()