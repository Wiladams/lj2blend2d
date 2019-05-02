--[[
// [Blend2D]
// 2D Vector Graphics Powered by a JIT Compiler.
//
// [License]
// ZLIB - See LICENSE.md file in the package.
--]]

local ffi = require("ffi")



local blapi = require("blend2d.blapi")

ffi.cdef[[
struct BLRandom {
  uint64_t data[2];
};
]]



return BLRandom
