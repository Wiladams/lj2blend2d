--[[
// [Blend2D]
// 2D Vector Graphics Powered by a JIT Compiler.
//
// [License]
// ZLIB - See LICENSE.md file in the package.
--]]

local ffi = require("ffi")

if not  BLEND2D_BLIMAGE_H then
BLEND2D_BLIMAGE_H = true

require("blend2d.blarray")
require("blend2d.blformat")
require("blend2d.blgeometry")
require("blend2d.blvariant")



ffi.cdef[[
// ============================================================================
// [Constants]
// ============================================================================

//! Image codec feature bits.
enum BLImageCodecFeatures {
  //! Image codec supports reading images (can create BLImageDecoder).
  BL_IMAGE_CODEC_FEATURE_READ                 = 0x00000001u,
  //! Image codec supports writing images (can create BLImageEncoder).
  BL_IMAGE_CODEC_FEATURE_WRITE                = 0x00000002u,
  //! Image codec supports lossless compression.
  BL_IMAGE_CODEC_FEATURE_LOSSLESS             = 0x00000004u,
  //! Image codec supports loosy compression.
  BL_IMAGE_CODEC_FEATURE_LOSSY                = 0x00000008u,
  //! Image codec supports writing multiple frames (GIF).
  BL_IMAGE_CODEC_FEATURE_MULTI_FRAME          = 0x00000010u,
  //! Image codec supports IPTC metadata.
  BL_IMAGE_CODEC_FEATURE_IPTC                 = 0x10000000u,
  //! Image codec supports EXIF metadata.
  BL_IMAGE_CODEC_FEATURE_EXIF                 = 0x20000000u,
  //! Image codec supports XMP metadata.
  BL_IMAGE_CODEC_FEATURE_XMP                  = 0x40000000u
};
]]

ffi.cdef[[
//! Flags used by `BLImageInfo`.
enum BLImageInfoFlags {
  //! Progressive mode.
  BL_IMAGE_INFO_FLAG_PROGRESSIVE              = 0x00000001u
};
]]

ffi.cdef[[
//! Filter type used by `BLImage::scale()`.
enum BLImageScaleFilter {
  //! No filter or uninitialized.
  BL_IMAGE_SCALE_FILTER_NONE = 0,
  //! Nearest neighbor filter (radius 1.0).
  BL_IMAGE_SCALE_FILTER_NEAREST = 1,
  //! Bilinear filter (radius 1.0).
  BL_IMAGE_SCALE_FILTER_BILINEAR = 2,
  //! Bicubic filter (radius 2.0).
  BL_IMAGE_SCALE_FILTER_BICUBIC = 3,
  //! Bell filter (radius 1.5).
  BL_IMAGE_SCALE_FILTER_BELL = 4,
  //! Gauss filter (radius 2.0).
  BL_IMAGE_SCALE_FILTER_GAUSS = 5,
  //! Hermite filter (radius 1.0).
  BL_IMAGE_SCALE_FILTER_HERMITE = 6,
  //! Hanning filter (radius 1.0).
  BL_IMAGE_SCALE_FILTER_HANNING = 7,
  //! Catrom filter (radius 2.0).
  BL_IMAGE_SCALE_FILTER_CATROM = 8,
  //! Bessel filter (radius 3.2383).
  BL_IMAGE_SCALE_FILTER_BESSEL = 9,
  //! Sinc filter (radius 2.0, adjustable through `BLImageScaleOptions`).
  BL_IMAGE_SCALE_FILTER_SINC = 10,
  //! Lanczos filter (radius 2.0, adjustable through `BLImageScaleOptions`).
  BL_IMAGE_SCALE_FILTER_LANCZOS = 11,
  //! Blackman filter (radius 2.0, adjustable through `BLImageScaleOptions`).
  BL_IMAGE_SCALE_FILTER_BLACKMAN = 12,
  //! Mitchell filter (radius 2.0, parameters 'b' and 'c' passed through `BLImageScaleOptions`).
  BL_IMAGE_SCALE_FILTER_MITCHELL = 13,
  //! Filter using a user-function, must be passed through `BLImageScaleOptions`.
  BL_IMAGE_SCALE_FILTER_USER = 14,

  //! Count of image-scale filters.
  BL_IMAGE_SCALE_FILTER_COUNT = 15
};
]]

ffi.cdef[[
// ============================================================================
// [Typedefs]
// ============================================================================

//! A user function that can be used by `BLImage::scale()`.
typedef BLResult (__cdecl* BLImageScaleUserFunc)(double* dst, const double* tArray, size_t n, const void* data) ;
]]

ffi.cdef[[
// ============================================================================
// [BLImageData]
// ============================================================================

//! Data that describes a raster image. Used by `BLImage`.
struct BLImageData {
  void* pixelData;
  intptr_t stride;
  BLSizeI size;
  uint32_t format;
  uint32_t flags;

};
]]

ffi.cdef[[
// ============================================================================
// [BLImageInfo]
// ============================================================================

//! Image information provided by image codecs.
struct BLImageInfo {
  //! Image size.
  BLSizeI size;
  //! Pixel density per one meter, can contain fractions.
  BLSize density;

  //! Image flags.
  uint32_t flags;
  //! Image depth.
  uint16_t depth;
  //! Number of planes.
  uint16_t planeCount;
  //! Number of frames (0 = unknown/unspecified).
  uint64_t frameCount;

  //! Image format (as understood by codec).
  char format[16];
  //! Image compression (as understood by codec).
  char compression[16];
};
]]

ffi.cdef[[
// ============================================================================
// [BLImageScaleOptions]
// ============================================================================

//! Options that can used to customize image scaling.
struct BLImageScaleOptions {
  BLImageScaleUserFunc userFunc;
  void* userData;

  double radius;
  union {
    double data[3];
    struct {
      double b, c;
    } mitchell;
  };

};
]]


ffi.cdef[[
// ============================================================================
// [BLImage - Core]
// ============================================================================

//! Image [C Interface - Impl].
struct BLImageImpl {
  //! Pixel data.
  void* pixelData;
  //! Image stride.
  intptr_t stride;
  //! Non-null if the image has a writer.
  volatile void* writer;

  //! Reference count.
  volatile size_t refCount;
  //! Impl type.
  uint8_t implType;
  //! Impl traits.
  uint8_t implTraits;
  //! Memory pool data.
  uint16_t memPoolData;

  //! Image format.
  uint8_t format;
  //! Image flags.
  uint8_t flags;
  //! Image depth (in bits).
  uint16_t depth;
  //! Image size.
  BLSizeI size;
};

//! Image [C Interface - Core].
struct BLImageCore {
  BLImageImpl* impl;
};
]]

ffi.cdef[[
// ============================================================================
// [BLImageCodec - Core]
// ============================================================================

//! Image codec [C Interface - Virtual Function Table].
struct BLImageCodecVirt {
  BLResult (__cdecl* destroy)(BLImageCodecImpl* impl) ;
  uint32_t (__cdecl* inspectData)(const BLImageCodecImpl* impl, const uint8_t* data, size_t size) ;
  BLResult (__cdecl* createDecoder)(const BLImageCodecImpl* impl, BLImageDecoderCore* dst) ;
  BLResult (__cdecl* createEncoder)(const BLImageCodecImpl* impl, BLImageEncoderCore* dst) ;
};

//! Image codec [C Interface - Impl].
struct BLImageCodecImpl {
  //! Virtual function table.
  const BLImageCodecVirt* virt;
  //! Image codec name like "PNG", "JPEG", etc...
  const char* name;
  //! Image codec vendor, built-in codecs use "Blend2D".
  const char* vendor;

  //! Reference count.
  volatile size_t refCount;
  //! Impl type.
  uint8_t implType;
  //! Impl traits.
  uint8_t implTraits;
  //! Memory pool data.
  uint16_t memPoolData;

  //! Image codec features.
  uint32_t features;
  //! Mime type.
  const char* mimeType;
  //! Known file extensions used by this image codec separated by "|".
  const char* extensions;
};

//! Image codec [C Interface - Core].
struct BLImageCodecCore {
  BLImageCodecImpl* impl;
};
]]


ffi.cdef[[
//! Image decoder [C Interface - Virtual Function Table].
struct BLImageDecoderVirt {
  BLResult (__cdecl* destroy)(BLImageDecoderImpl* impl) ;
  BLResult (__cdecl* restart)(BLImageDecoderImpl* impl) ;
  BLResult (__cdecl* readInfo)(BLImageDecoderImpl* impl, BLImageInfo* infoOut, const uint8_t* data, size_t size) ;
  BLResult (__cdecl* readFrame)(BLImageDecoderImpl* impl, BLImageCore* imageOut, const uint8_t* data, size_t size) ;
};
]]

--[=[
    -- BUGBUG, BLImageCodec is only a class, no strict 'C' implementation
ffi.cdef[[
//! Image decoder [C Interface - Impl].
struct BLImageDecoderImpl {
  //! Virtual function table.
  const BLImageDecoderVirt* virt;
  //! Image codec that created this decoder.
  //BL_TYPED_MEMBER(BLImageCodecCore, BLImageCodec, codec);
  union {BLImageCodec codec;};

  //! Handle in case that this decoder wraps a thirt-party library.
  void* handle;

  //! Reference count.
  volatile size_t refCount;
  //! Impl type.
  uint8_t implType;
  //! Impl traits.
  uint8_t implTraits;
  //! Memory pool data.
  uint16_t memPoolData;

  //! Last faulty result (if failed).
  BLResult lastResult;
  //! Current frame index.
  uint64_t frameIndex;
  //! Position in source buffer.
  size_t bufferIndex;

};
]]

ffi.cdef[[
//! Image decoder [C Interface - Core]
struct BLImageDecoderCore {
  BLImageDecoderImpl* impl;
};
]]


ffi.cdef[[
// ============================================================================
// [BLImageEncoder - Core]
// ============================================================================

//! Image encoder [C Interface - Virtual Function Table].
struct BLImageEncoderVirt {
  BLResult (__cdecl* destroy)(BLImageEncoderImpl* impl) ;
  BLResult (__cdecl* restart)(BLImageEncoderImpl* impl) ;
  BLResult (__cdecl* writeFrame)(BLImageEncoderImpl* impl, BLArrayCore* dst, const BLImageCore* image) ;
};

//! Image encoder [C Interface - Impl].
struct BLImageEncoderImpl {
  //! Virtual function table.
  const BLImageEncoderVirt* virt;
  //! Image codec that created this encoder.
  //BL_TYPED_MEMBER(BLImageCodecCore, BLImageCodec, codec);
  union {BLImageCodec codec };

  //! Handle in case that this encoder wraps a thirt-party library.
  void* handle;

  //! Reference count.
  volatile size_t refCount;
  //! Impl type.
  uint8_t implType;
  //! Impl traits.
  uint8_t implTraits;
  //! Memory pool data.
  uint16_t memPoolData;

  //! Last faulty result (if failed).
  BLResult lastResult;
  //! Current frame index.
  uint64_t frameIndex;
  //! Position in source buffer.
  size_t bufferIndex;
};

//! Image encoder [C Interface - Core].
struct BLImageEncoderCore {
  BLImageEncoderImpl* impl;
};
]]
--]=]

end -- BLEND2D_BLIMAGE_H
