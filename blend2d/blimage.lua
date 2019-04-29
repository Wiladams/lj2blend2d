--[[
// [Blend2D]
// 2D Vector Graphics Powered by a JIT Compiler.
//
// [License]
// ZLIB - See LICENSE.md file in the package.
--]]

local ffi = require("ffi")
local C = ffi.C 

if not  BLEND2D_BLIMAGE_H then
BLEND2D_BLIMAGE_H = true

local blapi = require("blend2d.blapi")

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

//! Image [C Interface - Impl].
struct BLImageImpl {

  void* pixelData;
  intptr_t stride;
  volatile void* writer;
  volatile size_t refCount;
  uint8_t implType;
  uint8_t implTraits;
  uint16_t memPoolData;


  uint8_t format;
  uint8_t flags;
  uint16_t depth;
  BLSizeI size;
};

//! Image [C Interface - Core].
struct BLImageCore {
  BLImageImpl* impl;
};
]]
BLImage = ffi.typeof("struct BLImageCore")
BLImageCore = BLImage
BLImage_mt = {
  __gc = function(self)
      blapi.blImageReset(self)
  end;
--[[
BLResult __cdecl blImageInitAs(BLImageCore* self, int w, int h, uint32_t format) ;
BLResult __cdecl blImageInitAsFromData(BLImageCore* self, int w, int h, uint32_t format, void* pixelData, intptr_t stride, BLDestroyImplFunc destroyFunc, void* destroyData) ;
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

--]]
    __new = function(ct, ...)
      --print("BLImageCore.__new: ",...)
      local nargs = select('#', ...)
      local obj = ffi.new(ct)
      local bResult = -1;

      if nargs == 0 then
        -- default constructor
        bResult = blapi.blImageInit(obj)
      elseif nargs == 2 then
        -- width, height
        local width = select(1,...)
        local height = select(2,...)
        bResult = blapi.blImageInitAs(obj, width, height, C.BL_FORMAT_PRGB32)
        --print("BLImage.__new: ", bResult, width, height)
      elseif nargs == 3 then
        -- width, height, format
        bResult = blapi.blImageInitAs(obj, select(1,...), select(2,...), select(3,...))
      elseif nargs == 7 then
        -- w, h, format, pixelData, stride, destroyFunc, destroyData
        bResult = blapi.blImageInitAsFromData(obj, select(1,...), select(2,...), select(3,...), select(4,...), select(5,...), select(6,...), select(7,...))
      end

      if bResult ~= C.BL_SUCCESS then
          return false, bResult;
      end

      --print("BLImageCore.__new, constructor: ", nargs, bResult)
      return obj
    end;


    __index = {
        size = function(self)
          return self.impl.size;
        end;
        
        -- int w, int h, uint32_t format, void* pixelData, intptr_t stride, BLDestroyImplFunc destroyFunc, void* destroyData
        fromData = function(ct, w, h, format, pixelData, stride, destroyFunc, destroyData)

            local obj = ffi.new(ct)

            local bResult = blapi.blImageInitAsFromData(obj, w, h, format, pixelData, stride, destroyFunc, destroyData) 

            if bResult ~= 0 then
                return false, bResult
            end

            return obj
        end;
--[[
        writeToFile = function(self, fileName, codec) 
          local bResult = blapi.blImageWriteToFile(self, fileName, codec)
          return bResult == 0 or bResult
        end;

        readFromFile = function(self, fileName, codecs)
            codecs = codecs or blapi.blImageCodecBuiltInCodecs()
            local bResult = blapi.blImageReadFromFile(self, fileName, codecs) ;

            if bResult == C.BL_SUCCESS then
                return true
            end

            return false, bResult
        end;
--]]
    };

    __tostring = function(self)
      return string.format("BLImage(%d,%d)", self.impl.size.w, self.impl.size.h)
    end;
}
ffi.metatype(BLImage, BLImage_mt)







ffi.cdef[[
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
  size_t refCount;
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
BLImageCodec = ffi.typeof("BLImageCodecCore")
BLImageCodecCore = BLImageCodec
local BLImageCodec_mt = {
  __gc = function(self)
    blapi.blImageCodecReset(self)
  end;

  __new = function (ct, moniker, codecs)
    local obj = ffi.new(ct)
    local bResult = blapi.blImageCodecInit(obj);
    if bResult ~= C.BL_SUCCESS then
        return false, bResult;
    end

    if moniker then
      codecs = codecs or blapi.blImageCodecBuiltInCodecs();
      local bResult = blapi.blImageCodecFindByName(obj, codecs, moniker) ;
      
      if bResult ~= C.BL_SUCCESS then
        return false, bResult;
      end
    end


    return obj;
  end;
--[[

BLResult __cdecl blImageCodecAssignWeak(BLImageCodecCore* self, const BLImageCodecCore* other) ;
BLResult __cdecl blImageCodecFindByName(BLImageCodecCore* self, const BLArrayCore* codecs, const char* name) ;
BLResult __cdecl blImageCodecFindByData(BLImageCodecCore* self, const BLArrayCore* codecs, const void* data, size_t size) ;
uint32_t __cdecl blImageCodecInspectData(const BLImageCodecCore* self, const void* data, size_t size) ;
BLResult __cdecl blImageCodecCreateDecoder(const BLImageCodecCore* self, BLImageDecoderCore* dst) ;
BLResult __cdecl blImageCodecCreateEncoder(const BLImageCodecCore* self, BLImageEncoderCore* dst) ;
BLArrayCore* __cdecl blImageCodecBuiltInCodecs(void) ;
]]
  __index = {
      findByName = function(self, name, codecs)
          local obj = BLImageCodec();
          codecs = codecs or blapi.blImageCodecBuiltInCodecs();
          local bResult = blapi.blImageCodecFindByName(obj, codecs, name) ;

          if bResult ~= C.BL_SUCCESS then
              return false, bResult;
          end

          return obj;
      end;

      writeImageToFile = function(self, img, fileName)
        local bResult = blapi.blImageWriteToFile(img, fileName, self)
        return bResult == 0 or bResult
      end;

      readImageFromFile = function(ct, fileName, codecs)
        --print("readImageFromFile: ", tc, fileName, codecs)

          local img = BLImage();
          codecs = codecs or blapi.blImageCodecBuiltInCodecs()
          local bResult = blapi.blImageReadFromFile(img, fileName, codecs) ;

          if bResult ~= C.BL_SUCCESS then
              return false, bResult
          end

          return img
      end;
  };
}
ffi.metatype(BLImageCodec, BLImageCodec_mt)



ffi.cdef[[
//! Image decoder [C Interface - Virtual Function Table].
struct BLImageDecoderVirt {
  BLResult (__cdecl* destroy)(BLImageDecoderImpl* impl) ;
  BLResult (__cdecl* restart)(BLImageDecoderImpl* impl) ;
  BLResult (__cdecl* readInfo)(BLImageDecoderImpl* impl, BLImageInfo* infoOut, const uint8_t* data, size_t size) ;
  BLResult (__cdecl* readFrame)(BLImageDecoderImpl* impl, BLImageCore* imageOut, const uint8_t* data, size_t size) ;
};
]]

---[=[
    -- BUGBUG, BLImageCodec is only a class, no strict 'C' implementation
ffi.cdef[[
//! Image decoder [C Interface - Impl].
struct BLImageDecoderImpl {
  //! Virtual function table.
  const BLImageDecoderVirt* virt;
  //! Image codec that created this decoder.
  //BL_TYPED_MEMBER(BLImageCodecCore, BLImageCodec, codec);
  union {BLImageCodecCore codec;};

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
  union {BLImageCodecCore codec; };

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


end -- BLEND2D_BLIMAGE_H
