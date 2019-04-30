package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 


local DrawingContext = require("DrawingContext")
DrawingContext:exportConstants()
local Gradient = require("Gradient")


local function main() 
    local ctx = DrawingContext:new(256, 256)

    local gradient = Gradient.LinearGradient({values = {0, 0, 256, 256}, 
        stops = {
            {offset = 0.0, uint32 = 0xFFFFFFFF},
            {offset = 0.5, uint32 = 0xFFFFAF00},
            {offset = 1.0, uint32 = 0xFFFF0000}
        }
    })

    ctx:fill(gradient)
    ctx:fillAll()

    ctx:setCompOp(BL_COMP_OP_EXCLUSION)
    ctx:fill(BLRgba32(0xFF00FFFF))
    --ctx:noStroke()
    --ctx:fillEllipse(128, 128, 64, 64)
    ctx:circle(128, 128, 64)

    BLImageCodec("BMP"):writeImageToFile(ctx:getReadyBuffer(), "output/bl-capi-sample.bmp")
end

main()