local vtypes = require("vectypes")
local dvec2 = vtypes.double2

local v1 = dvec2(1,2)
local v2 = dvec2({3,4})

print("v1: ", v1, #v1)
print("v2: ", v2)

local function test_add()
    print("==== test_add ====")

    print("v1 + v2: ", v1+v2)
end

local function test_sub()
    print("==== test_sub ====")
    print("v2 - v1: ", v2-v1)
end

local function test_negative()
    print("==== test_negative ====")
    print("-v1: ", -v1)
end

test_add()
test_sub()
test_negative()
