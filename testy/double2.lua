local ffi = require("ffi")
local sqrt = math.sqrt

ffi.cdef[[
struct vec2 {
    union {
        struct {
            double x;
            double y;
        };
        double data[2];
    };
};
]]

local vec2 = ffi.typeof("struct vec2")
local vec2_ops = {}
local vec2_mt = {
    __index = vec2_ops;
    __tostring = function(self)
        return string.format("vec2(%3.3f, %3.3f);", self.data[0], self.data[1])
    end;

    __add = function(self, other) return self:add(other) end;
    __sub = function(self, other) return self:sub(other) end;
    __unm = function(self) return self:negative() end;
}
ffi.metatype(vec2, vec2_mt)



-- mag - magnitude, length, norm
function vec2_ops.mag(self)
    return sqrt(self.x*self.x + self.y*self.y)
end

-- dot - inner product
function vec2_ops.dot(self, other)
    return self.x*other.x + self.y*other.y
end

--[[
-- cross product for 2D vector returns a scalar
-- What can you do with a 2D cross product?
-- http://www.allenchou.net/2013/07/cross-product-of-2d-vectors/
    One thing it tells you is an angle of rotation
--]]
function vec2_ops.cross(self, other)
    return self.x*other.y - self.y*other.x
end

--[[
    return the unitized version of a vector
]]
function vec2_ops.unit(self)
    local scalar = 1/self:mag()
    return vec2(self.x*scalar, self.y*scalar)
end

--[[
    Unary Operator
    return unary minus of a vector
]]
function vec2_ops.negative(self)
    return vec2(-self.x, -self.y)
end

--[[
    return a new vector.
    other - either a scalar, or another vector
]]
function vec2_ops.add(self, other)
    if type(other) == "cdata" then
        return vec2(self.x+other.x, self.y+other.y)
    elseif tonumber(other) then
        local anum = tonumber(other)
        return vec2(self.x+anum, self.y+anum)
    end

    return nil
end

--[[
    return a new vector
    other - either a scalar, or another vector
]]
function vec2_ops.sub(self, other)
    if type(other) == "cdata" then
        return vec2(self.x-other.x, self.y-other.y)
    elseif tonumber(other) then
        local anum = tonumber(other)
        return vec2(self.x-anum, self.y-anum)
    end

    return nil
end

return vec2