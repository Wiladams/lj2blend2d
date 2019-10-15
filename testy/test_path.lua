package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 


local blapi = require("blend2d.blend2d")

local function inch(c) return 72 * c end

local function crosshair(ctx)
    local path = BLPath()
    path:moveTo(0,0)
    path:rlineTo(0, 0.25)
    path:moveTo(0,0)
    path:rlineTo(0.25, 0)
    
    local c = BLRgba32()
    c.r = 255;
    c.a = 255;

    ctx:setStrokeStyleRgba32(c.value)

    ctx:setStrokeWidth(1/36)
    ctx:strokePathD(path)
end

local function wedge(ctx)
    local path = BLPath()
    path:moveTo(0,0)

    -- we essentially want this transform to be
    -- applied to the upcoming arc segment, but
    -- not to the overall path, so gsave?
    ctx:save()
    -- just use the context to get the transformation matrix
    ctx:translate(1,0)
    ctx:rotate(math.rad(15))
    ctx:translate(0,math.sin(math.rad(15)))
    local m = ctx:userMatrix()
    print("M: ", m)
    ctx:restore()

    -- now use that user matrix to add the arc section in its own transform
    -- do the arc part
    local arcpath = BLPath()
    arcpath:moveTo(0,0)
    local angle1 = -90
    local angle2 = 90
    local sweep = math.rad(angle2 - angle1)
    local r = math.sin(math.rad(15))
    local bResult = arcpath:arcTo(0, 0, r, r, math.rad(angle1), sweep, false)
    
    path:addTransformedPath(arcpath, nil, m)


    path:close()

    ctx:setStrokeWidth(1/72)
    ctx:fillPathD(path)
end

local red = BLRgba32() red.r = 255; red.a = 255;
local black = BLRgba32() black.a = 255;
local white = BLRgba32() white.r = 255; white.g = 255; white.b = 255; white.a = 255;

local function main()
    local img = BLImage(8.5*192,11*192)
    local ctx = BLContext(img)

    -- fill with black initially
    ctx:setCompOp(C.BL_COMP_OP_SRC_COPY)
    ctx:fillAll()

    -- Create a red color for fill and stroke


    --blapi.blContextSetFillStyleRgba32(ctx, c.value)
    --blapi.blContextSetStrokeStyleRgba32(ctx, c.value)
    --ctx:setStrokeWidth(0.025)

    ctx:translate(inch(3.75), inch(7.25))
    ctx:scale(inch(1), inch(1))

    crosshair(ctx)

    ctx:setFillStyleRgba32(white.value)
    wedge(ctx)


    ctx:finish()

    BLImageCodec("BMP"):writeImageToFile(img, "output/test_path.bmp")
end

main()
