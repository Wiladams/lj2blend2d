

local ffi = require("ffi")
local C = ffi.C 


local b2d = require("blend2d.blend2d")
local radians = math.rad

local function main()
  local img = BLImage(480, 480)
  local ctx = BLContext(img);

  ctx:setCompOp(C.BL_COMP_OP_SRC_COPY);
  ctx:fillAll();

  -- Rotate by 45 degrees about a point at [240, 240].
   ctx:rotateAroundPoint(radians(45), 240, 240)
  
   -- Create a pattern.
  ctx:setCompOp(C.BL_COMP_OP_SRC_OVER);
  ctx:setFillStyle(BLPattern(BLImageCodec:readImageFromFile("resources/texture.jpeg")));
  ctx:fillRoundRect(BLRoundRect(50.0, 50.0, 380.0, 380.0, 80.5, 80.5));

  ctx:finish();
  
  BLImageCodec("BMP"):writeImageToFile(img, "output/bl-getting-started-4.bmp")
end

main()