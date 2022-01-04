package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 

local b2d = require("blend2d.b2d")

local img = BLImage(256, 256, BL_FORMAT_PRGB32);
local ctx = BLContext (img, cci);

ctx:clearAll();

-- 'BLLinearGradientValues' can be used to specify a linear gradient.
gradient = BLGradient(BLLinearGradientValues(4, 4, 226, 226));
gradient:addStop(0.0, BLRgba32(0xFFFFFFFF));
gradient:addStop(0.5, BLRgba32(0xFF5FAFDF));
gradient:addStop(1.0, BLRgba32(0xFF2F5FDF));

ctx:setFillStyle(gradient);
ctx:fillCircle(128, 128, 128);

ctx:finish();

BLImageCodec("BMP"):writeImageToFile(img, "output/test_style_linear.bmp")
