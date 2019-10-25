local ffi = require("ffi")
local sqrt = math.sqrt

ffi.cdef[[
struct double3 {
    union {
        struct {
            double x;
            double y;
            double z;
        };
        double data[3];
    };
};
]]

local double3 = ffi.typeof("struct double3")
local double3_ops = {}
local double3_mt = {
    __index = double3_ops;
    __tostring = function(self)
        return string.format("double3(%3.3f, %3.3f, %3.3f);", self.data[0], self.data[1], self.data[2])
    end;

    __add = function(self, other) return self:add(other) end;
    __sub = function(self, other) return self:sub(other) end;
    __unm = function(self) return self:negative() end;
}
ffi.metatype(double3, double3_mt)



-- mag - magnitude, length, norm
function double3_ops.mag(self)
    return sqrt(self.x*self.x + self.y*self.y + self.z*self.z)
end

-- dot - inner product
function double3_ops.dot(self, other)
    return self.x*other.x + self.y*other.y + self.z*other.z
end

--[[
-- cross product for 3D vector returns a scalar
--]]
function double3_ops.cross(self, other)
    return self.x*other.y - self.y*other.x
end

--[[
    return the unitized version of a vector
]]
function double3_ops.unit(self)
    local scalar = 1/self:mag()
    return double3(self.x*scalar, self.y*scalar, self.z*scalar)
end

--[[
    Unary Operator
    return unary minus of a vector
]]
function double3_ops.negative(self)
    return double3(-self.x, -self.y, -self.z)
end

--[[
    return a new vector.
    other - either a scalar, or another vector
]]
function double3_ops.add(self, other)
    if type(other) == "cdata" then
        return double3(self.x+other.x, self.y+other.y, self.z+other.z)
    elseif tonumber(other) then
        local anum = tonumber(other)
        return double3(self.x+anum, self.y+anum, self.z+anum)
    end

    return nil
end

--[[
    return a new vector
    other - either a scalar, or another vector
]]
function double3_ops.sub(self, other)
    if type(other) == "cdata" then
        return double3(self.x-other.x, self.y-other.y, self.z-other.z)
    elseif tonumber(other) then
        local anum = tonumber(other)
        return double3(self.x-anum, self.y-anum, self.z-anum)
    end

    return nil
end

return double3