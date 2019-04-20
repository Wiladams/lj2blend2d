local ffi = require("ffi")

ffi.cdef[[
struct Point {
    int x;
    int y;
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


test_struct();