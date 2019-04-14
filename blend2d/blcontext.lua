--[[
// [Blend2D]
// 2D Vector Graphics Powered by a JIT Compiler.
//
// [License]
// ZLIB - See LICENSE.md file in the package.
--]]

local ffi = require("ffi")

if not BLEND2D_BLCONTEXT_H then
BLEND2D_BLCONTEXT_H = true

local blapi = require("blend2d.blapi")

require("blend2d.blfont");
require("blend2d.blgeometry");
require("blend2d.blimage");
require("blend2d.blmatrix");
require("blend2d.blpath");
require("blend2d.blrgba");
require("blend2d.blregion");
require("blend2d.blvariant");


ffi.cdef[[
//! Rendering context type.
enum BLContextType {
  BL_CONTEXT_TYPE_NONE = 0,
  BL_CONTEXT_TYPE_DUMMY = 1,
  BL_CONTEXT_TYPE_RASTER = 2,
  BL_CONTEXT_TYPE_RASTER_ASYNC = 3,

  BL_CONTEXT_TYPE_COUNT = 4
};

//! Rendering context hint.
enum BLContextHint {
  BL_CONTEXT_HINT_RENDERING_QUALITY = 0,
  BL_CONTEXT_HINT_GRADIENT_QUALITY = 1,
  BL_CONTEXT_HINT_PATTERN_QUALITY = 2,

  BL_CONTEXT_HINT_COUNT = 8
};

//! Describes a rendering operation type - fill or stroke.
//!
//! The rendering context allows to get and set fill & stroke options directly
//! or via "op" functions that take the rendering operation type and dispatch
//! to the right function.
enum BLContextOpType {
  BL_CONTEXT_OP_TYPE_FILL = 0,
  BL_CONTEXT_OP_TYPE_STROKE = 1,

  BL_CONTEXT_OP_TYPE_COUNT = 2
};

//! Rendering context flush-flags, use with `BLContext::flush()`.
enum BLContextFlushFlags {
  BL_CONTEXT_FLUSH_SYNC = 0x80000000u
};


enum BLContextCreateFlags {
  BL_CONTEXT_CREATE_FLAG_ISOLATED_RUNTIME = 0x10000000u,
  BL_CONTEXT_CREATE_FLAG_OVERRIDE_FEATURES = 0x20000000u
};

//! Clip operation.
enum BLClipOp {
  BL_CLIP_OP_REPLACE = 0,
  BL_CLIP_OP_INTERSECT = 1,

  BL_CLIP_OP_COUNT = 2
};

//! Clip mode.
enum BLClipMode {
  BL_CLIP_MODE_ALIGNED_RECT = 0,
  BL_CLIP_MODE_UNALIGNED_RECT = 1,
  BL_CLIP_MODE_MASK = 2,

  BL_CLIP_MODE_COUNT = 3
};

//! Composition & blending operator.
enum BLCompOp {
  BL_COMP_OP_SRC_OVER = 0,
  BL_COMP_OP_SRC_COPY = 1,
  BL_COMP_OP_SRC_IN = 2,
  BL_COMP_OP_SRC_OUT = 3,
  BL_COMP_OP_SRC_ATOP = 4,
  BL_COMP_OP_DST_OVER = 5,
  BL_COMP_OP_DST_COPY = 6,
  BL_COMP_OP_DST_IN = 7,
  BL_COMP_OP_DST_OUT = 8,
  BL_COMP_OP_DST_ATOP = 9,
  BL_COMP_OP_XOR = 10,
  BL_COMP_OP_CLEAR = 11,
  BL_COMP_OP_PLUS = 12,
  BL_COMP_OP_MINUS = 13,
  BL_COMP_OP_MULTIPLY = 14,
  BL_COMP_OP_SCREEN = 15,
  BL_COMP_OP_OVERLAY = 16,
  BL_COMP_OP_DARKEN = 17,
  BL_COMP_OP_LIGHTEN = 18,
  BL_COMP_OP_COLOR_DODGE = 19,
  BL_COMP_OP_COLOR_BURN = 20,
  BL_COMP_OP_LINEAR_BURN = 21,
  BL_COMP_OP_LINEAR_LIGHT = 22,
  BL_COMP_OP_PIN_LIGHT = 23,
  BL_COMP_OP_HARD_LIGHT = 24,
  BL_COMP_OP_SOFT_LIGHT = 25,
  BL_COMP_OP_DIFFERENCE = 26,
  BL_COMP_OP_EXCLUSION = 27,

  BL_COMP_OP_COUNT = 28
};

//! Gradient rendering quality.
enum BLGradientQuality {
  BL_GRADIENT_QUALITY_NEAREST = 0,
  BL_GRADIENT_QUALITY_COUNT = 1
};

//! Pattern quality.
enum BLPatternQuality {
  BL_PATTERN_QUALITY_NEAREST = 0,
  BL_PATTERN_QUALITY_BILINEAR = 1,
  BL_PATTERN_QUALITY_COUNT = 2
};

//! Rendering quality.
enum BLRenderingQuality {
  BL_RENDERING_QUALITY_ANTIALIAS = 0,
  BL_RENDERING_QUALITY_COUNT = 1
};
]]

ffi.cdef[[
// ============================================================================
// [BLContext - CreateOptions]
// ============================================================================

//! Information that can be used to customize the rendering context.
struct BLContextCreateOptions {
  uint32_t flags;
  uint32_t cpuFeatures;
};

// ============================================================================
// [BLContext - Cookie]
// ============================================================================

//! Holds an arbitrary 128-bit value (cookie) that can be used to match other
//! cookies. Blend2D uses cookies in places where it allows to "lock" some
//! state that can only be unlocked by a matching cookie. Please don't confuse
//! cookies with a security of any kind, it's just an arbitrary data that must
//! match to proceed with a certain operation.
//!
//! Cookies can be used with `BLContext::save()` and `BLContext::restore()`
//! functions
struct BLContextCookie {
  uint64_t data[2];
};


//! Rendering context hints.
struct BLContextHints {
  union {
    struct {
      uint8_t renderingQuality;
      uint8_t gradientQuality;
      uint8_t patternQuality;
    };

    uint8_t hints[BL_CONTEXT_HINT_COUNT];
  };
};
]]

ffi.cdef[[
// ============================================================================
// [BLContext - State]
// ============================================================================

//! Rendering context state.
//!
//! This state is not meant to be created by users, it's only provided so users
//! can access it inline and possibly inspect it.
struct BLContextState {
  union {
    //! Current context hints.
    BLContextHints hints;
    //! Flattened `BLContextHints` struct so the members can be accessed directly.
    struct {
      uint8_t renderingQuality;
      uint8_t gradientQuality;
      uint8_t patternQuality;
    };
  };

  //! Current composition operator.
  uint8_t compOp;
  //! Current fill rule.
  uint8_t fillRule;

  //! Either `opStyleType` or decomposed `fillStyleType` and `strokeStyleType`.
  union {
    //! Current type of a style for fill and stroke operations.
    uint8_t opStyleType[2];
    //! Flattened `opStyleType[]` so the members can be accessed directly.
    struct {
      //! Current type of a style for fill operations.
      uint8_t fillStyleType;
      //! Current type of a style for stroke operations.
      uint8_t strokeStyleType;
    };
  };

  //! Reserved for future use, must be zero.
  uint8_t reserved[4];

  //! Approximation options.
  BLApproximationOptions approximationOptions;

  //! Current global alpha value [0, 1].
  double globalAlpha;
  //! Either opAlpha[] array of decomposed `fillAlpha` and `strokeAlpha`.
  union {
    //! Current fill or stroke alpha by slot type.
    double opAlpha[2];
    //! Flattened `opAlpha[]` so the members can be accessed directly.
    struct {
      //! Current fill alpha value [0, 1].
      double fillAlpha;
      //! Current stroke alpha value [0, 1].
      double strokeAlpha;
    };
  };

  //! Current stroke options.
  //BL_TYPED_MEMBER(BLStrokeOptionsCore, BLStrokeOptions, strokeOptions);
  union { BLStrokeOptionsCore, strokeOptions; };

  //! Current meta transformation matrix.
  BLMatrix2D metaMatrix;
  //! Current user transformation matrix.
  BLMatrix2D userMatrix;

  //! Count of saved states in the context.
  size_t savedStateCount;

  //BL_HAS_TYPED_MEMBERS(BLContextState)
};
]]

ffi.cdef[[
//! Rendering context [C Interface - Virtual Function Table].
struct BLContextVirt {
  BLResult (__cdecl* destroy                 )(BLContextImpl* impl) ;
  BLResult (__cdecl* flush                   )(BLContextImpl* impl, uint32_t flags) ;

  BLResult (__cdecl* save                    )(BLContextImpl* impl, BLContextCookie* cookie) ;
  BLResult (__cdecl* restore                 )(BLContextImpl* impl, const BLContextCookie* cookie) ;

  BLResult (__cdecl* matrixOp                )(BLContextImpl* impl, uint32_t opType, const void* opData) ;
  BLResult (__cdecl* userToMeta              )(BLContextImpl* impl) ;

  BLResult (__cdecl* setHint                 )(BLContextImpl* impl, uint32_t hintType, uint32_t value) ;
  BLResult (__cdecl* setHints                )(BLContextImpl* impl, const BLContextHints* hints) ;
  BLResult (__cdecl* setFlattenMode          )(BLContextImpl* impl, uint32_t mode) ;
  BLResult (__cdecl* setFlattenTolerance     )(BLContextImpl* impl, double tolerance) ;
  BLResult (__cdecl* setApproximationOptions )(BLContextImpl* impl, const BLApproximationOptions* options) ;

  BLResult (__cdecl* setCompOp               )(BLContextImpl* impl, uint32_t compOp) ;
  BLResult (__cdecl* setGlobalAlpha          )(BLContextImpl* impl, double alpha) ;

  BLResult (__cdecl* setFillRule             )(BLContextImpl* impl, uint32_t fillRule) ;

  BLResult (__cdecl* setStrokeWidth          )(BLContextImpl* impl, double width) ;
  BLResult (__cdecl* setStrokeMiterLimit     )(BLContextImpl* impl, double miterLimit) ;
  BLResult (__cdecl* setStrokeCap            )(BLContextImpl* impl, uint32_t position, uint32_t strokeCap) ;
  BLResult (__cdecl* setStrokeCaps           )(BLContextImpl* impl, uint32_t strokeCap) ;
  BLResult (__cdecl* setStrokeJoin           )(BLContextImpl* impl, uint32_t strokeJoin) ;
  BLResult (__cdecl* setStrokeDashOffset     )(BLContextImpl* impl, double dashOffset) ;
  BLResult (__cdecl* setStrokeDashArray      )(BLContextImpl* impl, const BLArrayCore* dashArray) ;
  BLResult (__cdecl* setStrokeTransformOrder )(BLContextImpl* impl, uint32_t transformOrder) ;
  BLResult (__cdecl* setStrokeOptions        )(BLContextImpl* impl, const BLStrokeOptionsCore* options) ;

  union {
    struct {
      BLResult (__cdecl* setFillAlpha        )(BLContextImpl* impl, double alpha) ;
      BLResult (__cdecl* setStrokeAlpha      )(BLContextImpl* impl, double alpha) ;
      BLResult (__cdecl* getFillStyle        )(BLContextImpl* impl, void* object) ;
      BLResult (__cdecl* getStrokeStyle      )(BLContextImpl* impl, void* object) ;
      BLResult (__cdecl* getFillStyleRgba32  )(BLContextImpl* impl, uint32_t* rgba32) ;
      BLResult (__cdecl* getStrokeStyleRgba32)(BLContextImpl* impl, uint32_t* rgba32) ;
      BLResult (__cdecl* getFillStyleRgba64  )(BLContextImpl* impl, uint64_t* rgba64) ;
      BLResult (__cdecl* getStrokeStyleRgba64)(BLContextImpl* impl, uint64_t* rgba64) ;
      BLResult (__cdecl* setFillStyle        )(BLContextImpl* impl, const void* object) ;
      BLResult (__cdecl* setStrokeStyle      )(BLContextImpl* impl, const void* object) ;
      BLResult (__cdecl* setFillStyleRgba32  )(BLContextImpl* impl, uint32_t rgba32) ;
      BLResult (__cdecl* setStrokeStyleRgba32)(BLContextImpl* impl, uint32_t rgba32) ;
      BLResult (__cdecl* setFillStyleRgba64  )(BLContextImpl* impl, uint64_t rgba64) ;
      BLResult (__cdecl* setStrokeStyleRgba64)(BLContextImpl* impl, uint64_t rgba64) ;
    };
    struct {
      // Allows to dispatch fill/stroke by `BLContextOpType`.
      BLResult (__cdecl* setOpAlpha[2]       )(BLContextImpl* impl, double alpha) ;
      BLResult (__cdecl* getOpStyle[2]       )(BLContextImpl* impl, void* object) ;
      BLResult (__cdecl* getOpStyleRgba32[2] )(BLContextImpl* impl, uint32_t* rgba32) ;
      BLResult (__cdecl* getOpStyleRgba64[2] )(BLContextImpl* impl, uint64_t* rgba64) ;
      BLResult (__cdecl* setOpStyle[2]       )(BLContextImpl* impl, const void* object) ;
      BLResult (__cdecl* setOpStyleRgba32[2] )(BLContextImpl* impl, uint32_t rgba32) ;
      BLResult (__cdecl* setOpStyleRgba64[2] )(BLContextImpl* impl, uint64_t rgba64) ;
    };
  };

  BLResult (__cdecl* clipToRectI             )(BLContextImpl* impl, const BLRectI* rect) ;
  BLResult (__cdecl* clipToRectD             )(BLContextImpl* impl, const BLRect* rect) ;
  BLResult (__cdecl* restoreClipping         )(BLContextImpl* impl) ;

  BLResult (__cdecl* clearAll                )(BLContextImpl* impl) ;
  BLResult (__cdecl* clearRectI              )(BLContextImpl* impl, const BLRectI* rect) ;
  BLResult (__cdecl* clearRectD              )(BLContextImpl* impl, const BLRect* rect) ;

  BLResult (__cdecl* fillAll                 )(BLContextImpl* impl) ;
  BLResult (__cdecl* fillRectI               )(BLContextImpl* impl, const BLRectI* rect) ;
  BLResult (__cdecl* fillRectD               )(BLContextImpl* impl, const BLRect* rect) ;
  BLResult (__cdecl* fillPathD               )(BLContextImpl* impl, const BLPathCore* path) ;
  BLResult (__cdecl* fillGeometry            )(BLContextImpl* impl, uint32_t geometryType, const void* geometryData) ;
  BLResult (__cdecl* fillTextI               )(BLContextImpl* impl, const BLPointI* pt, const BLFontCore* font, const void* text, size_t size, uint32_t encoding) ;
  BLResult (__cdecl* fillTextD               )(BLContextImpl* impl, const BLPoint* pt, const BLFontCore* font, const void* text, size_t size, uint32_t encoding) ;
  BLResult (__cdecl* fillGlyphRunI           )(BLContextImpl* impl, const BLPointI* pt, const BLFontCore* font, const BLGlyphRun* glyphRun) ;
  BLResult (__cdecl* fillGlyphRunD           )(BLContextImpl* impl, const BLPoint* pt, const BLFontCore* font, const BLGlyphRun* glyphRun) ;

  BLResult (__cdecl* strokeRectI             )(BLContextImpl* impl, const BLRectI* rect) ;
  BLResult (__cdecl* strokeRectD             )(BLContextImpl* impl, const BLRect*  rect) ;
  BLResult (__cdecl* strokePathD             )(BLContextImpl* impl, const BLPathCore* path) ;
  BLResult (__cdecl* strokeGeometry          )(BLContextImpl* impl, uint32_t geometryType, const void* geometryData) ;
  BLResult (__cdecl* strokeTextI             )(BLContextImpl* impl, const BLPointI* pt, const BLFontCore* font, const void* text, size_t size, uint32_t encoding) ;
  BLResult (__cdecl* strokeTextD             )(BLContextImpl* impl, const BLPoint* pt, const BLFontCore* font, const void* text, size_t size, uint32_t encoding) ;
  BLResult (__cdecl* strokeGlyphRunI         )(BLContextImpl* impl, const BLPointI* pt, const BLFontCore* font, const BLGlyphRun* glyphRun) ;
  BLResult (__cdecl* strokeGlyphRunD         )(BLContextImpl* impl, const BLPoint* pt, const BLFontCore* font, const BLGlyphRun* glyphRun) ;

  BLResult (__cdecl* blitImageI              )(BLContextImpl* impl, const BLPointI* pt, const BLImageCore* img, const BLRectI* imgArea) ;
  BLResult (__cdecl* blitImageD              )(BLContextImpl* impl, const BLPoint* pt, const BLImageCore* img, const BLRectI* imgArea) ;
  BLResult (__cdecl* blitScaledImageI        )(BLContextImpl* impl, const BLRectI* rect, const BLImageCore* img, const BLRectI* imgArea) ;
  BLResult (__cdecl* blitScaledImageD        )(BLContextImpl* impl, const BLRect* rect, const BLImageCore* img, const BLRectI* imgArea) ;
};
]]

ffi.cdef[[
//! Rendering context [C Interface - Impl].
struct BLContextImpl {
  const BLContextVirt* virt;
  const BLContextState* state;
  void* reservedHeader[1];

  volatile size_t refCount;
  uint8_t implType;
  uint8_t implTraits;
  uint16_t memPoolData;
  uint32_t contextType;

  BLSize targetSize;
};

//! Rendering context [C Interface - Core].
struct BLContextCore {
  BLContextImpl* impl;
};
]]
BLContextCore = ffi.typeof("struct BLContextCore")


ffi.metatype(BLContextCore, {
    __gc = function(self)
      local bResult = blapi.blContextReset(self) ;
      return bResult == 0 or bResult;
    end;

    __index = {
      FillAll = function(self)
          local bResult = self.impl.virt.fillAll(self.impl);
          return bResult == 0 or bResult;
      end;
    
      FillGeometry = function(self, geometryType, geometryData)
        local bResult = self.impl.virt.fillGeometry(self.impl, geometryType, geometryData);
        return bResult == 0 or bResult;
      end;
    
      SetCompOp = function(self, compOp)
        local bResult = blapi.blContextSetCompOp(self, compOp);
        return bResult == 0 or bResult;
      end;
    
      SetFillStyle = function(self, object)
        local bResult = blapi.blContextSetFillStyle(self, object);
        return bResult == 0 or bResult;
      end;
    
      SetFillStyleRgba32 = function(self, rgba32)
        local bResult = blapi.blContextSetFillStyleRgba32(self, rgba32);
        return bResult == 0 or bResult;
      end;
    };
})

--[=[
BLContextCore_mt.__index = function(self, key)
    print("BLContextCore_mt:__index: ", key)

    -- first look in the implemenation for a field
    local success, info = pcall(function() return self.impl[key] end)
    if success then
        return info 
    end

--[[
      -- finally look for something in the virtual table
      -- then look in the virtual table for a function
      success, info = pcall(function() return self.impl.virt[key] end)
      if success then
          return info 
      end
--]]
    -- look for a private implementation
    local info rawget(BLContextCore_mt, key)
    print("Info: ", key, info)
    for k,v in pairs(BLContextCore_mt) do 
      print(k,v)
    end

    return info
end
--]=]



end --// BLEND2D_BLCONTEXT_H
