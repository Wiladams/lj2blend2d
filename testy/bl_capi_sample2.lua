package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 

local b2d = require("blend2d.blend2d")

---[=[
local function main() 
    local img = BLImage(256, 256, C.BL_FORMAT_PRGB32);

    local ctx = BLContext(img);

    local values = BLLinearGradientValues({ 0, 0, 256, 256 });
    local gradient = BLGradient(C.BL_GRADIENT_TYPE_LINEAR, values, C.BL_EXTEND_MODE_PAD, nil, 0, nil);


    gradient:addStopRgba32(0.0, 0xFFFFFFFF);
    gradient:addStopRgba32(0.5, 0xFFFFAF00);
    gradient:addStopRgba32(1.0, 0xFFFF0000);

    ctx:setFillStyle(gradient);
    ctx:fillAll();


    local circle = BLCircle();
    circle.cx = 128;
    circle.cy = 128;
    circle.r = 64;

    --ctx:clip(64,64,128,128);
    --ctx:translate(256,256)
    ctx:setCompOp(C.BL_COMP_OP_EXCLUSION);
    ctx:setFillStyleRgba32(0xFF00FFFF);
    ctx:fillGeometry(C.BL_GEOMETRY_TYPE_CIRCLE, circle);

    ctx:finish();

    codec = BLImageCodec();

    BLImageCodec("BMP"):writeImageToFile(img, "output/bl-capi-sample2.bmp")
end

main()
--]=]