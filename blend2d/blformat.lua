--[[
// [Blend2D]
// 2D Vector Graphics Powered by a JIT Compiler.
//
// [License]
// ZLIB - See LICENSE.md file in the package.
--]]

local ffi = require("ffi")

if not BLEND2D_BLFORMAT_H then
BLEND2D_BLFORMAT_H = true

require("blend2d.blapi")

ffi.cdef[[
enum BLFormat {

  BL_FORMAT_NONE = 0,
  BL_FORMAT_PRGB32 = 1,
  BL_FORMAT_XRGB32 = 2,
  BL_FORMAT_A8 = 3,


  BL_FORMAT_COUNT = 4,

  BL_FORMAT_RESERVED_COUNT = 8
};
]]

ffi.cdef[[
//! Pixel format flags.
enum BLFormatFlags {
  //! Pixel format provides RGB components.
  BL_FORMAT_FLAG_RGB = 0x00000001u,
  //! Pixel format provides only alpha component.
  BL_FORMAT_FLAG_ALPHA = 0x00000002u,
  //! A combination of `BL_FORMAT_FLAG_RGB | BL_FORMAT_FLAG_ALPHA`.
  BL_FORMAT_FLAG_RGBA = 0x00000003u,
  //! Pixel format provides LUM component (and not RGB components).
  BL_FORMAT_FLAG_LUM = 0x00000004u,
  //! A combination of `BL_FORMAT_FLAG_LUM | BL_FORMAT_FLAG_ALPHA`.
  BL_FORMAT_FLAG_LUMA = 0x00000006u,
  //! Indexed pixel format the requres a palette (I/O only).
  BL_FORMAT_FLAG_INDEXED = 0x00000010u,
  //! RGB components are premultiplied by alpha component.
  BL_FORMAT_FLAG_PREMULTIPLIED = 0x00000100u,
  //! Pixel format doesn't use native byte-order (I/O only).
  BL_FORMAT_FLAG_BYTE_SWAP = 0x00000200u,

  // The following flags are only informative. They are part of `blFormatInfo[]`,
  // but doesn't have to be passed to `BLPixelConverter` as they can be easily
  // calculated.

  //! Pixel components are byte aligned (all 8bpp).
  BL_FORMAT_FLAG_BYTE_ALIGNED = 0x00010000u
};
]]

ffi.cdef[[
// ============================================================================
// [BLFormatInfo]
// ============================================================================

//! Provides a detailed information about a pixel format. Use `blFormatInfo`
//! array to get an information of Blend2D native pixel formats.
struct BLFormatInfo {
  uint32_t depth;
  uint32_t flags;

  union {
    struct {
      uint8_t sizes[4];
      uint8_t shifts[4];
    };

    struct {
      uint8_t rSize;
      uint8_t gSize;
      uint8_t bSize;
      uint8_t aSize;

      uint8_t rShift;
      uint8_t gShift;
      uint8_t bShift;
      uint8_t aShift;
    };

    const BLRgba32* palette;
  };

};
]]

--[[
//! Pixel format information of Blend2D native pixel formats, see `BLFormat`.
BL_API_C const BLFormatInfo blFormatInfo[BL_FORMAT_RESERVED_COUNT];
--]]

end -- BLEND2D_BLFORMAT_H
