--[[
    Test out creating a flipped coordinate system, and measure the impacts 
    of the same.
]]

package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C

local blapi = require("blend2d.b2d")

local dpi = 192
local inchesWide = 8.5
local inchesHigh = 11

local w = inchesWide * dpi
local h = inchesHigh * dpi

-- Create our drawing context
local img = BLImage(w,h)
local ctx = BLContext(img)

local function _applyMatrixOpV(self, opType, ...)
    local n = select('#',...)
    local opData = ffi.new("double[?]",n, {...});
    local bResult self.impl.virt.matrixOp(self.impl, opType, opData);

    if bResult == C.BL_SUCCESS then
      return true;
    end

    return false, bResult;
end


-- must do this stroke transform order so
-- the stroke line thickness does not grow with the
-- scaling factor, but only obeys the setLineWidth
blapi.blContextSetStrokeTransformOrder(ctx, C.BL_STROKE_TRANSFORM_ORDER_BEFORE)

-- set coordinate system for y at the bottom
-- use the dpi to scale so that in user space, when
-- the user specifies a number, 1 == 1/72 inches (points)
local scalex = dpi / 72
local scaley = dpi / 72

_applyMatrixOpV(ctx, C.BL_MATRIX2D_OP_SCALE, 1, -1)
_applyMatrixOpV(ctx, C.BL_MATRIX2D_OP_TRANSLATE, 0, -h)
_applyMatrixOpV(ctx, C.BL_MATRIX2D_OP_SCALE, scalex, scaley)



-- we push from userToMeta so that this becomes
-- the baseline transform
-- Now when we push and pop other matrices, 
-- they can apply to user space, and not affect the
-- base transform
blapi.blContextUserToMeta(ctx)

-- start with full white background
blapi.blContextSetFillStyleRgba32(ctx, BLRgba32(0xFFFFFFFF).value)
blapi.blContextFillAll(ctx)



local function drawAxis()
    local path = BLPath()
    path:moveTo(0,0)
    path:lineTo(0,800)
    path:moveTo(0,0)
    path:lineTo(800,0)

    blapi.blContextStrokePathD(ctx, path) ;
end


local function drawFill()
    local path = BLPath()
    path:moveTo(0, 0)
    path:lineTo(72,0)
    path:lineTo(72,72)
    path:lineTo(0,72)
    path:close()

    local c = BLRgba32()
    c.r = 255;
    c.a = 255;

    blapi.blContextSetFillStyleRgba32(ctx, c.value)
    blapi.blContextSetStrokeStyleRgba32(ctx, c.value)

    blapi.blContextFillPathD(ctx, path)
end

local function drawStroke()
    local path = BLPath()
    blapi.blPathMoveTo(path, 0, 0) 

    path:lineTo(72,0)
    path:lineTo(72,72)
    path:lineTo(0,72)
    path:close()

    local c = BLRgba32()
    c.g = 255;
    c.a = 255;
    blapi.blContextSetFillStyleRgba32(ctx, c.value)
    blapi.blContextSetStrokeStyleRgba32(ctx, c.value)

    blapi.blContextStrokePathD(ctx, path)
end

blapi.blContextSetStrokeWidth(ctx, 4)
drawAxis()

_applyMatrixOpV(ctx, C.BL_MATRIX2D_OP_TRANSLATE, 36, 36)
--1 1 scale

drawFill()
drawStroke()

BLImageCodec("BMP"):writeImageToFile(img, "output/test_flip.bmp")
