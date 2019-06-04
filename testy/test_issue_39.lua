package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 

--local blapi = require("blend2d.blend2d_ffi")
local blapi = require("blend2d.blend2d")

local Gradient = require("Gradient")
local LinearGradient, RadialGradient = Gradient.LinearGradient, Gradient.RadialGradient


local function main()
    local img = ffi.new("struct BLImageCore");
    blapi.blImageInitAs(img, 480, 480, C.BL_FORMAT_PRGB32) ;

    local ctx = ffi.new("struct BLContextCore");
    blapi.blContextInitAs(ctx, img, nil);

    blapi.blContextSetCompOp(ctx, C.BL_COMP_OP_SRC_COPY);
    blapi.blContextFillAll(ctx);

--[[
    local values = BLLinearGradientValues( 0, 0, 256, 256 );
    local gradient, err = BLGradient(C.BL_GRADIENT_TYPE_LINEAR, values, C.BL_EXTEND_MODE_PAD, nil, 0, nil);
    print("BLGradient: ", gradient, err)
    blapi.blGradientAddStopRgba32(gradient, 1.0, 0xFFFFFFFF)
    blapi.blGradientAddStopRgba32(gradient, 0.5, 0xFFFF6F3F)
--]]

---[[
    -- THIS WILL CRASH
    -- it is very specific to radial gradient
    local values = BLRadialGradientValues(180, 180, 180, 180, 180)
    local gradient = ffi.new("BLGradientCore")
    local bResult = blapi.blGradientInitAs(gradient, C.BL_GRADIENT_TYPE_RADIAL, values, C.BL_EXTEND_MODE_PAD, nil, 0, nil) ;

    print("BLGradient: ", gradient, bResult);

    blapi.blGradientAddStopRgba32(gradient, 1.0, 0xFFFFFFFF)
    blapi.blGradientAddStopRgba32(gradient, 0.5, 0xFFFF6F3F)
--]]

    blapi.blContextSetCompOp(ctx, C.BL_COMP_OP_SRC_OVER);
    blapi.blContextSetFillStyle(ctx, gradient)

    local circle = BLCircle();
    circle.cx = 180;
    circle.cy = 180;
    circle.r = 160;
   
    -- low level to ensure it's not the C api wrapper doing anything
    ctx.impl.virt.fillGeometry(ctx.impl, C.BL_GEOMETRY_TYPE_CIRCLE, circle);


    -- Second Shape
    -- prove that normal object construction works fine
    -- when you use linear gradient
    local gradient2 = LinearGradient({values = {195, 195, 470, 470},
    stops = {
      {offset = 0.0, uint32 = 0xFFFFFFFF},
      {offset = 1.0, uint32 = 0xFF3F9FFF}
    }
  })

    ctx:setCompOp(C.BL_COMP_OP_DIFFERENCE);
    ctx:setFillStyle(gradient2);
    ctx:fillRoundRect(BLRoundRect(195, 195, 270, 270, 25,25));



-- These are only here to ensure GC does not kick in too early
    --print(img)
    --print(ctx)
    --print(values)
    --print(gradient)
    --print(circle)

    blapi.blContextEnd(ctx)


    BLImageCodec("BMP"):writeImageToFile(img, "output/test_radialgradient.bmp")
end




main()
