package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

local blapi = require("blend2d.blend2d")
local enum = require("blend2d.enum")

local BLMatrix2DType = enum {

    BL_MATRIX2D_TYPE_IDENTITY = 0,
    BL_MATRIX2D_TYPE_TRANSLATE = 1,
    BL_MATRIX2D_TYPE_SCALE = 2,
    BL_MATRIX2D_TYPE_SWAP = 3,
    BL_MATRIX2D_TYPE_AFFINE = 4,
    BL_MATRIX2D_TYPE_INVALID = 5,

    BL_MATRIX2D_TYPE_COUNT = 6
  };

--[[
BLResult __cdecl blMatrix2DSetIdentity(BLMatrix2D* self) ;
BLResult __cdecl blMatrix2DSetTranslation(BLMatrix2D* self, double x, double y) ;
BLResult __cdecl blMatrix2DSetScaling(BLMatrix2D* self, double x, double y) ;
BLResult __cdecl blMatrix2DSetSkewing(BLMatrix2D* self, double x, double y) ;
BLResult __cdecl blMatrix2DSetRotation(BLMatrix2D* self, double angle, double cx, double cy) ;
BLResult __cdecl blMatrix2DApplyOp(BLMatrix2D* self, uint32_t opType, const void* opData) ;
BLResult __cdecl blMatrix2DInvert(BLMatrix2D* dst, const BLMatrix2D* src) ;
uint32_t __cdecl blMatrix2DGetType(const BLMatrix2D* self) ;
BLResult __cdecl blMatrix2DMapPointDArray(const BLMatrix2D* self, BLPoint* dst, const BLPoint* src, size_t count) ;
--]]

local function test_identity()
    print("== IDENTITY ==")
    local m1 = BLMatrix2D:createIdentity()
    print("m1, default: ")
    print(m1)
    print("type: ", BLMatrix2DType[blapi.blMatrix2DGetType(m1)])
end

local function test_scale()    
    --spawn(pianoapp, {x= 280, y = 200, width=640, height=290})
    local whiteKeyWidth = 0.143
    local whiteKeyHeight = 1

    print("== SCALE ==")
    local m1 = BLMatrix2D:createScaling(640, 290)
    print("m1, scaling: 640, 290")
    print(m1)
    print("type: ", BLMatrix2DType[blapi.blMatrix2DGetType(m1)])

    local count = 1;
    local srcPts = ffi.new("BLPoint[?]", 1, BLPoint(whiteKeyWidth, 1))
    local dstPts = ffi.new("BLPoint[?]", count)

    m1:transformPoints(dstPts, srcPts, count)

    for i=0,count-1 do 
        print(dstPts[i].x, dstPts[i].y)
    end
end

local function test_translate()
    print("== TRANSLATE ==")
    local m1 = BLMatrix2D:createTranslation(10,20)
    print("m1, translation: 10, 20")
    print(m1)
    print("type: ", BLMatrix2DType[blapi.blMatrix2DGetType(m1)])
end

local function test_rotate()
    print("== ROTATE ==")
    local m1 = BLMatrix2D:createRotation(0.785398, 240.0, 240.0)
    print("m1, rotation: 0.785398, 240.0, 240.0")
    print(m1)
    print("type: ", BLMatrix2DType[blapi.blMatrix2DGetType(m1)])
end

local function test_applyop()
    local function applyOp(op, ...)
        local opData = ffi.new("double[?]",select('#',...), {...});
    end

    applyOp(1, 2, 3)
end

local function test_usermeta()

    -- create scaling matrix
    --local s1 = BLMatrix2D:createScaling(16,9)
    --print("SCALING")
    --print(s1)

    -- get meta matrix
    local ctx = BLContext(640, 480)
    local meta1 = ctx:metaMatrix()
    print("META BEFORE")
    print(meta1)

    -- blcontext scale
    ctx:scale(16, 9)
    local user1 = ctx:userMatrix()
    local meta1 = ctx:metaMatrix()

    print("AFTER SCALE (16, 9)")
    print("USER")
    print(user1)
    print("META")
    print(meta1)

    -- apply user to meta
    ctx:userToMeta()
    print("AFTER USER TO META")
    print("USER")
    print(ctx:userMatrix())
    print("META")
    print(ctx:metaMatrix())

    print("AFTER CLEAR ALL")
    ctx:clearAll()
    print("USER")
    print(ctx:userMatrix())
    print("META")
    print(ctx:metaMatrix())

end

local function test_flip()
    -- get meta matrix
    local dpi = 192
    local scalex = dpi / 72
    local scaley = dpi / 72

    local w = math.floor(8.5 * dpi)
    local h = math.floor(11 * dpi)
    print("w,h: ", w, h)

    local ctx = BLContext(w, h)
    local meta1 = ctx:metaMatrix()
    print("META BEFORE")
    print(meta1)


    -- translate
    ctx:scale(1,-1)
    ctx:translate(0,-h)
    ctx:scale(scalex, scaley)

    -- blcontext scale
    local user1 = ctx:userMatrix()
    local meta1 = ctx:metaMatrix()

    print("AFTER SCALE (1, -1)")
    print("USER")
    print(user1)
    print("META")
    print(meta1)

    -- apply user to meta
    ctx:userToMeta()
    print("AFTER USER TO META")
    print("USER")
    print(ctx:userMatrix())
    print("META")
    print(ctx:metaMatrix())

    print("AFTER USER SCALE")
    ctx:scale(72,72)
    print("USER")
    print(ctx:userMatrix())
    print("META")
    print(ctx:metaMatrix())

end

--test_identity()
--test_scale()
--test_translate()
--test_rotate()
--test_applyop()
--test_usermeta()
test_flip()
