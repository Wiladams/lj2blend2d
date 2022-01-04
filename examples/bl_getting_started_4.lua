

local ffi = require("ffi")
local C = ffi.C 
local b2d = require("blend2d.b2d")


local function main()
  local img = BLImage(480, 480);
  local ctx = BLContext(img);

  ctx:setCompOp(C.BL_COMP_OP_SRC_COPY);
  ctx:fillAll();

   -- Read an image from file.
  local texture, err = BLImageCodec:readImageFromFile("resources/texture.jpeg")

  if not texture then
      return false, "error reading texture.jpeg: ", err 
  end

   -- Create a pattern and use it to fill a rounded-rect.
  local pattern = BLPattern(texture);

  --success, err = ctx:rotateAroundPoint(radians(45), 240, 240)
  ctx:setCompOp(C.BL_COMP_OP_SRC_OVER);
  ctx:setFillStyle(pattern);
  ctx:fillRoundRect(BLRoundRect(40.0, 40.0, 400.0, 400.0, 45.5, 45.5));

  ctx:finish();


  BLImageCodec("BMP"):writeImageToFile(img, "output/bl-getting-started-4.bmp")

end

print(main())
