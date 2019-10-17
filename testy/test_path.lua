package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 


local blapi = require("blend2d.blend2d")

local function inch(c) return 72 * c end
local red = BLRgba32() red.r = 255; red.a = 255;
local black = BLRgba32() black.a = 255;
local white = BLRgba32() white.r = 255; white.g = 255; white.b = 255; white.a = 255;
local gray = BLRgba32() gray.r = 0xcc; gray.g = 0xcc; gray.b = 0xcc; gray.a = 0xff;


local function crosshair(ctx)

    ctx:setStrokeStyle(red)
    ctx:setStrokeWidth(8)
    
    local path = BLPath()

    path:moveTo(-72,0)
    path:lineTo(72, 0)
    path:moveTo(0,72)
    path:lineTo(0, -72)

    ctx:strokePathD(path)
end

local function wedge(ctx)
    local path = BLPath()
    path:moveTo(0,0)

    -- we essentially want this transform to be
    -- applied to the upcoming arc segment, but
    -- not to the overall path, so gsave?
    local m = BLMatrix2D()
    m:translate(1, 0)
    m:rotate(math.rad(15))
    m:translate(0, math.sin(math.rad(15)))

--[[
    ctx:save()
    -- just use the context to get the transformation matrix
    ctx:translate(1,0)
    ctx:rotate(math.rad(15))
    ctx:translate(0,math.sin(math.rad(15)))
    local m = ctx:userMatrix()
    --print("M: ", m)
    ctx:restore()
--]]

    -- now use that user matrix to add the arc section in its own transform
    local angle1 = -90
    local angle2 = 90
    local sweep = math.rad(angle2 - angle1)
    local r = 144*math.sin(math.rad(15))
    local arc = ffi.new("struct BLArc")
    arc.cx = r
    arc.cy = 0
    arc.rx = r
    arc.ry = r 
    arc.start = math.rad(angle1)
    arc.sweep = sweep
    print("arc: ", arc.rx, arc.ry, arc.start, arc.sweep)

    --local bResult = path:addGeometry(C.BL_GEOMETRY_TYPE_ARC, arc, m, C.BL_GEOMETRY_DIRECTION_CW)
    local bResult = path:addGeometry(C.BL_GEOMETRY_TYPE_ARC, arc, nil, C.BL_GEOMETRY_DIRECTION_CW)
    --path:lineTo(r,0)
    --path:lineTo(r, r)

    path:close()

    --ctx:setStrokeWidth(1/72)
    print("fillStyle: ", ctx:setFillStyle(black))
    print("strokeStyle: ", ctx:setStrokeStyle(black))
    
    print("fillPathD: ", ctx:fillPathD(path))
    print("strokePathD: ", ctx:strokePathD(path))
end


local function main()
    local dpi = 192
    local pageWidth = 8.5
    local pageHeight = 11

    local w = math.floor((pageWidth * dpi)+0.5)
    local h = pageHeight*dpi

    print("w,h: ", w, h)

    local scalex = dpi / 72
    local scaley = dpi / 72

    local img = BLImage(w,h)
    local ctx = BLContext(img)

    ctx:setStrokeTransformOrder(C.BL_STROKE_TRANSFORM_ORDER_BEFORE)

    -- setup initial coordinate system
    -- 0,0 in lower left, increase right,up
    ctx:translate(0, h)
    ctx:scale(1, -1)
    ctx:scale(scalex, scaley)

    -- Using userToMeta with definitely throw off the usage
    -- of fillPathD
    --ctx:userToMeta()

    -- fill with background color
    ctx:setCompOp(C.BL_COMP_OP_SRC_COPY)
    ctx:setFillStyle(gray)
    ctx:fillAll()

    local cx = pageWidth*72 / 2
    local cy = pageHeight*72 / 2

    -- crosshair in the middle of the page
    ctx:translate(cx, cy)
    crosshair(ctx)

    wedge(ctx)


    ctx:finish()

    BLImageCodec("BMP"):writeImageToFile(img, "output/test_path.bmp")
end

main()
