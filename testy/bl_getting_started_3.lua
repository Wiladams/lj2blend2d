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

  if not success then
      print("readFromFile failed: ", err)
      return false
  end

   -- Create a pattern and use it to fill a rounded-rect.
  local pattern = BLPattern(texture);


  ctx:setCompOp(C.BL_COMP_OP_SRC_OVER);
  ctx:setFillStyle(pattern);
  ctx:fillRoundRect(40.0, 40.0, 400.0, 400.0, 45.5);

  ctx:finish();

  img:writeToFile("output/bl-getting-started-3.bmp", BLImageCodec:findByName("BMP"));
end

main()
