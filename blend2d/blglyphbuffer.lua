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

BLGlyphBuffer = ffi.typeof("struct BLGlyphBufferCore")
local BLGlyphBuffer_mt = {
    __gc = function(self)
        blapi.blGlyphBufferReset(self)
    end;

    __new = function(ct, ...)
        local obj = ffi.new(ct)
        local bResult = blapi.blGlyphBufferInit(obj)
        if bResult ~= C.BL_SUCCESS then
          return false, bResult;
        end

        return obj;
    end;

    __index = {
        clear = function(self)
            local bResult = blapi.blGlyphBufferClear(self);
            if bResult ~= C.BL_SUCCESS then 
                return false, bResult;
            end

            return true;
        end;

        setText = function(self, txt, encoding)
            encoding = encoding or C.BL_TEXT_ENCODING_UTF8
            local bResult = blapi.blGlyphBufferSetText(self, ffi.cast("const void*",txt), #txt, encoding)
        end;



        glyphPlacements = function(self)
            local function iter()
                for i=0, self.data.size do
                    coroutine.yield(self.data.placementData[i])
                end
            end

            return coroutine.wrap(iter)
        end;

        textAdvance = function(self)
            local cx = 0;
            for placement in self:glyphPlacements() do
              cx = cx + (placement.advance.x/64);
            end

            return cx
        end;
    };
}
ffi.metatype(BLGlyphBuffer, BLGlyphBuffer_mt)

--[[
BLResult __cdecl blGlyphBufferSetGlyphIds(BLGlyphBufferCore* self, const void* data, intptr_t advance, size_t size) ;
]]
end -- BLEND2D_BLGLYPHBUFFER_H
