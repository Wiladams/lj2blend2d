package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 

require("b2dapp")

local b2d = require("blend2d.blend2d")


function setup()
    --noLoop();
    
    print("SETUP") 

print("appImage: ", appImage)



    local ctx = BLContextCore(appImage);
    local gradient = BLGradientCore();
    local values = BLLinearGradientValues({ 0, 0, 256, 256 });
    r = b2d.blGradientInitAs(gradient,
    C.BL_GRADIENT_TYPE_LINEAR, values,
    C.BL_EXTEND_MODE_PAD, nil, 0, nil);
    
    if r ~= C.BL_SUCCESS then
        return false, "BlGradientInitAs, FAIL";
    end

    b2d.blGradientAddStopRgba32(gradient, 0.0, 0xFFFFFFFF);
    b2d.blGradientAddStopRgba32(gradient, 0.5, 0xFFFFAF00);
    b2d.blGradientAddStopRgba32(gradient, 1.0, 0xFFFF0000);

    b2d.blContextSetFillStyle(ctx, gradient);
    b2d.blContextFillAll(ctx);


    local circle = BLCircle();
    circle.cx = 128;
    circle.cy = 128;
    circle.r = 64;

    b2d.blContextSetCompOp(ctx, C.BL_COMP_OP_EXCLUSION);
    b2d.blContextSetFillStyleRgba32(ctx, 0xFF00FFFF);
    b2d.blContextFillGeometry(ctx, C.BL_GEOMETRY_TYPE_CIRCLE, circle);

    ctx:finish();

--[[
    local codec = BLImageCodecCore();
    b2d.blImageCodecFindByName(codec, b2d.blImageCodecBuiltInCodecs(), "BMP");
    b2d.blImageWriteToFile(appImage, "test_b2dapp.bmp", codec);
    b2d.blImageCodecReset(codec);
--]]
--]=]



    --b2d.blImageReset(img);

    -- now draw the image
end

go({width=256, height=256})
--go()

