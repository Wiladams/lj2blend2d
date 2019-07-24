package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 

local blarray = require("blend2d.blarray")

local function test_append()
    local arr = blarray(C.BL_IMPL_TYPE_ARRAY_U8);
    arr:appendU8(10)
end

test_append();