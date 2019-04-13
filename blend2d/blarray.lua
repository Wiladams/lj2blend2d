--[[
// [Blend2D]
// 2D Vector Graphics Powered by a JIT Compiler.
//
// [License]
// ZLIB - See LICENSE.md file in the package.
--]]

local ffi = require("ffi")

if not BLEND2D_BLARRAY_H then
BLEND2D_BLARRAY_H = true

require("blend2d.blvariant")

--[[
// ============================================================================
// [BLArray - Core]
// ============================================================================
--]]


ffi.cdef[[
//! Array container [C Interface - Impl].
struct BLArrayImpl {
  union {
    struct {
      void* data;
      size_t size;
    };

    BLDataView view;
  };

  size_t capacity;
  volatile size_t refCount;
  uint8_t implType;
  uint8_t implTraits;
  uint16_t memPoolData;
  uint8_t itemSize;
  uint8_t dispatchType;
  uint8_t reserved[2];
};
]]

ffi.cdef[[
//! Array container [C Interface - Core].
struct BLArrayCore {
  BLArrayImpl* impl;
};
]]



end -- BLEND2D_BLARRAY_H
