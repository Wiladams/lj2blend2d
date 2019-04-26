--[[
// [Blend2D]
// 2D Vector Graphics Powered by a JIT Compiler.
//
// [License]
// ZLIB - See LICENSE.md file in the package.
--]]

local ffi = require("ffi")
local C = ffi.C 

if not BLEND2D_BLFONT_H then
BLEND2D_BLFONT_H = true

local blapi = require("blend2d.blapi")

require("blend2d.blarray")
require("blend2d.blfontdefs")
require("blend2d.blgeometry")
require("blend2d.blglyphbuffer")
require("blend2d.blpath")
require("blend2d.blstring")
require("blend2d.blvariant")


ffi.cdef[[
//! Font data [C Interface - Virtual Function Table].
struct BLFontDataVirt {
  BLResult (__cdecl* destroy)(BLFontDataImpl* impl) ;
  BLResult (__cdecl* listTags)(const BLFontDataImpl* impl, BLArrayCore* out) ;
  size_t (__cdecl* queryTables)(const BLFontDataImpl* impl, BLFontTable* dst, const BLTag* tags, size_t n) ;
};
]]

ffi.cdef[[
//! Font data [C Interface - Impl].
struct BLFontDataImpl {

  const BLFontDataVirt* virt;

  void* data;

  size_t size;


  volatile size_t refCount;

  uint8_t implType;

  uint8_t implTraits;

  uint16_t memPoolData;

  uint32_t flags;
};
]]

ffi.cdef[[
//! Font data [C Interface - Core].
struct BLFontDataCore {
  BLFontDataImpl* impl;
};
]]

ffi.cdef[[
//! Font loader [C Interface - Virtual Function Table].
struct BLFontLoaderVirt {
  BLResult (__cdecl* destroy)(BLFontLoaderImpl* impl) ;
  BLFontDataImpl* (__cdecl* dataByFaceIndex)(BLFontLoaderImpl* impl, uint32_t faceIndex) ;
};

//! Font loader [C Interface - Impl].
struct BLFontLoaderImpl {
  //! Virtual function table.
  const BLFontLoaderVirt* virt;
  //! Pointer to the start of font-data (null if the data is provided at table level).
  void* data;
  //! Size of `data` [in bytes] (zero if the data is provided at table level).
  size_t size;

  //! Reference count.
   size_t refCount;
  //! Impl type.
  uint8_t implType;
  //! Impl traits.
  uint8_t implTraits;
  //! Memory pool data.
  uint16_t memPoolData;

  uint8_t faceType;
  uint32_t faceCount;
  uint32_t loaderFlags;
};

//! Font loader [C Interface - Core].
struct BLFontLoaderCore {
  BLFontLoaderImpl* impl;
};
]]

BLFontLoader = ffi.typeof("struct BLFontLoaderCore")
BLFontLoader_mt = {
  __gc = function(self)
    blapi.blFontLoaderReset(self);
  end;

  __index = {
    -- Meant to be called as: BLFontLoader:createFromFile(filename)
    createFromFile = function(ct, filename)
      local obj = ffi.new(ct);
      local bResult = blapi.blFontLoaderInit(obj);
      if bResult ~= C.BL_SUCCESS then
        return nil, bResult
      end

      bResult = blapi.blFontLoaderCreateFromFile(obj, filename)
      if bResult ~= C.BL_SUCCESS then
        return nil, bResult
      end

      return obj;
    end;

    dataByIndex = function(self, faceIndex)
      --BLFontDataImpl* __cdecl blFontLoaderDataByFaceIndex(BLFontLoaderCore* self, uint32_t faceIndex) ;
      local impl = blapi.blFontLoaderDataByFaceIndex(self, faceIndex) ;

    end;
  };
}
ffi.metatype(BLFontLoader, BLFontLoader_mt)

--[[
BLResult __cdecl blFontLoaderAssignMove(BLFontLoaderCore* self, BLFontLoaderCore* other) ;
BLResult __cdecl blFontLoaderAssignWeak(BLFontLoaderCore* self, const BLFontLoaderCore* other) ;
bool     __cdecl blFontLoaderEquals(const BLFontLoaderCore* a, const BLFontLoaderCore* b) ;
BLResult __cdecl blFontLoaderCreateFromDataArray(BLFontLoaderCore* self, const BLArrayCore* dataArray) ;
BLResult __cdecl blFontLoaderCreateFromData(BLFontLoaderCore* self, const void* data, size_t size, BLDestroyImplFunc destroyFunc, void* destroyData) ;
BLFontDataImpl* __cdecl blFontLoaderDataByFaceIndex(BLFontLoaderCore* self, uint32_t faceIndex) ;
--]]


ffi.cdef[[
//! Font face [C Interface - Virtual Function Table].
struct BLFontFaceVirt {
  BLResult (__cdecl* destroy)(BLFontFaceImpl* impl) ;
};
]]

ffi.cdef[[
//! Font face [C Interface - Impl].
struct BLFontFaceImpl {
  //! Virtual function table.
  const BLFontFaceVirt* virt;
  //! Font data.
  //BL_TYPED_MEMBER(BLFontDataCore, BLFontData, data);
  union { BLFontDataCore data; };

  //! Font loader used to load `BLFontData`.
  //BL_TYPED_MEMBER(BLFontLoaderCore, BLFontLoader, loader);
  union { BLFontLoaderCore loader; };

  //! Reference count.
  volatile size_t refCount;
  //! Impl type.
  uint8_t implType;
  //! Impl traits.
  uint8_t implTraits;
  //! Memory pool data.
  uint16_t memPoolData;

  //! Font-face default weight (1..1000) [0 if font-face is not initialized].
  uint16_t weight;
  //! Font-face default stretch (1..9) [0 if font-face is not initialized].
  uint8_t stretch;
  //! Font-face default style.
  uint8_t style;

  //! Font-face information.
  BLFontFaceInfo faceInfo;

  //! Unique face id assigned by Blend2D for caching.
  uint64_t faceUniqueId;

  //! Full name.
  //BL_TYPED_MEMBER(BLStringCore, BLString, fullName);
  union { BLStringCore fullName; };

  //! Family name.
  //BL_TYPED_MEMBER(BLStringCore, BLString, familyName);
  union { BLStringCore familyName; };

  //! Subfamily name.
  //BL_TYPED_MEMBER(BLStringCore, BLString, subfamilyName);
  union { BLStringCore subfamilyName; };

  //! PostScript name.
  //BL_TYPED_MEMBER(BLStringCore, BLString, postScriptName);
  union { BLStringCore postScriptName; };

  //! Font-face metrics in design units.
  BLFontDesignMetrics designMetrics;
  //! Font-face unicode coverage (specified in OS/2 header).
  BLFontUnicodeCoverage unicodeCoverage;
  //! Font-face panose classification.
  BLFontPanose panose;

};
]]

ffi.cdef[[
//! Font face [C Interface - Core].
struct BLFontFaceCore {
  BLFontFaceImpl* impl;
};
]]
BLFontFace = ffi.typeof("struct BLFontFaceCore")
BLFontFaceCore = BLFontFace;
BLFontFace_mt = {
    __gc = function(self)
        local bResult = blapi.blFontFaceReset(self);
        return bResult == C.BL_SUCCESS;
    end;

    __new = function(ct, ...)
        print("BLFontFace.__new")
        local obj = ffi.new(ct)
        local bResult = blapi.blFontFaceInit(obj)
        if bResult ~= C.BL_SUCCESS then
            return false, "failed blFontFaceInit"
        end
        return obj;
    end;

    __index = {
        -- Use as; BLFontFace:createFromFile(filename)
        createFromFile = function(ct, fileName)
            --print("BLFontFace.createFromFile: ", ct, fileName)
            local obj = ffi.new(ct)

            local bResult = blapi.blFontFaceInit(obj)
            if bResult ~= C.BL_SUCCESS then
                return nil, "failed blFontFaceInit"
            end

            local bResult = blapi.blFontFaceCreateFromFile(obj, fileName) ;
            --print("blFontFaceCreateFromFile: ", bResult)

            if bResult ~= C.BL_SUCCESS then
              return nil, bResult 
            end

            return obj;
        end;

        -- Use like this
        -- fontFace:createSizedFont(15)
        createFont = function(self, size)
            if not tonumber(size) then
              return false, "size must be a number"
            end

            local font, err = BLFont();
            if not font then
              return nil, err 
            end

            local bResult = blapi.blFontCreateFromFace(font, self, size) ;
            if bResult ~= C.BL_SUCCESS then
              return false;
            end

            return font;
        end;
    }
}
ffi.metatype(BLFontFace, BLFontFace_mt)

ffi.cdef[[

//! Font [C Interface - Impl].
struct BLFontImpl {
  //! Font-face used by this font.
  //BL_TYPED_MEMBER(BLFontFaceCore, BLFontFace, face);
  union { BLFontFaceCore face;};

  //! Font features.
  //BL_TYPED_MEMBER(BLArrayCore, BLArray<BLFontFeature>, features);
  union { BLArrayCore features;};

  //! Font variations.
  //BL_TYPED_MEMBER(BLArrayCore, BLArray<BLFontVariation>, variations);
  union { BLArrayCore variations;};

  //! Reference count.
   size_t refCount;
  //! Impl type.
  uint8_t implType;
  //! Impl traits.
  uint8_t implTraits;
  //! Memory pool data.
  uint16_t memPoolData;


  uint16_t weight;

  uint8_t stretch;

  uint8_t style;

  BLFontMetrics metrics;
  BLFontMatrix matrix;
};

struct BLFontCore {
  BLFontImpl* impl;
};
]]
BLFont = ffi.typeof("struct BLFontCore")
BLFontCore = BLFont
BLFont_mt = {
    __gc = function(self)
        local bResult = blapi.blFontReset(self)
        return bResult == C.BL_SUCCESS or bResult;
    end;

    __new = function(ct, ...)
        local obj = ffi.new(ct)
        local bResult = blapi.blFontInit(obj)
        if bResult ~= C.BL_SUCCESS then
            return false, "error initializing font"
        end

        return obj
    end;

    __index = {
        getTextMetrics = function(self, glyphBuff, metrics)
            metrics = metrics or BLTextMetrics();
            local bResult = blapi.blFontGetTextMetrics(self, glyphBuff, metrics) ;
            if bResult ~= C.BL_SUCCESS then
              return false, bResult;
            end

            return metrics;
        end;

        shape = function(self, gbuff)
            local bResult = blapi.blFontShape(self, gbuff) ;
            if bResult ~= C.BL_SUCCESS then
                return false, bResult
            end

            return true;
        end;

        measureText = function(self, txt)
            local gbuff = BLGlyphBuffer()
            --local metrics = BLTextMetrics()

            gbuff:setText(txt)
            self:shape(gbuff)

            local metrics, err = self:getTextMetrics(gbuff)

            if not metrics then
              return false, err;
            end

            local cx = metrics.boundingBox.x1 - metrics.boundingBox.x0;
            local cy = self.impl.metrics.size;

            return cx, cy
        end;


    }
--[[

BLResult __cdecl blFontAssignMove(BLFontCore* self, BLFontCore* other) ;
BLResult __cdecl blFontAssignWeak(BLFontCore* self, const BLFontCore* other) ;
bool     __cdecl blFontEquals(const BLFontCore* a, const BLFontCore* b) ;
BLResult __cdecl blFontCreateFromFace(BLFontCore* self, const BLFontFaceCore* face, float size) ;
BLResult __cdecl blFontShape(const BLFontCore* self, BLGlyphBufferCore* buf) ;
BLResult __cdecl blFontMapTextToGlyphs(const BLFontCore* self, BLGlyphBufferCore* buf, BLGlyphMappingState* stateOut) ;
BLResult __cdecl blFontPositionGlyphs(const BLFontCore* self, BLGlyphBufferCore* buf, uint32_t positioningFlags) ;
BLResult __cdecl blFontApplyKerning(const BLFontCore* self, BLGlyphBufferCore* buf) ;
BLResult __cdecl blFontApplyGSub(const BLFontCore* self, BLGlyphBufferCore* buf, size_t index, BLBitWord lookups) ;
BLResult __cdecl blFontApplyGPos(const BLFontCore* self, BLGlyphBufferCore* buf, size_t index, BLBitWord lookups) ;
BLResult __cdecl blFontGetMatrix(const BLFontCore* self, BLFontMatrix* out) ;
BLResult __cdecl blFontGetMetrics(const BLFontCore* self, BLFontMetrics* out) ;
BLResult __cdecl blFontGetDesignMetrics(const BLFontCore* self, BLFontDesignMetrics* out) ;
BLResult __cdecl blFontGetTextMetrics(const BLFontCore* self, BLGlyphBufferCore* buf, BLTextMetrics* out) ;
BLResult __cdecl blFontGetGlyphBounds(const BLFontCore* self, const void* glyphIdData, intptr_t glyphIdAdvance, BLBoxI* out, size_t count) ;
BLResult __cdecl blFontGetGlyphAdvances(const BLFontCore* self, const void* glyphIdData, intptr_t glyphIdAdvance, BLGlyphPlacement* out, size_t count) ;
BLResult __cdecl blFontGetGlyphOutlines(const BLFontCore* self, uint32_t glyphId, const BLMatrix2D* userMatrix, BLPathCore* out, BLPathSinkFunc sink, void* closure) ;
BLResult __cdecl blFontGetGlyphRunOutlines(const BLFontCore* self, const BLGlyphRun* glyphRun, const BLMatrix2D* userMatrix, BLPathCore* out, BLPathSinkFunc sink, void* closure) ;

]]
}
ffi.metatype(BLFont, BLFont_mt)

end -- BLEND2D_BLFONT_H
