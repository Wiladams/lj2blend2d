package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 

local b2d = require("blend2d.blend2d")
local Gradient = require("Gradient")

local LinearGradient = Gradient.LinearGradient;


local function main() 
    local img = BLImageCore();
    local r = b2d.blImageInitAs(img, 256, 256, C.BL_FORMAT_PRGB32);
    if r ~= C.BL_SUCCESS then
        return false, "blImageInitAs FAIL";
    end

    local ctx = BLContextCore();
    r = b2d.blContextInitAs(ctx, img, nil);
    if (r ~= C.BL_SUCCESS) then
        return false, "blContextInitAs, FAIL";
    end

    local gradient = LinearGradient({values = {0, 0, 256, 256}, 
        stops = {
            {offset = 0.0, uint32 = 0xFFFFFFFF},
            {offset = 0.5, uint32 = 0xFFFFAF00},
            {offset = 1.0, uint32 = 0xFFFF0000}
        }
    })


    b2d.blContextSetFillStyle(ctx, gradient);
    b2d.blContextFillAll(ctx);
    b2d.blGradientReset(gradient);

    local circle = BLCircle();
    circle.cx = 128;
    circle.cy = 128;
    circle.r = 64;

    b2d.blContextSetCompOp(ctx, C.BL_COMP_OP_EXCLUSION);
    b2d.blContextSetFillStyleRgba32(ctx, 0xFF00FFFF);
    b2d.blContextFillGeometry(ctx, C.BL_GEOMETRY_TYPE_CIRCLE, circle);

    b2d.blContextEnd(ctx);

    codec = BLImageCodecCore();
    --b2d.blImageCodecInit(codec);
    b2d.blImageCodecFindByName(codec, b2d.blImageCodecBuiltInCodecs(), "BMP");
    b2d.blImageWriteToFile(img, "output/bl-capi-sample.bmp", codec);
    b2d.blImageCodecReset(codec);

    b2d.blImageReset(img);
end

main()