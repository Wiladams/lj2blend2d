--[[
// [Blend2D]
// 2D Vector Graphics Powered by a JIT Compiler.
//
// [License]
// ZLIB - See LICENSE.md file in the package.
--]]

local ffi = require("ffi")

if not BLEND2D_BLREGION_H then
BLEND2D_BLREGION_H = true

require("blend2d.blarray")
require("blend2d.blgeometry")
require("blend2d.blvariant")


ffi.cdef[[
//! Region type.
enum  BLRegionType {
  BL_REGION_TYPE_EMPTY = 0,
  BL_REGION_TYPE_RECT = 1,
  BL_REGION_TYPE_COMPLEX = 2,
  BL_REGION_TYPE_COUNT = 3
};
]]


ffi.cdef[[
//! 2D region [C Interface - Impl].
struct BLRegionImpl {
  //! Union of either raw `data` & `size` members or their `view`.
  union {
    struct {
      //! Region data (Y/X sorted rectangles).
      BLBoxI* data;
      //! Region size (count of rectangles in the region).
      size_t size;
    };
    //! Region data and size as `BLRegionView`.
    BLRegionView view;
  };

  //! Region capacity (rectangles).
  size_t capacity;

  //! Reference count.
  volatile size_t refCount;
  //! Impl type.
  uint8_t implType;
  //! Impl traits.
  uint8_t implTraits;
  //! Memory pool data.
  uint16_t memPoolData;

  //! Reserved, must be zero.
  uint8_t reserved[4];
  //! Bounding box, empty regions have [0, 0, 0, 0].
  BLBoxI boundingBox;
};
]]

ffi.cdef[[
//! 2D region [C Interface - Core].
struct BLRegionCore {
  BLRegionImpl* impl;
};
]]

end -- BLEND2D_BLREGION_H
