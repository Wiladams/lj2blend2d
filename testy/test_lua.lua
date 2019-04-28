local ffi = require("ffi")

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


local function test_struct()
    local p1 = Point(10,20)
    local p2 = Point(p1)

    print("p1: ", p1.x, p1.y)
    print("p2: ", p2.x, p2.y)

end

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
    local Drawable = {
        Bounds = {x = 0; y = 0; width = 1; height = 1;};
    }

    function Drawable.new(self, obj)
        obj = obj or {}
        setmetatable(obj, self)
        self.__index = self;
        return obj;
    end

    function Drawable:drawBegin()
    end

    function Drawable:drawBody()
        print("Drawable.drawBody")
    end

    function Drawable:drawEnd()
    end

    function Drawable:draw()
        self:drawBegin()
        self:drawBody()
        self:drawEnd()
    end

    local GRectangle = Drawable:new()
    function GRectangle:drawBody()
        rect(self.Frame.x, self.Frame.y, self.Frame.width, self.Frame.height)
    end

    local aRect = GRectangle:new {Frame = {x=10, y=10, width = 100, height=100}}
    aRect:draw()
end




--test_struct();
--test_array();
test_class();
