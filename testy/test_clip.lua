--[[
    This test case is intended to isolate a specific crash
    it is registered as issue #38 in the blend2d issue tracker
    
    https://github.com/blend2d/blend2d/issues/38

]]
package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 

local blapi = require("blend2d/blend2d_ffi")

local BLContext = ffi.typeof("BLContextCore")
local BLImage = ffi.typeof("BLImageCore")
local BLRectI = ffi.typeof("BLRectI")
local BLRect = ffi.typeof("BLRect")
local BLRgba32 = ffi.typeof("BLRgba32")

ffi.cdef[[
void * malloc(size_t size);
]]

local function _applyMatrixOpV(ctx, opType, ...)
    local opData = ffi.new("double[?]",select('#',...), {...});
    print("sizeof opdata: ", ffi.sizeof(opData), opData[0], opData[1])
    local bResult = ctx.impl.virt.matrixOp(ctx.impl, opType, opData);
    if bResult == C.BL_SUCCESS then
        return bResult;
    end

    return false, bResult
end

local function flush(ctx)
    local flags = C.BL_CONTEXT_FLUSH_SYNC;
    local bResult = ctx.impl.virt.flush(ctx.impl, flags);
end

local function translate (ctx, x, y)
    local opData = ffi.new("double[2]")
    opData[0] = x;
    opData[1] = y;
    -- print("sizeof opdata: ", ffi.sizeof(opData), opData[0], opData[1])
    local bResult = ctx.impl.virt.matrixOp(ctx.impl, C.BL_MATRIX2D_OP_TRANSLATE, opData);

    flush(ctx)
    --return _applyMatrixOpV(ctx, C.BL_MATRIX2D_OP_TRANSLATE, x, y);
end


local function main()
    local x = 390
    local y = 10
    local width = 100
    local height = 100

    -- setup context
    local img = ffi.new("BLImageCore")
    blapi.blImageInitAs(img, 400,400, C.BL_FORMAT_PRGB32)

    local ctx = ffi.new("BLContextCore")
    blapi.blContextInitAs(ctx, img, nil)

    local crecti = ffi.new("BLRectI")
    crecti.x = x;
    crecti.y = y;
    crecti.w = width;
    crecti.h = height;
    ctx.impl.virt.clipToRectI(ctx.impl, crecti)
    --blapi.blContextClipToRectI(ctx, crecti) ;
    flush(ctx)

    -- translate
    local opData = ffi.new("double[2]")
    opData[0] = x;
    opData[1] = y;
    ctx.impl.virt.matrixOp(ctx.impl, C.BL_MATRIX2D_OP_TRANSLATE, opData);
    flush(ctx)    


    --local srecti = BLRectI(0,0,width,height)
    local srecti = ffi.new("BLRectI")
    srecti.x = 0;
    srecti.y = 0;
    srecti.h = height;
    -- will NOT crash
    --srecti.w = 13;

    -- WILL crash
    srecti.w = width;

    blapi.blContextStrokeRectI(ctx, srecti)
end

local function main2()
    local x = 390
    local y = 10
    local width = 100
    local height = 100


    local img = ffi.new("BLImageCore")
    blapi.blImageInitAs(img, 400,400, C.BL_FORMAT_PRGB32)

    local ctx = ffi.new("BLContextCore")
    blapi.blContextInitAs(ctx, img, nil)

    local recti = ffi.new("BLRectI")
    recti.x = x;
    recti.y = y;
    recti.w = width;
    recti.h = height;

    -- clip
    local recti = ffi.new("BLRectI")
    recti.x = x;
    recti.y = y;
    recti.w = width;
    recti.h = height;
    blapi.blContextClipToRectI(ctx, recti) ;
    
    -- translate
    local opData = ffi.new("double[2]")
    opData[0] = x;
    opData[1] = y;
    ctx.impl.virt.matrixOp(ctx.impl, C.BL_MATRIX2D_OP_TRANSLATE, opData);


    local srecti = ffi.new("BLRectI")
    srecti.x = 0;
    srecti.y = 0;
    srecti.h = height;

    -- will NOT crash
    --srecti.w = 14;

    -- WILL crash
    srecti.w = 15;

    blapi.blContextStrokeRectI(ctx, srecti)
end



local function test_types()
    local rectI = BLRectI({390,10,100,100})
    local rectD = BLRect(390,10,100,100)

    print("rectI: ", rectI.x, rectI.y, rectI.w, rectI.h)
    print("rectD: ", rectD.x, rectD.y, rectD.w, rectD.h)
end

--test_types();
--main()
main2()