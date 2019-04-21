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

--test_struct();
test_array();