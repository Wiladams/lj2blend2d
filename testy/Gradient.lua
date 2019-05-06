
local ffi = require("ffi")
local C = ffi.C 

--local blapi = require("blend2d.blapi")
--require("blend2d.blgradient")
local blapi = require("blend2d.blend2d")

local function addStops(gradient, stops)
    if not stops then return false end

    for _,stop in ipairs(stops) do
        if stop.uint32 then
            gradient:addStopRgba32(stop.offset, stop.uint32)
        elseif stop.obj == BLRgba32 then
            gradient:addStopRgba32(stop.offset, stop.obj.value)
        end
    end

    return gradient
end

--[[
    You can create a linear gradient in one fell swoop by specifying
    all the value and stops information at once.  

    The radial and conical gradients use a similar construct

    local gr1 = LinearGradient({values = {0, 0, 256, 256},
        stops = {
            {offset = 0.0, uint32 = 0xFFFFFFFF},
            {offset = 0.5, uint32 = 0xFFFFAF00},
            {offset = 1.0, uint32 = 0xFFFF0000}
        }
    })
]]
local function LinearGradient(params)
    if not params then
        return nil, "must specify gradient parameters"
    end

    if not params.values then
        return nil, "must specify linear gradient values"
    end

    local extendMode = params.extendMode or C.BL_EXTEND_MODE_PAD
    local values = BLLinearGradientValues(params.values)
    
    local obj = ffi.new("struct BLGradientCore")
    local bResult = blapi.blGradientInitAs(obj, C.BL_GRADIENT_TYPE_LINEAR, values, extendMode, nil, 0, nil) ;
    if bResult ~= C.BL_SUCCESS then
      return nil, bResult;
    end

    addStops(obj, params.stops)
    
    return obj;
end

local function RadialGradient(params)
    if not params then
        return nil, "must specify gradient parameters"
    end

    if not params.values then
        return nil, "must specify linear gradient values"
    end

    local extendMode = params.extendMode or C.BL_EXTEND_MODE_PAD
    local values = BLRadialGradientValues(params.values)
    
    local obj = ffi.new("struct BLGradientCore")
    local bResult = blapi.blGradientInitAs(obj, C.BL_GRADIENT_TYPE_RADIAL, values, extendMode, nil, 0, nil) ;
    if bResult ~= C.BL_SUCCESS then
      return nil, bResult;
    end

    addStops(obj, params.stops)
    
    return obj;
end

local function ConicalGradient(params)
    if not params then
        return nil, "must specify gradient parameters"
    end

    if not params.values then
        return nil, "must specify linear gradient values"
    end

    local extendMode = params.extendMode or C.BL_EXTEND_MODE_PAD
    local values = BLConicalGradientValues(params.values)
    
    local obj = ffi.new("struct BLGradientCore")
    local bResult = blapi.blGradientInitAs(obj, C.BL_GRADIENT_TYPE_CONICAL, values, extendMode, nil, 0, nil) ;
    if bResult ~= C.BL_SUCCESS then
      return nil, bResult;
    end

    addStops(obj, params.stops)
    
    return obj;
end

return {
    LinearGradient = LinearGradient;
    RadialGradient = RadialGradient;
    ConicalGradient = ConicalGradient;
}