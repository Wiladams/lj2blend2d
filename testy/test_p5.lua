package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 

require("p5")

function setup()
    noLoop();

    local linear = BLGradientCore(BLLinearGradientValues({ 0, 0, 256, 256 }));

    linear:addStop(0.0, 0xFFFFFFFF)
    linear:addStop(0.5, 0xFFFFAF00)
    linear:addStop(1.0, 0xFFFF0000)

    appContext:setFillStyle(linear);
    appContext:fillAll();


    local circle = BLCircle(128, 128, 64);


    appContext:setCompOp(C.BL_COMP_OP_EXCLUSION)
    appContext:setFillStyle(BLRgba32(0xFF00FFFF))
    appContext:fillCircle(circle);

    appContext:finish();

end

function keyPressed(event)
    print("keyPressed: ", string.format("0x%2x", keyCode))
end

go({width=256, height=256})


