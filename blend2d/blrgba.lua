--[[
// [Blend2D]
// 2D Vector Graphics Powered by a JIT Compiler.
//
// [License]
// ZLIB - See LICENSE.md file in the package.
--]]

local ffi = require("ffi")

if not BLEND2D_BLRGBA_H then
BLEND2D_BLRGBA_H = true

require("blend2d.blapi")

--! 32-bit RGBA color (8-bit per component) stored as `0xAARRGGBB`.
if BL_BUILD_BYTE_ORDER == 1234 then     -- little endian
ffi.cdef[[
//! 32-bit RGBA color (8-bit per component) stored as `0xAARRGGBB`.
struct BLRgba32 {
  union {
    uint32_t value;
    struct {
      uint32_t b : 8;
      uint32_t g : 8;
      uint32_t r : 8;
      uint32_t a : 8;
    };
  };
};
]]
else
ffi.cdef[[
struct BLRgba32 {
    union {
        uint32_t value;
        struct {
            uint32_t a : 8;
            uint32_t r : 8;
            uint32_t g : 8;
            uint32_t b : 8;
        };
    };
};
]]
end
BLRgba32 = ffi.typeof("struct BLRgba32")

--! 64-bit RGBA color (16-bit per component) stored as `0xAAAARRRRGGGGBBBB`.
if BL_BUILD_BYTE_ORDER == 1234 then     -- little endian
ffi.cdef[[
struct BLRgba64 {
  union {
    uint64_t value;
    struct {
      uint32_t b : 16;
      uint32_t g : 16;
      uint32_t r : 16;
      uint32_t a : 16;
    };
  };
};
]]
else
ffi.cdef[[
struct BLRgba64 {
  union {
    uint64_t value;
    struct {
      uint32_t a : 16;
      uint32_t r : 16;
      uint32_t g : 16;
      uint32_t b : 16;
    };
  };
};
]]
end

--! 128-bit RGBA color stored as 4 32-bit floating point values in [RGBA] order.
ffi.cdef[[
struct BLRgba128 {
  float r;
  float g;
  float b;
  float a;
};
]]

end -- BLEND2D_BLRGBA_H
