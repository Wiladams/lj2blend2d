package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 


local blapi = require("blend2d.b2d")

local DPI = 96

local red = BLRgba32() red.r = 255; red.a = 255;
local black = BLRgba32() black.a = 255;
local white = BLRgba32() white.r = 255; white.g = 255; white.b = 255; white.a = 255;

local function inch(c) return math.floor(DPI * c) end

local pageWidth = inch(8.5)
local pageHeight = inch(11)

local function crosshair(ctx)
    local path = BLPath()
    path:moveTo(-inch(1),0)
    path:lineTo(inch(1), 0)
    path:moveTo(0,inch(1))
    path:lineTo(0, -inch(1))
    

    ctx:setStrokeStyleRgba32(black.value)

    ctx:setStrokeWidth(1)
    ctx:strokePathD(path)
end

local function main()
    local img = BLImage(inch(8.5),inch(11))
    local ctx = BLContext(img)

    -- fill with black initially
    ctx:setCompOp(C.BL_COMP_OP_SRC_COPY)
    ctx:setFillStyle(white)
    ctx:fillAll()

    -- Create a red color for fill and stroke

    ctx:translate(pageWidth/2, pageHeight/2)

    crosshair(ctx)

    ctx:finish()

    BLImageCodec("BMP"):writeImageToFile(img, "output/test_thinline.bmp")
end

main()
