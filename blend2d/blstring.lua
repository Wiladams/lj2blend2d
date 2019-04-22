--[[
// [Blend2D]
// 2D Vector Graphics Powered by a JIT Compiler.
//
// [License]
// ZLIB - See LICENSE.md file in the package.
--]]

local ffi = require("ffi")

if not BLEND2D_BLSTRING_H then
BLEND2D_BLSTRING_H = true

require("blend2d.blvariant")


ffi.cdef[[
// ============================================================================
// [BLString - Core]
// ============================================================================

//! Byte string [C Interface - Impl].
struct BLStringImpl {
  union {
    struct {
      //! String data [null terminated].
      char* data;
      //! String size [in bytes].
      size_t size;
    };
    //! String data and size as `BLStringView`.
    BLStringView view;
  };
  //! String capacity [in bytes].
  size_t capacity;

  //! Reference count.
  volatile size_t refCount;
  //! Impl type.
  uint8_t implType;
  //! Impl traits.
  uint8_t implTraits;
  //! Memory pool data.
  uint16_t memPoolData;

  //! Reserved, will be part of string data.
  uint8_t reserved[4];
};

//! Byte string [C Interface - Core].
struct BLStringCore {
  BLStringImpl* impl;
};
]]
BLString = ffi.typeof("struct BLStringCore")
ffi.metatype(BLString, {
  -- make easy conversion using tostring()
  __tostring = function(self)
    return ffi.string(self.impl.data, self.impl.size)
  end;
})

end -- BLEND2D_BLSTRING_H
