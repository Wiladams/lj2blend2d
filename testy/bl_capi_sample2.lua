package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 

local b2d = require("blend2d.blend2d")



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

    local gradient = BLGradientCore();
    local values = BLLinearGradientValues({ 0, 0, 256, 256 });
    r = b2d.blGradientInitAs(gradient,
        C.BL_GRADIENT_TYPE_LINEAR, values,
        C.BL_EXTEND_MODE_PAD, nil, 0, nil);
    
    if r ~= C.BL_SUCCESS then
        return false, "BlGradientInitAs, FAIL";
    end

    gradient:AddStopRgba32(0.0, 0xFFFFFFFF);
    gradient:AddStopRgba32(0.5, 0xFFFFAF00);
    gradient:AddStopRgba32(1.0, 0xFFFF0000);

    b2d.blContextSetFillStyle(ctx, gradient);
    b2d.blContextFillAll(ctx);
    --b2d.blGradientReset(gradient);

    local circle = BLCircle();
    circle.cx = 128;
    circle.cy = 128;
    circle.r = 64;

    b2d.blContextSetCompOp(ctx, C.BL_COMP_OP_EXCLUSION);
    b2d.blContextSetFillStyleRgba32(ctx, 0xFF00FFFF);
    b2d.blContextFillGeometry(ctx, C.BL_GEOMETRY_TYPE_CIRCLE, circle);

    b2d.blContextEnd(ctx);

    codec = BLImageCodecCore();

    b2d.blImageCodecFindByName(codec, b2d.blImageCodecBuiltInCodecs(), "BMP");
    b2d.blImageWriteToFile(img, "bl-capi-sample.bmp", codec);


    b2d.blImageReset(img);
end

main()