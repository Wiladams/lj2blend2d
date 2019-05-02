--[[
// [Blend2D]
// 2D Vector Graphics Powered by a JIT Compiler.
//
// [License]
// ZLIB - See LICENSE.md file in the package.
--]]

local ffi = require("ffi")
local C = ffi.C 

if not BLEND2D_BLGLYPHBUFFER_H then
BLEND2D_BLGLYPHBUFFER_H = true

require("blend2d.blfontdefs")
local blapi = require("blend2d.blapi")

ffi.cdef[[
//! Glyph buffer [C Data].
struct BLGlyphBufferData {
  union {
    struct {
      //! Glyph item data.
      BLGlyphItem* glyphItemData;
      //! Glyph placement data.
      BLGlyphPlacement* placementData;
      //! Number of either code points or glyph indexes in the glyph-buffer.
      size_t size;
      //! Reserved, used exclusively by BLGlyphRun.
      uint32_t reserved;
      //! Flags shared between BLGlyphRun and BLGlyphBuffer.
      uint32_t flags;
    };

    //! Glyph run data that can be passed directly to the rendering context.
    BLGlyphRun glyphRun;
  };

  //! Glyph info data - additional information of each `BLGlyphItem`.
  BLGlyphInfo* glyphInfoData;
};

//! Glyph buffer [C Interface - Core].
struct BLGlyphBufferCore {
  BLGlyphBufferData* data;
};
]]


end -- BLEND2D_BLGLYPHBUFFER_H
