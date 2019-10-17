package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 


local blapi = require("blend2d.blend2d")

local function inch(c) return 72 * c end
local red = BLRgba32() red.r = 255; red.a = 255;
local black = BLRgba32() black.a = 255;
local white = BLRgba32() white.r = 255; white.g = 255; white.b = 255; white.a = 255;


local function crosshair(ctx)
    local path = BLPath()
    path:moveTo(-72,0)
    path:lineTo(72, 0)
    path:moveTo(0,72)
    path:lineTo(0, -72)
    

    ctx:setStrokeStyleRgba32(black.value)

    ctx:setStrokeWidth(1)
    ctx:strokePathD(path)
end




local function main()
    local img = BLImage(8.5*192,11*192)
    local ctx = BLContext(img)

    -- fill with black initially
    ctx:setCompOp(C.BL_COMP_OP_SRC_COPY)
    ctx:setFillStyle(white)
    ctx:fillAll()

    -- Create a red color for fill and stroke

    ctx:translate(inch(4.25), inch(5.5))
    --ctx:scale(inch(1), inch(1))

    crosshair(ctx)

    ctx:finish()

    BLImageCodec("BMP"):writeImageToFile(img, "output/test_thinline.bmp")
end

main()
