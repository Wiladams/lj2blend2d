--[[
// [Blend2D]
// 2D Vector Graphics Powered by a JIT Compiler.
//
// [License]
// ZLIB - See LICENSE.md file in the package.
--]]

if not BLEND2D_BLRANDOM_H then
BLEND2D_BLRANDOM_H = true

local ffi = require("ffi")

require("blend2d.blapi")

ffi.cdef[[
struct BLRandom {
  uint64_t data[2];
};
]]

end -- BLEND2D_BLRANDOM_H
