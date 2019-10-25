local ffi = require("ffi")
local sqrt = math.sqrt

ffi.cdef[[
struct double2 {
    union {
        struct {
            double x;
            double y;
        };
        double data[2];
    };
};
]]

local double2 = ffi.typeof("struct double2")
local double2_ops = {}
local double2_mt = {
    __index = double2_ops;
    __len = function(self) return 2 end;
    __tostring = function(self)
        return string.format("double2(%3.3f, %3.3f);", self.data[0], self.data[1])
    end;

    __add = function(self, other) return self:add(other) end;
    __sub = function(self, other) return self:sub(other) end;
    __unm = function(self) return double2(-self.x, -self.y) end;
}
ffi.metatype(double2, double2_mt)

--[[
    return a new vector.
    other - either a scalar, or another vector
]]
function double2_ops.add(self, other)
    if type(other) == "cdata" then
        return double2(self.x+other.x, self.y+other.y)
    elseif tonumber(other) then
        local anum = tonumber(other)
        return double2(self.x+anum, self.y+anum)
    end

    return nil
end

--[[
    return a new vector
    other - either a scalar, or another vector
]]
function double2_ops.sub(self, other)
    if type(other) == "cdata" then
        return double2(self.x-other.x, self.y-other.y)
    elseif tonumber(other) then
        local anum = tonumber(other)
        return double2(self.x-anum, self.y-anum)
    end

    return nil
end


--[[
    double3

]]
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
    __len = function(self) return 3 end;
    __tostring = function(self)
        return string.format("double3(%3.3f, %3.3f, %3.3f);", self.data[0], self.data[1], self.data[2])
    end;

    __add = function(self, other) return self:add(other) end;
    __sub = function(self, other) return self:sub(other) end;
    __unm = function(self) return double3(-self.x, -self.y, -self.z) end;
}
ffi.metatype(double3, double3_mt)


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





return {
    double2 = double2;
    double3 = double3;
}