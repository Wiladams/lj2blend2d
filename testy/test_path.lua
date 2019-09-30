package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 


local blapi = require("blend2d.blend2d")

local function main()
    local img = ffi.new("struct BLImageCore");
    blapi.blImageInitAs(img, 480, 480, C.BL_FORMAT_PRGB32) ;

    local ctx = ffi.new("struct BLContextCore");
    blapi.blContextInitAs(ctx, img, nil);

    blapi.blContextSetCompOp(ctx, C.BL_COMP_OP_SRC_COPY);
    blapi.blContextFillAll(ctx);

    local c = BLRgba32()
    c.r = 255;
    c.a = 255;

    blapi.blContextSetFillStyleRgba32(ctx, c.value)
    blapi.blContextSetStrokeStyleRgba32(ctx, c.value)
    ctx:setStrokeWidth(2)

    local apath = BLPath()

    for i=0,80,5 do
        ctx:rotate(math.rad(10))
        apath:moveTo(0,0)
        apath:lineTo(100,0)
        blapi.blContextStrokePathD(ctx, apath)
    end

    blapi.blContextStrokePathD(ctx, apath)


    blapi.blContextEnd(ctx)

    BLImageCodec("BMP"):writeImageToFile(img, "output/test_path.bmp")
end

main()
