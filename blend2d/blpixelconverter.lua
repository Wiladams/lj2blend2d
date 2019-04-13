--[[
// [Blend2D]
// 2D Vector Graphics Powered by a JIT Compiler.
//
// [License]
// ZLIB - See LICENSE.md file in the package.
--]]

local ffi = require("ffi")

if not BLEND2D_BLPIXELCONVERTER_H then
BLEND2D_BLPIXELCONVERTER_H = true

require("blend2d.blapi")
require("blend2d.blformat")
require("blend2d.blgeometry")


ffi.cdef[[
//! \cond INTERNAL
//! \ingroup  blend2d_internal
//! Pixel converter function.
typedef BLResult (__cdecl * BLPixelConverterFunc)(
  const BLPixelConverterCore* self,
  uint8_t* dstData, intptr_t dstStride,
  const uint8_t* srcData, intptr_t srcStride,
  uint32_t w, uint32_t h, const BLPixelConverterOptions* options) ;
//! \endcond
]]


ffi.cdef[[
//! Pixel conversion options.
struct BLPixelConverterOptions {
  BLPointI origin;
  size_t gap;
};
]]


ffi.cdef[[
//! Pixel converter [C Interface - Core].
struct BLPixelConverterCore {
  //! Converter function.
  BLPixelConverterFunc convertFunc;

  union {
    uint8_t strategy;
    //! Internal data used by the pixel converter not exposed to users.
    uint8_t data[64];
  };
};
]]

end -- BLEND2D_BLPIXELCONVERTER_H
