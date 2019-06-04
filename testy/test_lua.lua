local ffi = require("ffi")

local GraphicGroup = require("GraphicGroup")

ffi.cdef[[
struct Point {
    double x;
    double y;
}
]]
Point = ffi.typeof("struct Point")

local function test_string()
local S = "AB"

print(S[1])
print(string.sub(S,1,1))
print(string.sub(S,2,2))
end

--[[
    Checking to see if a basic copy constructor works 
    it should
]]
local function test_struct()
    local p1 = Point(10,20)
    local p2 = Point(p1)

    print("p1: ", p1.x, p1.y)
    print("p2: ", p2.x, p2.y)

end

-- check to see if parameterized array can be
-- constructed and initialized
local function test_array()
    local pts = {
        {200; 320};
        {80; 160};
        {220; 200};
        {300; 40};
        {380; 200};
        {520; 160};
        {400; 320};
    }

    local npts = #pts
    local apts = ffi.new("struct Point[?]", npts,pts)

    for i=0, npts-1 do
        print(apts[i].x, apts[i].y)
    end

end

local function test_class()
    local SubGroup = GraphicGroup:new()

    function SubGroup.new(self, obj)
        local obj = GraphicGroup:new(obj)

        setmetatable(obj, self)
        self.__index = self;
    
        return obj;
    end

    local s1 = SubGroup:new({frame={x=10,y=10,w=100,h=100}})
    local s2 = SubGroup:new({frame={x=20,y=20,w=200,h=200}})

    print("s1: ", s1.frame.x, s1.frame.y)
    print("s2: ", s2.frame.x, s2.frame.y)
end


local function test_logarithm()
    local e = 2.718281828459;

    log = math.log10
    
    -- values range from 0.0 to 1.0
    for i=1, 10, 0.1 do
        local idx = i
        print(idx, log(idx))
    end
end


--test_struct();
--test_array();
--test_class();
test_logarithm()
