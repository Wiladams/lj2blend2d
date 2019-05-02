--[[
// [Blend2D]
// 2D Vector Graphics Powered by a JIT Compiler.
//
// [License]
// ZLIB - See LICENSE.md file in the package.
--]]

local ffi = require("ffi")
local C = ffi.C 

if not BLEND2D_BLPATTERN_H then
BLEND2D_BLPATTERN_H = true

local blapi = require("blend2d.blapi")

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


  void* reservedHeader[2];


  volatile size_t refCount;

  uint8_t implType;

  uint8_t implTraits;

  uint16_t memPoolData;


  uint8_t patternType;

  uint8_t extendMode;

  uint8_t matrixType;

  uint8_t reserved[1];


  BLMatrix2D matrix;

  BLRectI area;

  //BL_HAS_TYPED_MEMBERS(BLPatternImpl)
};

//! Pattern [C Interface - Core].
struct BLPatternCore {
  BLPatternImpl* impl;
};
]]


end -- BLEND2D_BLPATTERN_H
