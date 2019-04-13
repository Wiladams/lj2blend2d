--[[
// [Blend2D]
// 2D Vector Graphics Powered by a JIT Compiler.
//
// [License]
// ZLIB - See LICENSE.md file in the package.
--]]

local ffi = require("ffi")

if not BLEND2D_BLPATTERN_H then
BLEND2D_BLPATTERN_H = true

require("blend2d.blgeometry")
require("blend2d.blimage")
require("blend2d.blmatrix")
require("blend2d.blvariant")


ffi.cdef[[
//! Pattern [C Interface - Impl].
struct BLPatternImpl {
  //! Image used by the pattern.
  //BL_TYPED_MEMBER(BLImageCore, BLImage, image);
  union {BLImageCore image;};

  //! Reserved, must be null.
  void* reservedHeader[2];

  //! Reference count.
  volatile size_t refCount;
  //! Impl type.
  uint8_t implType;
  //! Impl traits.
  uint8_t implTraits;
  //! Memory pool data.
  uint16_t memPoolData;

  //! Reserved, must be zero.
  uint8_t patternType;
  //! Pattern extend mode, see `BLExtendMode`.
  uint8_t extendMode;
  //! Type of the transformation matrix.
  uint8_t matrixType;
  //! Reserved, must be zero.
  uint8_t reserved[1];

  //! Pattern transformation matrix.
  BLMatrix2D matrix;
  //! Image area to use.
  BLRectI area;

  //BL_HAS_TYPED_MEMBERS(BLPatternImpl)
};

//! Pattern [C Interface - Core].
struct BLPatternCore {
  BLPatternImpl* impl;
};
]]


end -- BLEND2D_BLPATTERN_H
