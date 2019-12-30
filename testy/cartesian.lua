--[[
    Representation of cartesian coordinate system
]]
local sqrt = math.sqrt

local vectypes = require("vectypes")
local double2 = vectypes.double2
local double3 = vectypes.double3

local exports = {}

-- mag - magnitude, length, norm
local function mag2(a)
    return sqrt(a.x*a.x + a.y*a.y)
end
exports.mag2 = mag2

local function mag3(a)
    return sqrt(a.x*a.x + a.y*a.y + a.z*a.z)
end
exports.mag3 = mag3

--[[
    return the unitized version of a vector
]]
local function unit2(a)
    local scalar = 1/mag2(a)
    return double2(a.x*scalar, a.y*scalar)
end
exports.unit2 = unit2

local function unit3(a)
    local scalar = 1/mag3(a)
    return double2(a.x*scalar, a.y*scalar, a.z*scalar)
end
exports.unit3 = unit3



--[[
-- cross product 
--]]

--[[
    for 2D vector returns a scalar
-- What can you do with a 2D cross product?
-- http://www.allenchou.net/2013/07/cross-product-of-2d-vectors/
    One thing it tells you is an angle of rotation
--]]
local function cross2(a, b)
    return a.x*b.y - a.y*b.x
end
exports.cross2 = cross2


local function cross3(a, b)
    return double3(
        (a.y*b.z-a.z*b.y),
        (a.z*b.x - a.x*b.z),
        (a.x*b.y - a.y*b.x)
    )
end
exports.cross3 = cross3


-- dot - inner product
local function dot2(a, b)
    return a.x*b.x + a.y*b.y
end
exports.dot2 = dot2

local function dot3(a, b)
    return a.x*b.x + a.y*b.y + a.z*b.z
end
exports.dot3 = dot3


local Cartesian = {}
setmetatable(Cartesian, {
    __call = function(self, ...)
        return self:new(...)
    end;
})
local Cartesian_mt = {
    __index = Cartesian;
}

function Cartesian.new(selfl, basis)
    local obj = {
        basis = basis or {double3(1,0,0), double3(0,1,0), double3(0,0,1)}
    }
    setmetatable(obj, Cartesian_mt)

    return obj
end

function Cartesian.cross(self, a, b)
    return cross3(a, b)
end

function Cartesian.dot(self, a, b)
    return dot3(a, b)
end


return Cartesian
