package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 

local blapi = require("blend2d.b2d")
local enum = require("blend2d.enum")


local dpi = 192
local scalex = dpi / 72
local scaley = dpi / 72

local w = math.floor(8.5 * dpi)
local h = math.floor(11 * dpi)
print("w,h: ", w, h)

local img = BLImage(w,h)
local ctx = BLContext(img)

ctx:setStrokeTransformOrder(C.BL_STROKE_TRANSFORM_ORDER_BEFORE)

-- flip coordinates
ctx:scale(1,-1)
ctx:translate(0,-h)
ctx:scale(scalex, scaley)
ctx:userToMeta()

-- clear background
ctx:setFillStyle(BLRgba32(0xffffffff))
ctx:fillAll()

-- draw a line using a path object
ctx:setStrokeWidth(4)
ctx:setStrokeStyle(BLRgba32(0xff000000))
ctx:scale(72,72)

local p = BLPath()
p:moveTo(0, 0)
p:lineTo(1,1)
ctx:strokePathD(p)

ctx:finish();
print("FINISH")

print(BLImageCodec("BMP"):writeImageToFile(img, "output/test_transform.bmp"))
