--[[
// [Blend2D]
// 2D Vector Graphics Powered by a JIT Compiler.
//
// [License]
// ZLIB - See LICENSE.md file in the package.
//
// This file modified from origin
-- William Adams
--]]

local ffi = require("ffi")
local bit = require("bit")
local band, bor = bit.band, bit.bor
local lshift, rshift = bit.lshift, bit.rshift

local enum = require("enum")

-- platform Byte ordering
if (__ARMEB__) or (__MIPSEB__) or 
    (__BYTE_ORDER__ and (__BYTE_ORDER__ == __ORDER_BIG_ENDIAN__)) then
BL_BUILD_BYTE_ORDER = 4321
else
BL_BUILD_BYTE_ORDER = 1234
end


-- ============================================================================
-- [Forward Declarations]
-- ============================================================================
ffi.cdef[[
typedef struct BLRange BLRange;
typedef struct BLRandom BLRandom;
typedef struct BLCreateForeignInfo  BLCreateForeignInfo;
typedef struct BLFileCore  BLFileCore;

typedef struct BLRuntimeBuildInfo   BLRuntimeBuildInfo;
typedef struct BLRuntimeMemoryInfo   BLRuntimeMemoryInfo;
typedef struct BLRuntimeCpuInfo   BLRuntimeCpuInfo;

typedef struct BLStringCore   BLStringCore;
typedef struct BLStringImpl   BLStringImpl;
typedef struct BLArrayCore   BLArrayCore;
typedef struct BLArrayImpl   BLArrayImpl;
typedef struct BLVariantCore   BLVariantCore;
typedef struct BLVariantImpl   BLVariantImpl;
]]

ffi.cdef[[
typedef struct BLPointI   BLPointI;
typedef struct BLPoint   BLPoint;
typedef struct BLSizeI   BLSizeI;
typedef struct BLSize   BLSize;
typedef struct BLBoxI   BLBoxI;
typedef struct BLBox   BLBox;
typedef struct BLRectI   BLRectI;
typedef struct BLRect   BLRect;
typedef struct BLLine   BLLine;
typedef struct BLTriangle   BLTriangle;
typedef struct BLRoundRect   BLRoundRect;
typedef struct BLCircle   BLCircle;
typedef struct BLEllipse    BLEllipse;
typedef struct BLArc    BLArc;
typedef struct BLMatrix2D    BLMatrix2D;
typedef struct BLPathCore  BLPathCore;
]]



ffi.cdef[[
typedef struct BLPathImpl  BLPathImpl;
typedef struct BLPathView  BLPathView;
typedef struct BLRegionCore  BLRegionCore;
typedef struct BLRegionImpl  BLRegionImpl;
typedef struct BLApproximationOptions  BLApproximationOptions;
typedef struct BLStrokeOptionsCore  BLStrokeOptionsCore;

typedef struct BLFormatInfo  BLFormatInfo;
typedef struct BLImageCore  BLImageCore;
typedef struct BLImageImpl  BLImageImpl;
typedef struct BLImageData  BLImageData;
typedef struct BLImageInfo  BLImageInfo;
typedef struct BLImageScaleOptions  BLImageScaleOptions;
typedef struct BLPixelConverterCore  BLPixelConverterCore;
typedef struct BLPixelConverterOptions  BLPixelConverterOptions;

typedef struct BLImageCodecCore  BLImageCodecCore;
typedef struct BLImageCodecImpl  BLImageCodecImpl;
typedef struct BLImageCodecVirt  BLImageCodecVirt;
typedef struct BLImageDecoderCore  BLImageDecoderCore;
typedef struct BLImageDecoderImpl  BLImageDecoderImpl;
typedef struct BLImageDecoderVirt  BLImageDecoderVirt;
typedef struct BLImageEncoderCore  BLImageEncoderCore;
typedef struct BLImageEncoderImpl  BLImageEncoderImpl;
typedef struct BLImageEncoderVirt  BLImageEncoderVirt;

typedef struct BLRgba32  BLRgba32;
typedef struct BLRgba64  BLRgba64;
typedef struct BLRgba128  BLRgba128;
typedef struct BLGradientCore  BLGradientCore;
typedef struct BLGradientImpl  BLGradientImpl;
typedef struct BLGradientStop  BLGradientStop;
typedef struct BLLinearGradientValues  BLLinearGradientValues;
typedef struct BLRadialGradientValues  BLRadialGradientValues;
typedef struct BLConicalGradientValues  BLConicalGradientValues;
typedef struct BLPatternCore  BLPatternCore;
typedef struct BLPatternImpl  BLPatternImpl;

typedef struct BLContextCore  BLContextCore;
typedef struct BLContextImpl  BLContextImpl;
typedef struct BLContextVirt  BLContextVirt;
typedef struct BLContextCookie  BLContextCookie;
typedef struct BLContextCreateOptions  BLContextCreateOptions;
typedef struct BLContextHints  BLContextHints;
typedef struct BLContextState  BLContextState;

typedef struct BLGlyphBufferCore  BLGlyphBufferCore;
typedef struct BLGlyphBufferData  BLGlyphBufferData;
typedef struct BLGlyphInfo  BLGlyphInfo;
typedef struct BLGlyphItem  BLGlyphItem;
typedef struct BLGlyphMappingState  BLGlyphMappingState;
typedef struct BLGlyphOutlineSinkInfo  BLGlyphOutlineSinkInfo;
typedef struct BLGlyphPlacement  BLGlyphPlacement;
typedef struct BLGlyphRun  BLGlyphRun;

typedef struct BLFontUnicodeCoverage  BLFontUnicodeCoverage;
typedef struct BLFontFaceInfo  BLFontFaceInfo;
typedef struct BLFontFeature  BLFontFeature;
typedef struct BLFontDesignMetrics  BLFontDesignMetrics;
typedef struct BLFontMatrix  BLFontMatrix;
typedef struct BLFontMetrics  BLFontMetrics;
typedef struct BLFontPanose  BLFontPanose;
typedef struct BLFontTable  BLFontTable;
typedef struct BLFontVariation  BLFontVariation;
typedef struct BLTextMetrics  BLTextMetrics;

typedef struct BLFontCore  BLFontCore;
typedef struct BLFontImpl  BLFontImpl;
typedef struct BLFontVirt  BLFontVirt;
typedef struct BLFontFaceCore  BLFontFaceCore;
typedef struct BLFontFaceImpl  BLFontFaceImpl;
typedef struct BLFontFaceVirt  BLFontFaceVirt;
typedef struct BLFontDataCore  BLFontDataCore;
typedef struct BLFontDataImpl  BLFontDataImpl;
typedef struct BLFontDataVirt  BLFontDataVirt;
typedef struct BLFontLoaderCore  BLFontLoaderCore;
typedef struct BLFontLoaderImpl  BLFontLoaderImpl;
typedef struct BLFontLoaderVirt  BLFontLoaderVirt;

]]

ffi.cdef[[
// ============================================================================
// [Public Types]
// ============================================================================
typedef uint32_t BLResult;
typedef uintptr_t BLBitWord;
typedef uint32_t BLTag;
typedef void (__cdecl* BLDestroyImplFunc)(void* impl, void* destroyData) ;
typedef BLResult (__cdecl* BLPathSinkFunc)(BLPathCore* path, const void* info, void* closure) ;
typedef uint16_t BLGlyphId;
]]





-- Blend2D result code
BLResultCode = enum {
  BL_SUCCESS = 0,

  BL_ERROR_START_INDEX = 0x00010000,

  BL_ERROR_OUT_OF_MEMORY = 0x00010000,  --!< Out of memory                 [ENOMEM].
  BL_ERROR_INVALID_VALUE,                --!< Invalid value/argument        [EINVAL].
  BL_ERROR_INVALID_STATE,                --!< Invalid state                 [EFAULT].
  BL_ERROR_INVALID_HANDLE,               --!< Invalid handle or file.       [EBADF].
  BL_ERROR_VALUE_TOO_LARGE,              --!< Value too large               [EOVERFLOW].
  BL_ERROR_NOT_INITIALIZED,              --!< Not initialize (some instance is built-in none when it shouldnt be).
  BL_ERROR_NOT_IMPLEMENTED,              --!< Not implemented               [ENOSYS].
  BL_ERROR_NOT_PERMITTED,                --!< Operation not permitted       [EPERM].

  BL_ERROR_IO,                           --!< IO error                      [EIO].
  BL_ERROR_BUSY,                         --!< Device or resource busy       [EBUSY].
  BL_ERROR_INTERRUPTED,                  --!< Operation interrupted         [EINTR].
  BL_ERROR_TRY_AGAIN,                    --!< Try again                     [EAGAIN].
  BL_ERROR_BROKEN_PIPE,                  --!< Broken pipe                   [EPIPE].
  BL_ERROR_INVALID_SEEK,                 --!< File is not seekable          [ESPIPE].
  BL_ERROR_SYMLINK_LOOP,                 --!< Too many levels of symlinks   [ELOOP].
  BL_ERROR_FILE_TOO_LARGE,               --!< File is too large             [EFBIG].
  BL_ERROR_ALREADY_EXISTS,               --!< File/directory already exists [EEXIST].
  BL_ERROR_ACCESS_DENIED,                --!< Access denied                 [EACCES].
  BL_ERROR_MEDIA_CHANGED,                --!< Media changed                 [Windows::ERROR_MEDIA_CHANGED].
  BL_ERROR_READ_ONLY_FS,                 --!< The file/FS is read-only      [EROFS].
  BL_ERROR_NO_DEVICE,                    --!< Device doesnt exist          [ENXIO].
  BL_ERROR_NO_ENTRY,                     --!< No such file or directory     [ENOENT].
  BL_ERROR_NO_MEDIA,                     --!< No media in drive/device      [ENOMEDIUM].
  BL_ERROR_NO_MORE_DATA,                 --!< No more data / end of file    [ENODATA].
  BL_ERROR_NO_MORE_FILES,                --!< No more files                 [ENMFILE].
  BL_ERROR_NO_SPACE_LEFT,                --!< No space left on device       [ENOSPC].
  BL_ERROR_NOT_EMPTY,                    --!< Directory is not empty        [ENOTEMPTY].
  BL_ERROR_NOT_FILE,                     --!< Not a file                    [EISDIR].
  BL_ERROR_NOT_DIRECTORY,                --!< Not a directory               [ENOTDIR].
  BL_ERROR_NOT_SAME_DEVICE,              --!< Not same device               [EXDEV].
  BL_ERROR_NOT_BLOCK_DEVICE,             --!< Not a block device            [ENOTBLK].

  BL_ERROR_INVALID_FILE_NAME,            --!< File/path name is invalid     [n/a].
  BL_ERROR_FILE_NAME_TOO_LONG,           --!< File/path name is too long    [ENAMETOOLONG].

  BL_ERROR_TOO_MANY_OPEN_FILES,          --!< Too many open files           [EMFILE].
  BL_ERROR_TOO_MANY_OPEN_FILES_BY_OS,    --!< Too many open files by OS     [ENFILE].
  BL_ERROR_TOO_MANY_LINKS,               --!< Too many symbolic links on FS [EMLINK].

  BL_ERROR_FILE_EMPTY,                   --!< File is empty (not specific to any OS error).
  BL_ERROR_OPEN_FAILED,                  --!< File open failed              [Windows::ERROR_OPEN_FAILED].
  BL_ERROR_NOT_ROOT_DEVICE,              --!< Not a root device/directory   [Windows::ERROR_DIR_NOT_ROOT].

  BL_ERROR_UNKNOWN_SYSTEM_ERROR,         --!< Unknown system error that failed to translate to Blend2D result code.

  BL_ERROR_INVALID_SIGNATURE,            --!< Invalid data signature or header.
  BL_ERROR_INVALID_DATA,                 --!< Invalid or corrupted data.
  BL_ERROR_INVALID_STRING,               --!< Invalid string (invalid data of either UTF8, UTF16, or UTF32).
  BL_ERROR_DATA_TRUNCATED,               --!< Truncated data (more data required than memory/stream provides).
  BL_ERROR_DATA_TOO_LARGE,               --!< Input data too large to be processed.
  BL_ERROR_DECOMPRESSION_FAILED,         --!< Decompression failed due to invalid data (RLE, Huffman, etc).

  BL_ERROR_INVALID_GEOMETRY,             --!< Invalid geometry (invalid path data or shape).
  BL_ERROR_NO_MATCHING_VERTEX,           --!< Returned when there is no matching vertex in path data.

  BL_ERROR_NO_MATCHING_COOKIE,           --!< No matching cookie (BLContext).
  BL_ERROR_NO_STATES_TO_RESTORE,         --!< No states to restore (BLContext).

  BL_ERROR_IMAGE_TOO_LARGE,              --!< The size of the image is too large.
  BL_ERROR_IMAGE_NO_MATCHING_CODEC,      --!< Image codec for a required format doesnt exist.
  BL_ERROR_IMAGE_UNKNOWN_FILE_FORMAT,    --!< Unknown or invalid file format that cannot be read.
  BL_ERROR_IMAGE_DECODER_NOT_PROVIDED,   --!< Image codec doesnt support reading the file format.
  BL_ERROR_IMAGE_ENCODER_NOT_PROVIDED,   --!< Image codec doesnt support writing the file format.

  BL_ERROR_PNG_MULTIPLE_IHDR,            --!< Multiple IHDR chunks are not allowed (PNG).
  BL_ERROR_PNG_INVALID_IDAT,             --!< Invalid IDAT chunk (PNG).
  BL_ERROR_PNG_INVALID_IEND,             --!< Invalid IEND chunk (PNG).
  BL_ERROR_PNG_INVALID_PLTE,             --!< Invalid PLTE chunk (PNG).
  BL_ERROR_PNG_INVALID_TRNS,             --!< Invalid tRNS chunk (PNG).
  BL_ERROR_PNG_INVALID_FILTER,           --!< Invalid filter type (PNG).

  BL_ERROR_JPEG_UNSUPPORTED_FEATURE,     --!< Unsupported feature (JPEG).
  BL_ERROR_JPEG_INVALID_SOS,             --!< Invalid SOS marker or header (JPEG).
  BL_ERROR_JPEG_INVALID_SOF,             --!< Invalid SOF marker (JPEG).
  BL_ERROR_JPEG_MULTIPLE_SOF,            --!< Multiple SOF markers (JPEG).
  BL_ERROR_JPEG_UNSUPPORTED_SOF,         --!< Unsupported SOF marker (JPEG).

  BL_ERROR_FONT_NO_CHARACTER_MAPPING,    --!< Font has no character to glyph mapping data.
  BL_ERROR_FONT_MISSING_IMPORTANT_TABLE, --!< Font has missing an important table.
  BL_ERROR_FONT_FEATURE_NOT_AVAILABLE,   --!< Font feature is not available.
  BL_ERROR_FONT_CFF_INVALID_DATA,        --!< Font has an invalid CFF data.
  BL_ERROR_FONT_PROGRAM_TERMINATED,      --!< Font program terminated because the execution reached the limit.

  BL_ERROR_INVALID_GLYPH                 --!< Invalid glyph identifier.
};


--[=[
ffi.cdef[[
//! Byte order.
enum  BLByteOrder  {
  //! Little endian byte-order.
  BL_BYTE_ORDER_LE = 0,
  //! Big endian byte-order.
  BL_BYTE_ORDER_BE = 1,

  //! Native (host) byte-order.
  BL_BYTE_ORDER_NATIVE = BL_BUILD_BYTE_ORDER == 1234 ? BL_BYTE_ORDER_LE : BL_BYTE_ORDER_BE,
  //! Swapped byte-order (BE if host is LE and vice versa).
  BL_BYTE_ORDER_SWAPPED = BL_BUILD_BYTE_ORDER == 1234 ? BL_BYTE_ORDER_BE : BL_BYTE_ORDER_LE
};
]]
--]=]


--! Data access type.
BLDataAccessType = enum {
  BL_DATA_ACCESS_TYPE_NONE = 0,
  BL_DATA_ACCESS_TYPE_RO = 1,
  BL_DATA_ACCESS_TYPE_RW = 2,

  BL_DATA_ACCESS_TYPE_COUNT = 3
};



-- Data source type.
BLDataSourceType = enum {
  BL_DATA_SOURCE_TYPE_NONE = 0,
  BL_DATA_SOURCE_TYPE_MEMORY = 1,
  BL_DATA_SOURCE_TYPE_FILE = 2,
  BL_DATA_SOURCE_TYPE_CUSTOM = 3,

  BL_DATA_SOURCE_TYPE_COUNT = 4
};


-- Modification operation applied to Blend2D containers.
BLModifyOp = enum {
  BL_MODIFY_OP_ASSIGN_FIT = 0,
  BL_MODIFY_OP_ASSIGN_GROW = 1,
  BL_MODIFY_OP_APPEND_FIT = 2,
  BL_MODIFY_OP_APPEND_GROW = 3,

  BL_MODIFY_OP_COUNT = 4
};



-- Boolean operator.
BLBooleanOp = enum {
  BL_BOOLEAN_OP_COPY = 0,
  BL_BOOLEAN_OP_AND = 1,
  BL_BOOLEAN_OP_OR = 2,
  BL_BOOLEAN_OP_XOR = 3,
  BL_BOOLEAN_OP_SUB = 4,

  BL_BOOLEAN_OP_COUNT = 5
};



-- Extend mode.
BLExtendMode  = enum {
  BL_EXTEND_MODE_PAD = 0,
  BL_EXTEND_MODE_REPEAT = 1,
  BL_EXTEND_MODE_REFLECT = 2,

  BL_EXTEND_MODE_PAD_X_PAD_Y = 0,
  BL_EXTEND_MODE_REPEAT_X_REPEAT_Y = 1,
  BL_EXTEND_MODE_REFLECT_X_REFLECT_Y = 2,
  BL_EXTEND_MODE_PAD_X_REPEAT_Y = 3,
  BL_EXTEND_MODE_PAD_X_REFLECT_Y = 4,
  BL_EXTEND_MODE_REPEAT_X_PAD_Y = 5,
  BL_EXTEND_MODE_REPEAT_X_REFLECT_Y = 6,
  BL_EXTEND_MODE_REFLECT_X_PAD_Y = 7,
  BL_EXTEND_MODE_REFLECT_X_REPEAT_Y = 8,


  BL_EXTEND_MODE_SIMPLE_COUNT = 3,

  BL_EXTEND_MODE_COMPLEX_COUNT = 9
};


-- Style type.
BLStyleType = enum {

  BL_STYLE_TYPE_NONE = 0,
  BL_STYLE_TYPE_SOLID = 1,
  BL_STYLE_TYPE_PATTERN = 2,
  BL_STYLE_TYPE_GRADIENT = 3,

  BL_STYLE_TYPE_COUNT = 4
};



-- Text encoding.
BLTextEncoding = enum {

  BL_TEXT_ENCODING_UTF8 = 0,
  BL_TEXT_ENCODING_UTF16 = 1,
  BL_TEXT_ENCODING_UTF32 = 2,
  BL_TEXT_ENCODING_LATIN1 = 3,



  BL_TEXT_ENCODING_COUNT = 4
};


if ffi.sizeof('wchar_t') == 4 then
    BLTextEncoding.BL_TEXT_ENCODING_WCHAR = BLTextEncoding.BL_TEXT_ENCODING_UTF32
elseif ffi.sizeof('wchar_t') == 2 then
    BLTextEncoding.BL_TEXT_ENCODING_WCHAR = BLTextEncoding.BL_TEXT_ENCODING_UTF16
else
    BLTextEncoding.BL_TEXT_ENCODING_WCHAR = BLTextEncoding.BL_TEXT_ENCODING_UTF8
end



--[=[
// ============================================================================
// [Public API (Inline)]
// ============================================================================


//! Returns the `result` passed.
//!
//! Provided for debugging purposes. Putting a breakpoint inside `blTraceError()`
//! can help with tracing an origin of errors reported / returned by Blend2D as
//! each error goes through this function.
//!
//! It's a zero-cost solution that doesn't affect release builds in any way.
static inline BLResult blTraceError(BLResult result)  { return result; }
--]=]

ffi.cdef[[
struct BLRange {
  size_t start;
  size_t end;
};
]]

ffi.cdef[[
struct BLCreateForeignInfo {
  void* data;
  size_t size;
  BLDestroyImplFunc destroyFunc;
  void* destroyData;
};
]]


ffi.cdef[[
typedef struct {                       
    const void* data;                    
    size_t size;                         
} BLArrayView;

typedef struct {                       
    const char* data;                    
    size_t size;                         
} BLStringView;

typedef struct {                       
    const BLBoxI* data;                    
    size_t size;                         
} BLRegionView;


typedef BLArrayView BLDataView;
]]


    -- Rendering context type.
    BLContextType = enum {
      [0] = "BL_CONTEXT_TYPE_NONE",
      "BL_CONTEXT_TYPE_DUMMY",
      "BL_CONTEXT_TYPE_RASTER",
      "BL_CONTEXT_TYPE_RASTER_ASYNC",

      --[4] = "BL_CONTEXT_TYPE_COUNT"
  };

  -- Rendering context hint.
  BLContextHint = enum {
      [0] = "BL_CONTEXT_HINT_RENDERING_QUALITY" = 0,
      [1] = "BL_CONTEXT_HINT_GRADIENT_QUALITY" = 1,
      [2] = "BL_CONTEXT_HINT_PATTERN_QUALITY" = 2,

      --[8] = "BL_CONTEXT_HINT_COUNT" = 8
  };

  -- Describes a rendering operation type - fill or stroke.
  BLContextOpType = enum {
      [0] = "BL_CONTEXT_OP_TYPE_FILL",
      [1] = "BL_CONTEXT_OP_TYPE_STROKE",

      --[2] = "BL_CONTEXT_OP_TYPE_COUNT"
  };

  -- Rendering context flush-flags, use with `BLContext::flush()`.
  BLContextFlushFlags = enum {
      [0x80000000] = "BL_CONTEXT_FLUSH_SYNC"
  };


  BLContextCreateFlags = enum {
      [0x10000000] = "BL_CONTEXT_CREATE_FLAG_ISOLATED_RUNTIME",
      [0x20000000] = "BL_CONTEXT_CREATE_FLAG_OVERRIDE_FEATURES"
  };

  -- Clip operation.
  BLClipOp = enum {
      [0] = "BL_CLIP_OP_REPLACE",
      [1] = "BL_CLIP_OP_INTERSECT",

      --[2] = BL_CLIP_OP_COUNT"
  };

  -- Clip mode.
  BLClipMode = enum {
      [0] = "BL_CLIP_MODE_ALIGNED_RECT";
      "BL_CLIP_MODE_UNALIGNED_RECT" = 1;
      "BL_CLIP_MODE_MASK" = 2;

      --BL_CLIP_MODE_COUNT = 3
  };

  -- Composition & blending operator.
  BLCompOp = enum {
      [0] = "BL_COMP_OP_SRC_OVER";
      "BL_COMP_OP_SRC_COPY";
      "BL_COMP_OP_SRC_IN";
      "BL_COMP_OP_SRC_OUT";
      "BL_COMP_OP_SRC_ATOP";
      "BL_COMP_OP_DST_OVER";
      "BL_COMP_OP_DST_COPY";
      "BL_COMP_OP_DST_IN";
      "BL_COMP_OP_DST_OUT";
      "BL_COMP_OP_DST_ATOP";
      "BL_COMP_OP_XOR";
      "BL_COMP_OP_CLEAR";
      "BL_COMP_OP_PLUS";
      "BL_COMP_OP_MINUS";
      "BL_COMP_OP_MULTIPLY";
      "BL_COMP_OP_SCREEN";
      "BL_COMP_OP_OVERLAY";
      "BL_COMP_OP_DARKEN";
      "BL_COMP_OP_LIGHTEN";
      "BL_COMP_OP_COLOR_DODGE";
      "BL_COMP_OP_COLOR_BURN";
      "BL_COMP_OP_LINEAR_BURN";
      "BL_COMP_OP_LINEAR_LIGHT";
      "BL_COMP_OP_PIN_LIGHT";
      "BL_COMP_OP_HARD_LIGHT";
      "BL_COMP_OP_SOFT_LIGHT";
      "BL_COMP_OP_DIFFERENCE";
      "BL_COMP_OP_EXCLUSION";

      --"BL_COMP_OP_COUNT"
  };

  -- Gradient rendering quality.
  BLGradientQuality = enum {
      [0] = "BL_GRADIENT_QUALITY_NEAREST",
      [1] = "BL_GRADIENT_QUALITY_COUNT"
  };

  -- Pattern quality.
  BLPatternQuality = enum {
      [0] = "BL_PATTERN_QUALITY_NEAREST",
      [1] = "BL_PATTERN_QUALITY_BILINEAR",
  
      --"BL_PATTERN_QUALITY_COUNT"
  };

  -- Rendering quality.
  BLRenderingQuality = enum {
      [0] = "BL_RENDERING_QUALITY_ANTIALIAS",
      "BL_RENDERING_QUALITY_COUNT"
  };


--[[
// ============================================================================
// [C Interface - Core]
// ============================================================================
--]]
ffi.cdef[[
BLResult __cdecl blArrayInit(BLArrayCore* self, uint32_t arrayTypeId) ;
BLResult __cdecl blArrayReset(BLArrayCore* self) ;
size_t   __cdecl blArrayGetSize(const BLArrayCore* self) ;
size_t   __cdecl blArrayGetCapacity(const BLArrayCore* self) ;
const void* __cdecl blArrayGetData(const BLArrayCore* self) ;
BLResult __cdecl blArrayClear(BLArrayCore* self) ;
BLResult __cdecl blArrayShrink(BLArrayCore* self) ;
BLResult __cdecl blArrayReserve(BLArrayCore* self, size_t n) ;
BLResult __cdecl blArrayResize(BLArrayCore* self, size_t n, const void* fill) ;
BLResult __cdecl blArrayMakeMutable(BLArrayCore* self, void** dataOut) ;
BLResult __cdecl blArrayModifyOp(BLArrayCore* self, uint32_t op, size_t n, void** dataOut) ;
BLResult __cdecl blArrayInsertOp(BLArrayCore* self, size_t index, size_t n, void** dataOut) ;
BLResult __cdecl blArrayAssignMove(BLArrayCore* self, BLArrayCore* other) ;
BLResult __cdecl blArrayAssignWeak(BLArrayCore* self, const BLArrayCore* other) ;
BLResult __cdecl blArrayAssignDeep(BLArrayCore* self, const BLArrayCore* other) ;
BLResult __cdecl blArrayAssignView(BLArrayCore* self, const void* items, size_t n) ;
BLResult __cdecl blArrayAppendU8(BLArrayCore* self, uint8_t value) ;
BLResult __cdecl blArrayAppendU16(BLArrayCore* self, uint16_t value) ;
BLResult __cdecl blArrayAppendU32(BLArrayCore* self, uint32_t value) ;
BLResult __cdecl blArrayAppendU64(BLArrayCore* self, uint64_t value) ;
BLResult __cdecl blArrayAppendF32(BLArrayCore* self, float value) ;
BLResult __cdecl blArrayAppendF64(BLArrayCore* self, double value) ;
BLResult __cdecl blArrayAppendItem(BLArrayCore* self, const void* item) ;
BLResult __cdecl blArrayAppendView(BLArrayCore* self, const void* items, size_t n) ;
BLResult __cdecl blArrayInsertU8(BLArrayCore* self, size_t index, uint8_t value) ;
BLResult __cdecl blArrayInsertU16(BLArrayCore* self, size_t index, uint16_t value) ;
BLResult __cdecl blArrayInsertU32(BLArrayCore* self, size_t index, uint32_t value) ;
BLResult __cdecl blArrayInsertU64(BLArrayCore* self, size_t index, uint64_t value) ;
BLResult __cdecl blArrayInsertF32(BLArrayCore* self, size_t index, float value) ;
BLResult __cdecl blArrayInsertF64(BLArrayCore* self, size_t index, double value) ;
BLResult __cdecl blArrayInsertItem(BLArrayCore* self, size_t index, const void* item) ;
BLResult __cdecl blArrayInsertView(BLArrayCore* self, size_t index, const void* items, size_t n) ;
BLResult __cdecl blArrayReplaceU8(BLArrayCore* self, size_t index, uint8_t value) ;
BLResult __cdecl blArrayReplaceU16(BLArrayCore* self, size_t index, uint16_t value) ;
BLResult __cdecl blArrayReplaceU32(BLArrayCore* self, size_t index, uint32_t value) ;
BLResult __cdecl blArrayReplaceU64(BLArrayCore* self, size_t index, uint64_t value) ;
BLResult __cdecl blArrayReplaceF32(BLArrayCore* self, size_t index, float value) ;
BLResult __cdecl blArrayReplaceF64(BLArrayCore* self, size_t index, double value) ;
BLResult __cdecl blArrayReplaceItem(BLArrayCore* self, size_t index, const void* item) ;
BLResult __cdecl blArrayReplaceView(BLArrayCore* self, const BLRange* range, const void* items, size_t n) ;
BLResult __cdecl blArrayRemoveIndex(BLArrayCore* self, size_t index) ;
BLResult __cdecl blArrayRemoveRange(BLArrayCore* self, const BLRange* range) ;
bool     __cdecl blArrayEquals(const BLArrayCore* a, const BLArrayCore* b) ;

]]

ffi.cdef[[
//! \name BLContext

BLResult __cdecl blContextInit(BLContextCore* self) ;
BLResult __cdecl blContextInitAs(BLContextCore* self, BLImageCore* image, const BLContextCreateOptions* options) ;
BLResult __cdecl blContextReset(BLContextCore* self) ;
BLResult __cdecl blContextAssignMove(BLContextCore* self, BLContextCore* other) ;
BLResult __cdecl blContextAssignWeak(BLContextCore* self, const BLContextCore* other) ;
BLResult __cdecl blContextBegin(BLContextCore* self, BLImageCore* image, const BLContextCreateOptions* options) ;
BLResult __cdecl blContextEnd(BLContextCore* self) ;
BLResult __cdecl blContextFlush(BLContextCore* self, uint32_t flags) ;
BLResult __cdecl blContextSave(BLContextCore* self, BLContextCookie* cookie) ;
BLResult __cdecl blContextRestore(BLContextCore* self, const BLContextCookie* cookie) ;
BLResult __cdecl blContextUserToMeta(BLContextCore* self) ;
BLResult __cdecl blContextMatrixOp(BLContextCore* self, uint32_t opType, const void* opData) ;
BLResult __cdecl blContextSetHint(BLContextCore* self, uint32_t hintType, uint32_t value) ;
BLResult __cdecl blContextSetHints(BLContextCore* self, const BLContextHints* hints) ;
BLResult __cdecl blContextSetFlattenMode(BLContextCore* self, uint32_t mode) ;
BLResult __cdecl blContextSetFlattenTolerance(BLContextCore* self, double tolerance) ;
BLResult __cdecl blContextSetApproximationOptions(BLContextCore* self, const BLApproximationOptions* options) ;
BLResult __cdecl blContextSetCompOp(BLContextCore* self, uint32_t compOp) ;
BLResult __cdecl blContextSetGlobalAlpha(BLContextCore* self, double alpha) ;
BLResult __cdecl blContextSetFillRule(BLContextCore* self, uint32_t fillRule) ;
BLResult __cdecl blContextSetFillAlpha(BLContextCore* self, double alpha) ;
BLResult __cdecl blContextGetFillStyle(const BLContextCore* self, void* object) ;
BLResult __cdecl blContextGetFillStyleRgba32(const BLContextCore* self, uint32_t* rgba32) ;
BLResult __cdecl blContextGetFillStyleRgba64(const BLContextCore* self, uint64_t* rgba64) ;
BLResult __cdecl blContextSetFillStyle(BLContextCore* self, const void* object) ;
BLResult __cdecl blContextSetFillStyleRgba32(BLContextCore* self, uint32_t rgba32) ;
BLResult __cdecl blContextSetFillStyleRgba64(BLContextCore* self, uint64_t rgba64) ;
BLResult __cdecl blContextSetStrokeWidth(BLContextCore* self, double width) ;
BLResult __cdecl blContextSetStrokeMiterLimit(BLContextCore* self, double miterLimit) ;
BLResult __cdecl blContextSetStrokeCap(BLContextCore* self, uint32_t position, uint32_t strokeCap) ;
BLResult __cdecl blContextSetStrokeCaps(BLContextCore* self, uint32_t strokeCap) ;
BLResult __cdecl blContextSetStrokeJoin(BLContextCore* self, uint32_t strokeJoin) ;
BLResult __cdecl blContextSetStrokeDashOffset(BLContextCore* self, double dashOffset) ;
BLResult __cdecl blContextSetStrokeDashArray(BLContextCore* self, const BLArrayCore* dashArray) ;
BLResult __cdecl blContextSetStrokeTransformOrder(BLContextCore* self, uint32_t transformOrder) ;
BLResult __cdecl blContextSetStrokeOptions(BLContextCore* self, const BLStrokeOptionsCore* options) ;
BLResult __cdecl blContextSetStrokeAlpha(BLContextCore* self, double alpha) ;
BLResult __cdecl blContextGetStrokeStyle(const BLContextCore* self, void* object) ;
BLResult __cdecl blContextGetStrokeStyleRgba32(const BLContextCore* self, uint32_t* rgba32) ;
BLResult __cdecl blContextGetStrokeStyleRgba64(const BLContextCore* self, uint64_t* rgba64) ;
BLResult __cdecl blContextSetStrokeStyle(BLContextCore* self, const void* object) ;
BLResult __cdecl blContextSetStrokeStyleRgba32(BLContextCore* self, uint32_t rgba32) ;
BLResult __cdecl blContextSetStrokeStyleRgba64(BLContextCore* self, uint64_t rgba64) ;
BLResult __cdecl blContextClipToRectI(BLContextCore* self, const BLRectI* rect) ;
BLResult __cdecl blContextClipToRectD(BLContextCore* self, const BLRect* rect) ;
BLResult __cdecl blContextRestoreClipping(BLContextCore* self) ;
BLResult __cdecl blContextClearAll(BLContextCore* self) ;
BLResult __cdecl blContextClearRectI(BLContextCore* self, const BLRectI* rect) ;
BLResult __cdecl blContextClearRectD(BLContextCore* self, const BLRect* rect) ;
BLResult __cdecl blContextFillAll(BLContextCore* self) ;
BLResult __cdecl blContextFillRectI(BLContextCore* self, const BLRectI* rect) ;
BLResult __cdecl blContextFillRectD(BLContextCore* self, const BLRect* rect) ;
BLResult __cdecl blContextFillPathD(BLContextCore* self, const BLPathCore* path) ;
BLResult __cdecl blContextFillGeometry(BLContextCore* self, uint32_t geometryType, const void* geometryData) ;
BLResult __cdecl blContextFillTextI(BLContextCore* self, const BLPointI* pt, const BLFontCore* font, const void* text, size_t size, uint32_t encoding) ;
BLResult __cdecl blContextFillTextD(BLContextCore* self, const BLPoint* pt, const BLFontCore* font, const void* text, size_t size, uint32_t encoding) ;
BLResult __cdecl blContextFillGlyphRunI(BLContextCore* self, const BLPointI* pt, const BLFontCore* font, const BLGlyphRun* glyphRun) ;
BLResult __cdecl blContextFillGlyphRunD(BLContextCore* self, const BLPoint* pt, const BLFontCore* font, const BLGlyphRun* glyphRun) ;
BLResult __cdecl blContextStrokeRectI(BLContextCore* self, const BLRectI* rect) ;
BLResult __cdecl blContextStrokeRectD(BLContextCore* self, const BLRect* rect) ;
BLResult __cdecl blContextStrokePathD(BLContextCore* self, const BLPathCore* path) ;
BLResult __cdecl blContextStrokeGeometry(BLContextCore* self, uint32_t geometryType, const void* geometryData) ;
BLResult __cdecl blContextStrokeTextI(BLContextCore* self, const BLPointI* pt, const BLFontCore* font, const void* text, size_t size, uint32_t encoding) ;
BLResult __cdecl blContextStrokeTextD(BLContextCore* self, const BLPoint* pt, const BLFontCore* font, const void* text, size_t size, uint32_t encoding) ;
BLResult __cdecl blContextStrokeGlyphRunI(BLContextCore* self, const BLPointI* pt, const BLFontCore* font, const BLGlyphRun* glyphRun) ;
BLResult __cdecl blContextStrokeGlyphRunD(BLContextCore* self, const BLPoint* pt, const BLFontCore* font, const BLGlyphRun* glyphRun) ;
BLResult __cdecl blContextBlitImageI(BLContextCore* self, const BLPointI* pt, const BLImageCore* img, const BLRectI* imgArea) ;
BLResult __cdecl blContextBlitImageD(BLContextCore* self, const BLPoint* pt, const BLImageCore* img, const BLRectI* imgArea) ;
BLResult __cdecl blContextBlitScaledImageI(BLContextCore* self, const BLRectI* rect, const BLImageCore* img, const BLRectI* imgArea) ;
BLResult __cdecl blContextBlitScaledImageD(BLContextCore* self, const BLRect* rect, const BLImageCore* img, const BLRectI* imgArea) ;

]]

ffi.cdef[[

BLResult __cdecl blFileInit(BLFileCore* self) ;
BLResult __cdecl blFileReset(BLFileCore* self) ;
BLResult __cdecl blFileOpen(BLFileCore* self, const char* fileName, uint32_t openFlags) ;
BLResult __cdecl blFileClose(BLFileCore* self) ;
BLResult __cdecl blFileSeek(BLFileCore* self, int64_t offset, uint32_t seekType, int64_t* positionOut) ;
BLResult __cdecl blFileRead(BLFileCore* self, void* buffer, size_t n, size_t* bytesReadOut) ;
BLResult __cdecl blFileWrite(BLFileCore* self, const void* buffer, size_t n, size_t* bytesWrittenOut) ;
BLResult __cdecl blFileTruncate(BLFileCore* self, int64_t maxSize) ;
BLResult __cdecl blFileGetSize(BLFileCore* self, uint64_t* fileSizeOut) ;

]]

ffi.cdef[[

BLResult __cdecl blFileSystemReadFile(const char* fileName, BLArrayCore* dst, size_t maxSize) ;
BLResult __cdecl blFileSystemWriteFile(const char* fileName, const void* data, size_t size, size_t* bytesWrittenOut) ;

]]

ffi.cdef[[

BLResult __cdecl blFontInit(BLFontCore* self) ;
BLResult __cdecl blFontReset(BLFontCore* self) ;
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

ffi.cdef[[

BLResult __cdecl blFontDataInit(BLFontDataCore* self) ;
BLResult __cdecl blFontDataReset(BLFontDataCore* self) ;
BLResult __cdecl blFontDataAssignMove(BLFontDataCore* self, BLFontDataCore* other) ;
BLResult __cdecl blFontDataAssignWeak(BLFontDataCore* self, const BLFontDataCore* other) ;
bool     __cdecl blFontDataEquals(const BLFontDataCore* a, const BLFontDataCore* b) ;
BLResult __cdecl blFontDataListTags(const BLFontDataCore* self, BLArrayCore* dst) ;
size_t   __cdecl blFontDataQueryTables(const BLFontDataCore* self, BLFontTable* dst, const BLTag* tags, size_t count) ;

]]

ffi.cdef[[

BLResult __cdecl blFontFaceInit(BLFontFaceCore* self) ;
BLResult __cdecl blFontFaceReset(BLFontFaceCore* self) ;
BLResult __cdecl blFontFaceAssignMove(BLFontFaceCore* self, BLFontFaceCore* other) ;
BLResult __cdecl blFontFaceAssignWeak(BLFontFaceCore* self, const BLFontFaceCore* other) ;
bool     __cdecl blFontFaceEquals(const BLFontFaceCore* a, const BLFontFaceCore* b) ;
BLResult __cdecl blFontFaceCreateFromFile(BLFontFaceCore* self, const char* fileName) ;
BLResult __cdecl blFontFaceCreateFromLoader(BLFontFaceCore* self, const BLFontLoaderCore* loader, uint32_t faceIndex) ;
BLResult __cdecl blFontFaceGetFaceInfo(const BLFontFaceCore* self, BLFontFaceInfo* out) ;
BLResult __cdecl blFontFaceGetDesignMetrics(const BLFontFaceCore* self, BLFontDesignMetrics* out) ;
BLResult __cdecl blFontFaceGetUnicodeCoverage(const BLFontFaceCore* self, BLFontUnicodeCoverage* out) ;

]]

ffi.cdef[[

BLResult __cdecl blFontLoaderInit(BLFontLoaderCore* self) ;
BLResult __cdecl blFontLoaderReset(BLFontLoaderCore* self) ;
BLResult __cdecl blFontLoaderAssignMove(BLFontLoaderCore* self, BLFontLoaderCore* other) ;
BLResult __cdecl blFontLoaderAssignWeak(BLFontLoaderCore* self, const BLFontLoaderCore* other) ;
bool     __cdecl blFontLoaderEquals(const BLFontLoaderCore* a, const BLFontLoaderCore* b) ;
BLResult __cdecl blFontLoaderCreateFromFile(BLFontLoaderCore* self, const char* fileName) ;
BLResult __cdecl blFontLoaderCreateFromDataArray(BLFontLoaderCore* self, const BLArrayCore* dataArray) ;
BLResult __cdecl blFontLoaderCreateFromData(BLFontLoaderCore* self, const void* data, size_t size, BLDestroyImplFunc destroyFunc, void* destroyData) ;
BLFontDataImpl* __cdecl blFontLoaderDataByFaceIndex(BLFontLoaderCore* self, uint32_t faceIndex) ;

]]

ffi.cdef[[

BLResult __cdecl blFormatInfoSanitize(BLFormatInfo* self) ;

]]

ffi.cdef[[

BLResult __cdecl blGlyphBufferInit(BLGlyphBufferCore* self) ;
BLResult __cdecl blGlyphBufferReset(BLGlyphBufferCore* self) ;
BLResult __cdecl blGlyphBufferClear(BLGlyphBufferCore* self) ;
BLResult __cdecl blGlyphBufferSetText(BLGlyphBufferCore* self, const void* data, size_t size, uint32_t encoding) ;
BLResult __cdecl blGlyphBufferSetGlyphIds(BLGlyphBufferCore* self, const void* data, intptr_t advance, size_t size) ;

]]

ffi.cdef[[

BLResult __cdecl blGradientInit(BLGradientCore* self) ;
BLResult __cdecl blGradientInitAs(BLGradientCore* self, uint32_t type, const void* values, uint32_t extendMode, const BLGradientStop* stops, size_t n, const BLMatrix2D* m) ;
BLResult __cdecl blGradientReset(BLGradientCore* self) ;
BLResult __cdecl blGradientAssignMove(BLGradientCore* self, BLGradientCore* other) ;
BLResult __cdecl blGradientAssignWeak(BLGradientCore* self, const BLGradientCore* other) ;
BLResult __cdecl blGradientCreate(BLGradientCore* self, uint32_t type, const void* values, uint32_t extendMode, const BLGradientStop* stops, size_t n, const BLMatrix2D* m) ;
BLResult __cdecl blGradientShrink(BLGradientCore* self) ;
BLResult __cdecl blGradientReserve(BLGradientCore* self, size_t n) ;
uint32_t __cdecl blGradientGetType(const BLGradientCore* self) ;
BLResult __cdecl blGradientSetType(BLGradientCore* self, uint32_t type) ;
double   __cdecl blGradientGetValue(const BLGradientCore* self, size_t index) ;
BLResult __cdecl blGradientSetValue(BLGradientCore* self, size_t index, double value) ;
BLResult __cdecl blGradientSetValues(BLGradientCore* self, size_t index, const double* values, size_t n) ;
uint32_t __cdecl blGradientGetExtendMode(BLGradientCore* self) ;
BLResult __cdecl blGradientSetExtendMode(BLGradientCore* self, uint32_t extendMode) ;
const BLGradientStop* __cdecl blGradientGetStops(const BLGradientCore* self) ;
size_t __cdecl blGradientGetSize(const BLGradientCore* self) ;
size_t __cdecl blGradientGetCapacity(const BLGradientCore* self) ;
BLResult __cdecl blGradientResetStops(BLGradientCore* self) ;
BLResult __cdecl blGradientAssignStops(BLGradientCore* self, const BLGradientStop* stops, size_t n) ;
BLResult __cdecl blGradientAddStopRgba32(BLGradientCore* self, double offset, uint32_t argb32) ;
BLResult __cdecl blGradientAddStopRgba64(BLGradientCore* self, double offset, uint64_t argb64) ;
BLResult __cdecl blGradientRemoveStop(BLGradientCore* self, size_t index) ;
BLResult __cdecl blGradientRemoveStopByOffset(BLGradientCore* self, double offset, uint32_t all) ;
BLResult __cdecl blGradientRemoveStops(BLGradientCore* self, const BLRange* range) ;
BLResult __cdecl blGradientRemoveStopsFromTo(BLGradientCore* self, double offsetMin, double offsetMax) ;
BLResult __cdecl blGradientReplaceStopRgba32(BLGradientCore* self, size_t index, double offset, uint32_t rgba32) ;
BLResult __cdecl blGradientReplaceStopRgba64(BLGradientCore* self, size_t index, double offset, uint64_t rgba64) ;
size_t   __cdecl blGradientIndexOfStop(const BLGradientCore* self, double offset) ;
BLResult __cdecl blGradientApplyMatrixOp(BLGradientCore* self, uint32_t opType, const void* opData) ;
bool     __cdecl blGradientEquals(const BLGradientCore* a, const BLGradientCore* b) ;

]]

ffi.cdef[[
//! \name BLImage

BLResult __cdecl blImageInit(BLImageCore* self) ;
BLResult __cdecl blImageInitAs(BLImageCore* self, int w, int h, uint32_t format) ;
BLResult __cdecl blImageInitAsFromData(BLImageCore* self, int w, int h, uint32_t format, void* pixelData, intptr_t stride, BLDestroyImplFunc destroyFunc, void* destroyData) ;
BLResult __cdecl blImageReset(BLImageCore* self) ;
BLResult __cdecl blImageAssignMove(BLImageCore* self, BLImageCore* other) ;
BLResult __cdecl blImageAssignWeak(BLImageCore* self, const BLImageCore* other) ;
BLResult __cdecl blImageAssignDeep(BLImageCore* self, const BLImageCore* other) ;
BLResult __cdecl blImageCreate(BLImageCore* self, int w, int h, uint32_t format) ;
BLResult __cdecl blImageCreateFromData(BLImageCore* self, int w, int h, uint32_t format, void* pixelData, intptr_t stride, BLDestroyImplFunc destroyFunc, void* destroyData) ;
BLResult __cdecl blImageGetData(const BLImageCore* self, BLImageData* dataOut) ;
BLResult __cdecl blImageMakeMutable(BLImageCore* self, BLImageData* dataOut) ;
bool     __cdecl blImageEquals(const BLImageCore* a, const BLImageCore* b) ;
BLResult __cdecl blImageScale(BLImageCore* dst, const BLImageCore* src, const BLSizeI* size, uint32_t filter, const BLImageScaleOptions* options) ;
BLResult __cdecl blImageReadFromFile(BLImageCore* self, const char* fileName, const BLArrayCore* codecs) ;
BLResult __cdecl blImageReadFromData(BLImageCore* self, const void* data, size_t size, const BLArrayCore* codecs) ;
BLResult __cdecl blImageWriteToFile(const BLImageCore* self, const char* fileName, const BLImageCodecCore* codec) ;
BLResult __cdecl blImageWriteToData(const BLImageCore* self, BLArrayCore* dst, const BLImageCodecCore* codec) ;

]]

ffi.cdef[[
//! \name BLImageCodec

BLResult __cdecl blImageCodecInit(BLImageCodecCore* self) ;
BLResult __cdecl blImageCodecReset(BLImageCodecCore* self) ;
BLResult __cdecl blImageCodecAssignWeak(BLImageCodecCore* self, const BLImageCodecCore* other) ;
BLResult __cdecl blImageCodecFindByName(BLImageCodecCore* self, const BLArrayCore* codecs, const char* name) ;
BLResult __cdecl blImageCodecFindByData(BLImageCodecCore* self, const BLArrayCore* codecs, const void* data, size_t size) ;
uint32_t __cdecl blImageCodecInspectData(const BLImageCodecCore* self, const void* data, size_t size) ;
BLResult __cdecl blImageCodecCreateDecoder(const BLImageCodecCore* self, BLImageDecoderCore* dst) ;
BLResult __cdecl blImageCodecCreateEncoder(const BLImageCodecCore* self, BLImageEncoderCore* dst) ;
BLArrayCore* __cdecl blImageCodecBuiltInCodecs(void) ;

]]

ffi.cdef[[
//! \name BLImageDecoder

BLResult __cdecl blImageDecoderInit(BLImageDecoderCore* self) ;
BLResult __cdecl blImageDecoderReset(BLImageDecoderCore* self) ;
BLResult __cdecl blImageDecoderAssignMove(BLImageDecoderCore* self, BLImageDecoderCore* other) ;
BLResult __cdecl blImageDecoderAssignWeak(BLImageDecoderCore* self, const BLImageDecoderCore* other) ;
BLResult __cdecl blImageDecoderRestart(BLImageDecoderCore* self) ;
BLResult __cdecl blImageDecoderReadInfo(BLImageDecoderCore* self, BLImageInfo* infoOut, const uint8_t* data, size_t size) ;
BLResult __cdecl blImageDecoderReadFrame(BLImageDecoderCore* self, BLImageCore* imageOut, const uint8_t* data, size_t size) ;

]]

ffi.cdef[[
//! \name BLImageEncoder

BLResult __cdecl blImageEncoderInit(BLImageEncoderCore* self) ;
BLResult __cdecl blImageEncoderReset(BLImageEncoderCore* self) ;
BLResult __cdecl blImageEncoderAssignMove(BLImageEncoderCore* self, BLImageEncoderCore* other) ;
BLResult __cdecl blImageEncoderAssignWeak(BLImageEncoderCore* self, const BLImageEncoderCore* other) ;
BLResult __cdecl blImageEncoderRestart(BLImageEncoderCore* self) ;
BLResult __cdecl blImageEncoderWriteFrame(BLImageEncoderCore* self, BLArrayCore* dst, const BLImageCore* image) ;

]]

ffi.cdef[[
//! \name BLMatrix2D

BLResult __cdecl blMatrix2DSetIdentity(BLMatrix2D* self) ;
BLResult __cdecl blMatrix2DSetTranslation(BLMatrix2D* self, double x, double y) ;
BLResult __cdecl blMatrix2DSetScaling(BLMatrix2D* self, double x, double y) ;
BLResult __cdecl blMatrix2DSetSkewing(BLMatrix2D* self, double x, double y) ;
BLResult __cdecl blMatrix2DSetRotation(BLMatrix2D* self, double angle, double cx, double cy) ;
BLResult __cdecl blMatrix2DApplyOp(BLMatrix2D* self, uint32_t opType, const void* opData) ;
BLResult __cdecl blMatrix2DInvert(BLMatrix2D* dst, const BLMatrix2D* src) ;
uint32_t __cdecl blMatrix2DGetType(const BLMatrix2D* self) ;
BLResult __cdecl blMatrix2DMapPointDArray(const BLMatrix2D* self, BLPoint* dst, const BLPoint* src, size_t count) ;

]]

ffi.cdef[[
//! \name BLPath

BLResult __cdecl blPathInit(BLPathCore* self) ;
BLResult __cdecl blPathReset(BLPathCore* self) ;
size_t   __cdecl blPathGetSize(const BLPathCore* self) ;
size_t   __cdecl blPathGetCapacity(const BLPathCore* self) ;
const uint8_t* __cdecl blPathGetCommandData(const BLPathCore* self) ;
const BLPoint* __cdecl blPathGetVertexdData(const BLPathCore* self) ;
BLResult __cdecl blPathClear(BLPathCore* self) ;
BLResult __cdecl blPathShrink(BLPathCore* self) ;
BLResult __cdecl blPathReserve(BLPathCore* self, size_t n) ;
BLResult __cdecl blPathModifyOp(BLPathCore* self, uint32_t op, size_t n, uint8_t** cmdDataOut, BLPoint** vtxDataOut) ;
BLResult __cdecl blPathAssignMove(BLPathCore* self, BLPathCore* other) ;
BLResult __cdecl blPathAssignWeak(BLPathCore* self, const BLPathCore* other) ;
BLResult __cdecl blPathAssignDeep(BLPathCore* self, const BLPathCore* other) ;
BLResult __cdecl blPathSetVertexAt(BLPathCore* self, size_t index, uint32_t cmd, double x, double y) ;
BLResult __cdecl blPathMoveTo(BLPathCore* self, double x0, double y0) ;
BLResult __cdecl blPathLineTo(BLPathCore* self, double x1, double y1) ;
BLResult __cdecl blPathPolyTo(BLPathCore* self, const BLPoint* poly, size_t count) ;
BLResult __cdecl blPathQuadTo(BLPathCore* self, double x1, double y1, double x2, double y2) ;
BLResult __cdecl blPathCubicTo(BLPathCore* self, double x1, double y1, double x2, double y2, double x3, double y3) ;
BLResult __cdecl blPathSmoothQuadTo(BLPathCore* self, double x2, double y2) ;
BLResult __cdecl blPathSmoothCubicTo(BLPathCore* self, double x2, double y2, double x3, double y3) ;
BLResult __cdecl blPathArcTo(BLPathCore* self, double x, double y, double rx, double ry, double start, double sweep, bool forceMoveTo) ;
BLResult __cdecl blPathArcQuadrantTo(BLPathCore* self, double x1, double y1, double x2, double y2) ;
BLResult __cdecl blPathEllipticArcTo(BLPathCore* self, double rx, double ry, double xAxisRotation, bool largeArcFlag, bool sweepFlag, double x1, double y1) ;
BLResult __cdecl blPathClose(BLPathCore* self) ;
BLResult __cdecl blPathAddGeometry(BLPathCore* self, uint32_t geometryType, const void* geometryData, const BLMatrix2D* m, uint32_t dir) ;
BLResult __cdecl blPathAddBoxI(BLPathCore* self, const BLBoxI* box, uint32_t dir) ;
BLResult __cdecl blPathAddBoxD(BLPathCore* self, const BLBox* box, uint32_t dir) ;
BLResult __cdecl blPathAddRectI(BLPathCore* self, const BLRectI* rect, uint32_t dir) ;
BLResult __cdecl blPathAddRectD(BLPathCore* self, const BLRect* rect, uint32_t dir) ;
BLResult __cdecl blPathAddPath(BLPathCore* self, const BLPathCore* other, const BLRange* range) ;
BLResult __cdecl blPathAddTranslatedPath(BLPathCore* self, const BLPathCore* other, const BLRange* range, const BLPoint* p) ;
BLResult __cdecl blPathAddTransformedPath(BLPathCore* self, const BLPathCore* other, const BLRange* range, const BLMatrix2D* m) ;
BLResult __cdecl blPathAddReversedPath(BLPathCore* self, const BLPathCore* other, const BLRange* range, uint32_t reverseMode) ;
BLResult __cdecl blPathAddStrokedPath(BLPathCore* self, const BLPathCore* other, const BLRange* range, const BLStrokeOptionsCore* options, const BLApproximationOptions* approx) ;
BLResult __cdecl blPathTranslate(BLPathCore* self, const BLRange* range, const BLPoint* p) ;
BLResult __cdecl blPathTransform(BLPathCore* self, const BLRange* range, const BLMatrix2D* m) ;
BLResult __cdecl blPathFitTo(BLPathCore* self, const BLRange* range, const BLRect* rect, uint32_t fitFlags) ;
bool     __cdecl blPathEquals(const BLPathCore* a, const BLPathCore* b) ;
BLResult __cdecl blPathGetInfoFlags(const BLPathCore* self, uint32_t* flagsOut) ;
BLResult __cdecl blPathGetControlBox(const BLPathCore* self, BLBox* boxOut) ;
BLResult __cdecl blPathGetBoundingBox(const BLPathCore* self, BLBox* boxOut) ;
BLResult __cdecl blPathGetFigureRange(const BLPathCore* self, size_t index, BLRange* rangeOut) ;
BLResult __cdecl blPathGetLastVertex(const BLPathCore* self, BLPoint* vtxOut) ;
BLResult __cdecl blPathGetClosestVertex(const BLPathCore* self, const BLPoint* p, double maxDistance, size_t* indexOut, double* distanceOut) ;
uint32_t __cdecl blPathHitTest(const BLPathCore* self, const BLPoint* p, uint32_t fillRule) ;

]]

ffi.cdef[[
//! \name BLPattern

BLResult __cdecl blPatternInit(BLPatternCore* self) ;
BLResult __cdecl blPatternInitAs(BLPatternCore* self, const BLImageCore* image, const BLRectI* area, uint32_t extendMode, const BLMatrix2D* m) ;
BLResult __cdecl blPatternReset(BLPatternCore* self) ;
BLResult __cdecl blPatternAssignMove(BLPatternCore* self, BLPatternCore* other) ;
BLResult __cdecl blPatternAssignWeak(BLPatternCore* self, const BLPatternCore* other) ;
BLResult __cdecl blPatternAssignDeep(BLPatternCore* self, const BLPatternCore* other) ;
BLResult __cdecl blPatternCreate(BLPatternCore* self, const BLImageCore* image, const BLRectI* area, uint32_t extendMode, const BLMatrix2D* m) ;
BLResult __cdecl blPatternSetImage(BLPatternCore* self, const BLImageCore* image, const BLRectI* area) ;
BLResult __cdecl blPatternSetArea(BLPatternCore* self, const BLRectI* area) ;
BLResult __cdecl blPatternSetExtendMode(BLPatternCore* self, uint32_t extendMode) ;
BLResult __cdecl blPatternApplyMatrixOp(BLPatternCore* self, uint32_t opType, const void* opData) ;
bool     __cdecl blPatternEquals(const BLPatternCore* a, const BLPatternCore* b) ;

]]

ffi.cdef[[
//! \name BLPixelConverter

BLResult __cdecl blPixelConverterInit(BLPixelConverterCore* self) ;
BLResult __cdecl blPixelConverterInitWeak(BLPixelConverterCore* self, const BLPixelConverterCore* other) ;
BLResult __cdecl blPixelConverterReset(BLPixelConverterCore* self) ;
BLResult __cdecl blPixelConverterAssign(BLPixelConverterCore* self, const BLPixelConverterCore* other) ;
BLResult __cdecl blPixelConverterCreate(BLPixelConverterCore* self, const BLFormatInfo* dstInfo, const BLFormatInfo* srcInfo) ;

BLResult __cdecl blPixelConverterConvert(const BLPixelConverterCore* self,
  void* dstData, intptr_t dstStride,
  const void* srcData, intptr_t srcStride,
  uint32_t w, uint32_t h, const BLPixelConverterOptions* options) ;

]]

ffi.cdef[[
//! \name BLRandom

void     __cdecl blRandomReset(BLRandom* self, uint64_t seed) ;
uint32_t __cdecl blRandomNextUInt32(BLRandom* self) ;
uint64_t __cdecl blRandomNextUInt64(BLRandom* self) ;
double   __cdecl blRandomNextDouble(BLRandom* self) ;

]]

ffi.cdef[[
//! \name BLRegion

BLResult __cdecl blRegionInit(BLRegionCore* self) ;
BLResult __cdecl blRegionReset(BLRegionCore* self) ;
BLResult __cdecl blRegionClear(BLRegionCore* self) ;
BLResult __cdecl blRegionShrink(BLRegionCore* self) ;
BLResult __cdecl blRegionReserve(BLRegionCore* self, size_t n) ;
BLResult __cdecl blRegionAssignMove(BLRegionCore* self, BLRegionCore* other) ;
BLResult __cdecl blRegionAssignWeak(BLRegionCore* self, const BLRegionCore* other) ;
BLResult __cdecl blRegionAssignDeep(BLRegionCore* self, const BLRegionCore* other) ;
BLResult __cdecl blRegionAssignBoxI(BLRegionCore* self, const BLBoxI* src) ;
BLResult __cdecl blRegionAssignBoxIArray(BLRegionCore* self, const BLBoxI* data, size_t n) ;
BLResult __cdecl blRegionAssignRectI(BLRegionCore* self, const BLRectI* rect) ;
BLResult __cdecl blRegionAssignRectIArray(BLRegionCore* self, const BLRectI* data, size_t n) ;
BLResult __cdecl blRegionCombine(BLRegionCore* self, const BLRegionCore* a, const BLRegionCore* b, uint32_t op) ;
BLResult __cdecl blRegionCombineRB(BLRegionCore* self, const BLRegionCore* a, const BLBoxI* b, uint32_t op) ;
BLResult __cdecl blRegionCombineBR(BLRegionCore* self, const BLBoxI* a, const BLRegionCore* b, uint32_t op) ;
BLResult __cdecl blRegionCombineBB(BLRegionCore* self, const BLBoxI* a, const BLBoxI* b, uint32_t op) ;
BLResult __cdecl blRegionTranslate(BLRegionCore* self, const BLRegionCore* r, const BLPointI* pt) ;
BLResult __cdecl blRegionTranslateAndClip(BLRegionCore* self, const BLRegionCore* r, const BLPointI* pt, const BLBoxI* clipBox) ;
BLResult __cdecl blRegionIntersectAndClip(BLRegionCore* self, const BLRegionCore* a, const BLRegionCore* b, const BLBoxI* clipBox) ;
bool     __cdecl blRegionEquals(const BLRegionCore* a, const BLRegionCore* b) ;
uint32_t __cdecl blRegionGetType(const BLRegionCore* self) ;
uint32_t __cdecl blRegionHitTest(const BLRegionCore* self, const BLPointI* pt) ;
uint32_t __cdecl blRegionHitTestBoxI(const BLRegionCore* self, const BLBoxI* box) ;

]]

ffi.cdef[[
//! \name BLRuntime

BLResult __cdecl blRuntimeInit() ;
BLResult __cdecl blRuntimeShutdown() ;
BLResult __cdecl blRuntimeCleanup(uint32_t cleanupFlags) ;
BLResult __cdecl blRuntimeQueryInfo(uint32_t infoType, void* infoOut) ;
BLResult __cdecl blRuntimeMessageOut(const char* msg) ;
BLResult __cdecl blRuntimeMessageFmt(const char* fmt, ...) ;
BLResult __cdecl blRuntimeMessageVFmt(const char* fmt, va_list ap) ;
uint32_t __cdecl blRuntimeGetTickCount(void) ;
]]

ffi.cdef[[
 void __cdecl blRuntimeAssertionFailure(const char* file, int line, const char* msg) ;
]]


if _WIN32 then
ffi.cdef[[
BLResult __cdecl blResultFromWinError(uint32_t e) ;
]]
else
ffi.cdef[[
BLResult __cdecl blResultFromPosixError(int e) ;
]]
end

ffi.cdef[[
//! \name BLString

BLResult __cdecl blStringInit(BLStringCore* self) ;
BLResult __cdecl blStringReset(BLStringCore* self) ;
size_t   __cdecl blStringGetSize(const BLStringCore* self) ;
size_t   __cdecl blStringGetCapacity(const BLStringCore* self) ;
const char* __cdecl blStringGetData(const BLStringCore* self) ;
BLResult __cdecl blStringClear(BLStringCore* self) ;
BLResult __cdecl blStringShrink(BLStringCore* self) ;
BLResult __cdecl blStringReserve(BLStringCore* self, size_t n) ;
BLResult __cdecl blStringResize(BLStringCore* self, size_t n, char fill) ;
BLResult __cdecl blStringMakeMutable(BLStringCore* self, char** dataOut) ;
BLResult __cdecl blStringModifyOp(BLStringCore* self, uint32_t op, size_t n, char** dataOut) ;
BLResult __cdecl blStringInsertOp(BLStringCore* self, size_t index, size_t n, char** dataOut) ;
BLResult __cdecl blStringAssignMove(BLStringCore* self, BLStringCore* other) ;
BLResult __cdecl blStringAssignWeak(BLStringCore* self, const BLStringCore* other) ;
BLResult __cdecl blStringAssignDeep(BLStringCore* self, const BLStringCore* other) ;
BLResult __cdecl blStringAssignData(BLStringCore* self, const char* str, size_t n) ;
BLResult __cdecl blStringApplyOpChar(BLStringCore* self, uint32_t op, char c, size_t n) ;
BLResult __cdecl blStringApplyOpData(BLStringCore* self, uint32_t op, const char* str, size_t n) ;
BLResult __cdecl blStringApplyOpString(BLStringCore* self, uint32_t op, const BLStringCore* other) ;
BLResult __cdecl blStringApplyOpFormat(BLStringCore* self, uint32_t op, const char* fmt, ...) ;
BLResult __cdecl blStringApplyOpFormatV(BLStringCore* self, uint32_t op, const char* fmt, va_list ap) ;
BLResult __cdecl blStringInsertChar(BLStringCore* self, size_t index, char c, size_t n) ;
BLResult __cdecl blStringInsertData(BLStringCore* self, size_t index, const char* str, size_t n) ;
BLResult __cdecl blStringInsertString(BLStringCore* self, size_t index, const BLStringCore* other) ;
BLResult __cdecl blStringRemoveRange(BLStringCore* self, const BLRange* range) ;
bool     __cdecl blStringEquals(const BLStringCore* self, const BLStringCore* other) ;
bool     __cdecl blStringEqualsData(const BLStringCore* self, const char* str, size_t n) ;
int      __cdecl blStringCompare(const BLStringCore* self, const BLStringCore* other) ;
int      __cdecl blStringCompareData(const BLStringCore* self, const char* str, size_t n) ;

]]

ffi.cdef[[
//! \name BLStrokeOptions

BLResult __cdecl blStrokeOptionsInit(BLStrokeOptionsCore* self) ;
BLResult __cdecl blStrokeOptionsInitMove(BLStrokeOptionsCore* self, BLStrokeOptionsCore* other) ;
BLResult __cdecl blStrokeOptionsInitWeak(BLStrokeOptionsCore* self, const BLStrokeOptionsCore* other) ;
BLResult __cdecl blStrokeOptionsReset(BLStrokeOptionsCore* self) ;
BLResult __cdecl blStrokeOptionsAssignMove(BLStrokeOptionsCore* self, BLStrokeOptionsCore* other) ;
BLResult __cdecl blStrokeOptionsAssignWeak(BLStrokeOptionsCore* self, const BLStrokeOptionsCore* other) ;

]]

ffi.cdef[[
//! \name BLVariant

BLResult __cdecl blVariantInit(void* self) ;
BLResult __cdecl blVariantInitMove(void* self, void* other) ;
BLResult __cdecl blVariantInitWeak(void* self, const void* other) ;
BLResult __cdecl blVariantReset(void* self) ;
uint32_t __cdecl blVariantGetImplType(const void* self) ;
BLResult __cdecl blVariantAssignMove(void* self, void* other) ;
BLResult __cdecl blVariantAssignWeak(void* self, const void* other) ;
bool     __cdecl blVariantEquals(const void* a, const void* b) ;

]]




return ffi.load("blend2d")