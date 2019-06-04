local ffi = require("ffi")

ffi.cdef[[
typedef struct BLRange BLRange;
typedef struct BLRandom BLRandom;
typedef struct BLCreateForeignInfo BLCreateForeignInfo;
typedef struct BLFileCore BLFileCore;
typedef struct BLRuntimeBuildInfo BLRuntimeBuildInfo;
typedef struct BLRuntimeSystemInfo BLRuntimeSystemInfo;
typedef struct BLRuntimeMemoryInfo BLRuntimeMemoryInfo;
typedef struct BLStringCore BLStringCore;
typedef struct BLStringImpl BLStringImpl;
typedef struct BLArrayCore BLArrayCore;
typedef struct BLArrayImpl BLArrayImpl;
typedef struct BLVariantCore BLVariantCore;
typedef struct BLVariantImpl BLVariantImpl;
typedef struct BLPointI BLPointI;
typedef struct BLPoint BLPoint;
typedef struct BLSizeI BLSizeI;
typedef struct BLSize BLSize;
typedef struct BLBoxI BLBoxI;
typedef struct BLBox BLBox;
typedef struct BLRectI BLRectI;
typedef struct BLRect BLRect;
typedef struct BLLine BLLine;
typedef struct BLTriangle BLTriangle;
typedef struct BLRoundRect BLRoundRect;
typedef struct BLCircle BLCircle;
typedef struct BLEllipse BLEllipse;
typedef struct BLArc BLArc;
typedef struct BLMatrix2D BLMatrix2D;
typedef struct BLPathCore BLPathCore;
typedef struct BLPathImpl BLPathImpl;
typedef struct BLPathView BLPathView;
typedef struct BLRegionCore BLRegionCore;
typedef struct BLRegionImpl BLRegionImpl;
typedef struct BLApproximationOptions BLApproximationOptions;
typedef struct BLStrokeOptionsCore BLStrokeOptionsCore;
typedef struct BLFormatInfo BLFormatInfo;
typedef struct BLImageCore BLImageCore;
typedef struct BLImageImpl BLImageImpl;
typedef struct BLImageData BLImageData;
typedef struct BLImageInfo BLImageInfo;
typedef struct BLImageScaleOptions BLImageScaleOptions;
typedef struct BLPixelConverterCore BLPixelConverterCore;
typedef struct BLPixelConverterOptions BLPixelConverterOptions;
typedef struct BLImageCodecCore BLImageCodecCore;
typedef struct BLImageCodecImpl BLImageCodecImpl;
typedef struct BLImageCodecVirt BLImageCodecVirt;
typedef struct BLImageDecoderCore BLImageDecoderCore;
typedef struct BLImageDecoderImpl BLImageDecoderImpl;
typedef struct BLImageDecoderVirt BLImageDecoderVirt;
typedef struct BLImageEncoderCore BLImageEncoderCore;
typedef struct BLImageEncoderImpl BLImageEncoderImpl;
typedef struct BLImageEncoderVirt BLImageEncoderVirt;
typedef struct BLRgba32 BLRgba32;
typedef struct BLRgba64 BLRgba64;
typedef struct BLRgba128 BLRgba128;
typedef struct BLGradientCore BLGradientCore;
typedef struct BLGradientImpl BLGradientImpl;
typedef struct BLGradientStop BLGradientStop;
typedef struct BLLinearGradientValues BLLinearGradientValues;
typedef struct BLRadialGradientValues BLRadialGradientValues;
typedef struct BLConicalGradientValues BLConicalGradientValues;
typedef struct BLPatternCore BLPatternCore;
typedef struct BLPatternImpl BLPatternImpl;
typedef struct BLContextCore BLContextCore;
typedef struct BLContextImpl BLContextImpl;
typedef struct BLContextVirt BLContextVirt;
typedef struct BLContextCookie BLContextCookie;
typedef struct BLContextCreateInfo BLContextCreateInfo;
typedef struct BLContextHints BLContextHints;
typedef struct BLContextState BLContextState;
typedef struct BLGlyphBufferCore BLGlyphBufferCore;
typedef struct BLGlyphBufferImpl BLGlyphBufferImpl;
typedef struct BLGlyphInfo BLGlyphInfo;
typedef struct BLGlyphItem BLGlyphItem;
typedef struct BLGlyphMappingState BLGlyphMappingState;
typedef struct BLGlyphOutlineSinkInfo BLGlyphOutlineSinkInfo;
typedef struct BLGlyphPlacement BLGlyphPlacement;
typedef struct BLGlyphRun BLGlyphRun;
typedef struct BLFontUnicodeCoverage BLFontUnicodeCoverage;
typedef struct BLFontFaceInfo BLFontFaceInfo;
typedef struct BLFontFeature BLFontFeature;
typedef struct BLFontDesignMetrics BLFontDesignMetrics;
typedef struct BLFontMatrix BLFontMatrix;
typedef struct BLFontMetrics BLFontMetrics;
typedef struct BLFontPanose BLFontPanose;
typedef struct BLFontTable BLFontTable;
typedef struct BLFontVariation BLFontVariation;
typedef struct BLTextMetrics BLTextMetrics;
typedef struct BLFontCore BLFontCore;
typedef struct BLFontImpl BLFontImpl;
typedef struct BLFontVirt BLFontVirt;
typedef struct BLFontFaceCore BLFontFaceCore;
typedef struct BLFontFaceImpl BLFontFaceImpl;
typedef struct BLFontFaceVirt BLFontFaceVirt;
typedef struct BLFontDataCore BLFontDataCore;
typedef struct BLFontDataImpl BLFontDataImpl;
typedef struct BLFontDataVirt BLFontDataVirt;
typedef struct BLFontLoaderCore BLFontLoaderCore;
typedef struct BLFontLoaderImpl BLFontLoaderImpl;
typedef struct BLFontLoaderVirt BLFontLoaderVirt;
typedef uint32_t BLResult;
typedef uintptr_t BLBitWord;
typedef uint32_t BLTag;
typedef void (__cdecl* BLDestroyImplFunc)(void* impl, void* destroyData) ;
typedef BLResult (__cdecl* BLPathSinkFunc)(BLPathCore* path, const void* info, void* closure) ;
typedef uint16_t BLGlyphId;
enum BLResultCode {
  BL_SUCCESS = 0,
  BL_ERROR_START_INDEX = 0x00010000u,
  BL_ERROR_OUT_OF_MEMORY = 0x00010000u,  
  BL_ERROR_INVALID_VALUE,                
  BL_ERROR_INVALID_STATE,                
  BL_ERROR_INVALID_HANDLE,               
  BL_ERROR_VALUE_TOO_LARGE,              
  BL_ERROR_NOT_INITIALIZED,              
  BL_ERROR_NOT_IMPLEMENTED,              
  BL_ERROR_NOT_PERMITTED,                
  BL_ERROR_IO,                           
  BL_ERROR_BUSY,                         
  BL_ERROR_INTERRUPTED,                  
  BL_ERROR_TRY_AGAIN,                    
  BL_ERROR_TIMED_OUT,                    
  BL_ERROR_BROKEN_PIPE,                  
  BL_ERROR_INVALID_SEEK,                 
  BL_ERROR_SYMLINK_LOOP,                 
  BL_ERROR_FILE_TOO_LARGE,               
  BL_ERROR_ALREADY_EXISTS,               
  BL_ERROR_ACCESS_DENIED,                
  BL_ERROR_MEDIA_CHANGED,                
  BL_ERROR_READ_ONLY_FS,                 
  BL_ERROR_NO_DEVICE,                    
  BL_ERROR_NO_ENTRY,                     
  BL_ERROR_NO_MEDIA,                     
  BL_ERROR_NO_MORE_DATA,                 
  BL_ERROR_NO_MORE_FILES,                
  BL_ERROR_NO_SPACE_LEFT,                
  BL_ERROR_NOT_EMPTY,                    
  BL_ERROR_NOT_FILE,                     
  BL_ERROR_NOT_DIRECTORY,                
  BL_ERROR_NOT_SAME_DEVICE,              
  BL_ERROR_NOT_BLOCK_DEVICE,             
  BL_ERROR_INVALID_FILE_NAME,            
  BL_ERROR_FILE_NAME_TOO_LONG,           
  BL_ERROR_TOO_MANY_OPEN_FILES,          
  BL_ERROR_TOO_MANY_OPEN_FILES_BY_OS,    
  BL_ERROR_TOO_MANY_LINKS,               
  BL_ERROR_TOO_MANY_THREADS,             
  BL_ERROR_FILE_EMPTY,                   
  BL_ERROR_OPEN_FAILED,                  
  BL_ERROR_NOT_ROOT_DEVICE,              
  BL_ERROR_UNKNOWN_SYSTEM_ERROR,         
  BL_ERROR_INVALID_ALIGNMENT,            
  BL_ERROR_INVALID_SIGNATURE,            
  BL_ERROR_INVALID_DATA,                 
  BL_ERROR_INVALID_STRING,               
  BL_ERROR_DATA_TRUNCATED,               
  BL_ERROR_DATA_TOO_LARGE,               
  BL_ERROR_DECOMPRESSION_FAILED,         
  BL_ERROR_INVALID_GEOMETRY,             
  BL_ERROR_NO_MATCHING_VERTEX,           
  BL_ERROR_NO_MATCHING_COOKIE,           
  BL_ERROR_NO_STATES_TO_RESTORE,         
  BL_ERROR_IMAGE_TOO_LARGE,              
  BL_ERROR_IMAGE_NO_MATCHING_CODEC,      
  BL_ERROR_IMAGE_UNKNOWN_FILE_FORMAT,    
  BL_ERROR_IMAGE_DECODER_NOT_PROVIDED,   
  BL_ERROR_IMAGE_ENCODER_NOT_PROVIDED,   
  BL_ERROR_PNG_MULTIPLE_IHDR,            
  BL_ERROR_PNG_INVALID_IDAT,             
  BL_ERROR_PNG_INVALID_IEND,             
  BL_ERROR_PNG_INVALID_PLTE,             
  BL_ERROR_PNG_INVALID_TRNS,             
  BL_ERROR_PNG_INVALID_FILTER,           
  BL_ERROR_JPEG_UNSUPPORTED_FEATURE,     
  BL_ERROR_JPEG_INVALID_SOS,             
  BL_ERROR_JPEG_INVALID_SOF,             
  BL_ERROR_JPEG_MULTIPLE_SOF,            
  BL_ERROR_JPEG_UNSUPPORTED_SOF,         
  BL_ERROR_FONT_NO_CHARACTER_MAPPING,    
  BL_ERROR_FONT_MISSING_IMPORTANT_TABLE, 
  BL_ERROR_FONT_FEATURE_NOT_AVAILABLE,   
  BL_ERROR_FONT_CFF_INVALID_DATA,        
  BL_ERROR_FONT_PROGRAM_TERMINATED,      
  BL_ERROR_INVALID_GLYPH                 
};
enum BLByteOrder {
  BL_BYTE_ORDER_LE = 0,
  BL_BYTE_ORDER_BE = 1,
  BL_BYTE_ORDER_NATIVE = 1234 == 1234 ? BL_BYTE_ORDER_LE : BL_BYTE_ORDER_BE,
  BL_BYTE_ORDER_SWAPPED = 1234 == 1234 ? BL_BYTE_ORDER_BE : BL_BYTE_ORDER_LE
};
enum BLDataAccessFlags {
  BL_DATA_ACCESS_READ = 0x01u,
  BL_DATA_ACCESS_WRITE = 0x02u,
  BL_DATA_ACCESS_RW = 0x03u
};
enum BLDataSourceType {
  BL_DATA_SOURCE_TYPE_NONE = 0,
  BL_DATA_SOURCE_TYPE_MEMORY = 1,
  BL_DATA_SOURCE_TYPE_FILE = 2,
  BL_DATA_SOURCE_TYPE_CUSTOM = 3,
  BL_DATA_SOURCE_TYPE_COUNT = 4
};
enum BLModifyOp {
  BL_MODIFY_OP_ASSIGN_FIT = 0,
  BL_MODIFY_OP_ASSIGN_GROW = 1,
  BL_MODIFY_OP_APPEND_FIT = 2,
  BL_MODIFY_OP_APPEND_GROW = 3,
  BL_MODIFY_OP_COUNT = 4
};
enum BLBooleanOp {
  BL_BOOLEAN_OP_COPY = 0,
  BL_BOOLEAN_OP_AND = 1,
  BL_BOOLEAN_OP_OR = 2,
  BL_BOOLEAN_OP_XOR = 3,
  BL_BOOLEAN_OP_SUB = 4,
  BL_BOOLEAN_OP_COUNT = 5
};
enum BLExtendMode {
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
enum BLStyleType {
  BL_STYLE_TYPE_NONE = 0,
  BL_STYLE_TYPE_SOLID = 1,
  BL_STYLE_TYPE_PATTERN = 2,
  BL_STYLE_TYPE_GRADIENT = 3,
  BL_STYLE_TYPE_COUNT = 4
};
enum BLTextEncoding {
  BL_TEXT_ENCODING_UTF8 = 0,
  BL_TEXT_ENCODING_UTF16 = 1,
  BL_TEXT_ENCODING_UTF32 = 2,
  BL_TEXT_ENCODING_LATIN1 = 3,
  BL_TEXT_ENCODING_WCHAR
    = sizeof(wchar_t) == 4 ? BL_TEXT_ENCODING_UTF32 :
      sizeof(wchar_t) == 2 ? BL_TEXT_ENCODING_UTF16 : BL_TEXT_ENCODING_UTF8,
  BL_TEXT_ENCODING_COUNT = 4
};
static inline BLResult blTraceError(BLResult result)  { return result; }
struct BLRange {
  size_t start;
  size_t end;
};
struct BLCreateForeignInfo {
  void* data;
  size_t size;
  BLDestroyImplFunc destroyFunc;
  void* destroyData;
};
typedef struct { const void* data; size_t size; } BLArrayView;
typedef struct { const char* data; size_t size; } BLStringView;
typedef struct { const BLBoxI* data; size_t size; } BLRegionView;
typedef BLArrayView BLDataView;
__declspec(dllimport) BLResult __cdecl blArrayInit(BLArrayCore* self, uint32_t arrayTypeId) ;
__declspec(dllimport) BLResult __cdecl blArrayReset(BLArrayCore* self) ;
__declspec(dllimport) BLResult __cdecl blArrayCreateFromData(BLArrayCore* self, void* data, size_t size, size_t capacity, uint32_t dataAccessFlags, BLDestroyImplFunc destroyFunc, void* destroyData) ;
__declspec(dllimport) size_t   __cdecl blArrayGetSize(const BLArrayCore* self) ;
__declspec(dllimport) size_t   __cdecl blArrayGetCapacity(const BLArrayCore* self) ;
__declspec(dllimport) const void* __cdecl blArrayGetData(const BLArrayCore* self) ;
__declspec(dllimport) BLResult __cdecl blArrayClear(BLArrayCore* self) ;
__declspec(dllimport) BLResult __cdecl blArrayShrink(BLArrayCore* self) ;
__declspec(dllimport) BLResult __cdecl blArrayReserve(BLArrayCore* self, size_t n) ;
__declspec(dllimport) BLResult __cdecl blArrayResize(BLArrayCore* self, size_t n, const void* fill) ;
__declspec(dllimport) BLResult __cdecl blArrayMakeMutable(BLArrayCore* self, void** dataOut) ;
__declspec(dllimport) BLResult __cdecl blArrayModifyOp(BLArrayCore* self, uint32_t op, size_t n, void** dataOut) ;
__declspec(dllimport) BLResult __cdecl blArrayInsertOp(BLArrayCore* self, size_t index, size_t n, void** dataOut) ;
__declspec(dllimport) BLResult __cdecl blArrayAssignMove(BLArrayCore* self, BLArrayCore* other) ;
__declspec(dllimport) BLResult __cdecl blArrayAssignWeak(BLArrayCore* self, const BLArrayCore* other) ;
__declspec(dllimport) BLResult __cdecl blArrayAssignDeep(BLArrayCore* self, const BLArrayCore* other) ;
__declspec(dllimport) BLResult __cdecl blArrayAssignView(BLArrayCore* self, const void* items, size_t n) ;
__declspec(dllimport) BLResult __cdecl blArrayAppendU8(BLArrayCore* self, uint8_t value) ;
__declspec(dllimport) BLResult __cdecl blArrayAppendU16(BLArrayCore* self, uint16_t value) ;
__declspec(dllimport) BLResult __cdecl blArrayAppendU32(BLArrayCore* self, uint32_t value) ;
__declspec(dllimport) BLResult __cdecl blArrayAppendU64(BLArrayCore* self, uint64_t value) ;
__declspec(dllimport) BLResult __cdecl blArrayAppendF32(BLArrayCore* self, float value) ;
__declspec(dllimport) BLResult __cdecl blArrayAppendF64(BLArrayCore* self, double value) ;
__declspec(dllimport) BLResult __cdecl blArrayAppendItem(BLArrayCore* self, const void* item) ;
__declspec(dllimport) BLResult __cdecl blArrayAppendView(BLArrayCore* self, const void* items, size_t n) ;
__declspec(dllimport) BLResult __cdecl blArrayInsertU8(BLArrayCore* self, size_t index, uint8_t value) ;
__declspec(dllimport) BLResult __cdecl blArrayInsertU16(BLArrayCore* self, size_t index, uint16_t value) ;
__declspec(dllimport) BLResult __cdecl blArrayInsertU32(BLArrayCore* self, size_t index, uint32_t value) ;
__declspec(dllimport) BLResult __cdecl blArrayInsertU64(BLArrayCore* self, size_t index, uint64_t value) ;
__declspec(dllimport) BLResult __cdecl blArrayInsertF32(BLArrayCore* self, size_t index, float value) ;
__declspec(dllimport) BLResult __cdecl blArrayInsertF64(BLArrayCore* self, size_t index, double value) ;
__declspec(dllimport) BLResult __cdecl blArrayInsertItem(BLArrayCore* self, size_t index, const void* item) ;
__declspec(dllimport) BLResult __cdecl blArrayInsertView(BLArrayCore* self, size_t index, const void* items, size_t n) ;
__declspec(dllimport) BLResult __cdecl blArrayReplaceU8(BLArrayCore* self, size_t index, uint8_t value) ;
__declspec(dllimport) BLResult __cdecl blArrayReplaceU16(BLArrayCore* self, size_t index, uint16_t value) ;
__declspec(dllimport) BLResult __cdecl blArrayReplaceU32(BLArrayCore* self, size_t index, uint32_t value) ;
__declspec(dllimport) BLResult __cdecl blArrayReplaceU64(BLArrayCore* self, size_t index, uint64_t value) ;
__declspec(dllimport) BLResult __cdecl blArrayReplaceF32(BLArrayCore* self, size_t index, float value) ;
__declspec(dllimport) BLResult __cdecl blArrayReplaceF64(BLArrayCore* self, size_t index, double value) ;
__declspec(dllimport) BLResult __cdecl blArrayReplaceItem(BLArrayCore* self, size_t index, const void* item) ;
__declspec(dllimport) BLResult __cdecl blArrayReplaceView(BLArrayCore* self, const BLRange* range, const void* items, size_t n) ;
__declspec(dllimport) BLResult __cdecl blArrayRemoveIndex(BLArrayCore* self, size_t index) ;
__declspec(dllimport) BLResult __cdecl blArrayRemoveRange(BLArrayCore* self, const BLRange* range) ;
__declspec(dllimport) _Bool     __cdecl blArrayEquals(const BLArrayCore* a, const BLArrayCore* b) ;
__declspec(dllimport) BLResult __cdecl blContextInit(BLContextCore* self) ;
__declspec(dllimport) BLResult __cdecl blContextInitAs(BLContextCore* self, BLImageCore* image, const BLContextCreateInfo* options) ;
__declspec(dllimport) BLResult __cdecl blContextReset(BLContextCore* self) ;
__declspec(dllimport) BLResult __cdecl blContextAssignMove(BLContextCore* self, BLContextCore* other) ;
__declspec(dllimport) BLResult __cdecl blContextAssignWeak(BLContextCore* self, const BLContextCore* other) ;
__declspec(dllimport) BLResult __cdecl blContextGetType(const BLContextCore* self) ;
__declspec(dllimport) BLResult __cdecl blContextBegin(BLContextCore* self, BLImageCore* image, const BLContextCreateInfo* options) ;
__declspec(dllimport) BLResult __cdecl blContextEnd(BLContextCore* self) ;
__declspec(dllimport) BLResult __cdecl blContextFlush(BLContextCore* self, uint32_t flags) ;
__declspec(dllimport) BLResult __cdecl blContextSave(BLContextCore* self, BLContextCookie* cookie) ;
__declspec(dllimport) BLResult __cdecl blContextRestore(BLContextCore* self, const BLContextCookie* cookie) ;
__declspec(dllimport) BLResult __cdecl blContextGetMetaMatrix(const BLContextCore* self, BLMatrix2D* m) ;
__declspec(dllimport) BLResult __cdecl blContextGetUserMatrix(const BLContextCore* self, BLMatrix2D* m) ;
__declspec(dllimport) BLResult __cdecl blContextUserToMeta(BLContextCore* self) ;
__declspec(dllimport) BLResult __cdecl blContextMatrixOp(BLContextCore* self, uint32_t opType, const void* opData) ;
__declspec(dllimport) BLResult __cdecl blContextSetHint(BLContextCore* self, uint32_t hintType, uint32_t value) ;
__declspec(dllimport) BLResult __cdecl blContextSetHints(BLContextCore* self, const BLContextHints* hints) ;
__declspec(dllimport) BLResult __cdecl blContextSetFlattenMode(BLContextCore* self, uint32_t mode) ;
__declspec(dllimport) BLResult __cdecl blContextSetFlattenTolerance(BLContextCore* self, double tolerance) ;
__declspec(dllimport) BLResult __cdecl blContextSetApproximationOptions(BLContextCore* self, const BLApproximationOptions* options) ;
__declspec(dllimport) BLResult __cdecl blContextSetCompOp(BLContextCore* self, uint32_t compOp) ;
__declspec(dllimport) BLResult __cdecl blContextSetGlobalAlpha(BLContextCore* self, double alpha) ;
__declspec(dllimport) BLResult __cdecl blContextSetFillAlpha(BLContextCore* self, double alpha) ;
__declspec(dllimport) BLResult __cdecl blContextGetFillStyle(const BLContextCore* self, void* object) ;
__declspec(dllimport) BLResult __cdecl blContextGetFillStyleRgba32(const BLContextCore* self, uint32_t* rgba32) ;
__declspec(dllimport) BLResult __cdecl blContextGetFillStyleRgba64(const BLContextCore* self, uint64_t* rgba64) ;
__declspec(dllimport) BLResult __cdecl blContextSetFillStyle(BLContextCore* self, const void* object) ;
__declspec(dllimport) BLResult __cdecl blContextSetFillStyleRgba32(BLContextCore* self, uint32_t rgba32) ;
__declspec(dllimport) BLResult __cdecl blContextSetFillStyleRgba64(BLContextCore* self, uint64_t rgba64) ;
__declspec(dllimport) BLResult __cdecl blContextSetFillRule(BLContextCore* self, uint32_t fillRule) ;
__declspec(dllimport) BLResult __cdecl blContextSetStrokeAlpha(BLContextCore* self, double alpha) ;
__declspec(dllimport) BLResult __cdecl blContextGetStrokeStyle(const BLContextCore* self, void* object) ;
__declspec(dllimport) BLResult __cdecl blContextGetStrokeStyleRgba32(const BLContextCore* self, uint32_t* rgba32) ;
__declspec(dllimport) BLResult __cdecl blContextGetStrokeStyleRgba64(const BLContextCore* self, uint64_t* rgba64) ;
__declspec(dllimport) BLResult __cdecl blContextSetStrokeStyle(BLContextCore* self, const void* object) ;
__declspec(dllimport) BLResult __cdecl blContextSetStrokeStyleRgba32(BLContextCore* self, uint32_t rgba32) ;
__declspec(dllimport) BLResult __cdecl blContextSetStrokeStyleRgba64(BLContextCore* self, uint64_t rgba64) ;
__declspec(dllimport) BLResult __cdecl blContextSetStrokeWidth(BLContextCore* self, double width) ;
__declspec(dllimport) BLResult __cdecl blContextSetStrokeMiterLimit(BLContextCore* self, double miterLimit) ;
__declspec(dllimport) BLResult __cdecl blContextSetStrokeCap(BLContextCore* self, uint32_t position, uint32_t strokeCap) ;
__declspec(dllimport) BLResult __cdecl blContextSetStrokeCaps(BLContextCore* self, uint32_t strokeCap) ;
__declspec(dllimport) BLResult __cdecl blContextSetStrokeJoin(BLContextCore* self, uint32_t strokeJoin) ;
__declspec(dllimport) BLResult __cdecl blContextSetStrokeDashOffset(BLContextCore* self, double dashOffset) ;
__declspec(dllimport) BLResult __cdecl blContextSetStrokeDashArray(BLContextCore* self, const BLArrayCore* dashArray) ;
__declspec(dllimport) BLResult __cdecl blContextSetStrokeTransformOrder(BLContextCore* self, uint32_t transformOrder) ;
__declspec(dllimport) BLResult __cdecl blContextGetStrokeOptions(const BLContextCore* self, BLStrokeOptionsCore* options) ;
__declspec(dllimport) BLResult __cdecl blContextSetStrokeOptions(BLContextCore* self, const BLStrokeOptionsCore* options) ;
__declspec(dllimport) BLResult __cdecl blContextClipToRectI(BLContextCore* self, const BLRectI* rect) ;
__declspec(dllimport) BLResult __cdecl blContextClipToRectD(BLContextCore* self, const BLRect* rect) ;
__declspec(dllimport) BLResult __cdecl blContextRestoreClipping(BLContextCore* self) ;
__declspec(dllimport) BLResult __cdecl blContextClearAll(BLContextCore* self) ;
__declspec(dllimport) BLResult __cdecl blContextClearRectI(BLContextCore* self, const BLRectI* rect) ;
__declspec(dllimport) BLResult __cdecl blContextClearRectD(BLContextCore* self, const BLRect* rect) ;
__declspec(dllimport) BLResult __cdecl blContextFillAll(BLContextCore* self) ;
__declspec(dllimport) BLResult __cdecl blContextFillRectI(BLContextCore* self, const BLRectI* rect) ;
__declspec(dllimport) BLResult __cdecl blContextFillRectD(BLContextCore* self, const BLRect* rect) ;
__declspec(dllimport) BLResult __cdecl blContextFillPathD(BLContextCore* self, const BLPathCore* path) ;
__declspec(dllimport) BLResult __cdecl blContextFillGeometry(BLContextCore* self, uint32_t geometryType, const void* geometryData) ;
__declspec(dllimport) BLResult __cdecl blContextFillTextI(BLContextCore* self, const BLPointI* pt, const BLFontCore* font, const void* text, size_t size, uint32_t encoding) ;
__declspec(dllimport) BLResult __cdecl blContextFillTextD(BLContextCore* self, const BLPoint* pt, const BLFontCore* font, const void* text, size_t size, uint32_t encoding) ;
__declspec(dllimport) BLResult __cdecl blContextFillGlyphRunI(BLContextCore* self, const BLPointI* pt, const BLFontCore* font, const BLGlyphRun* glyphRun) ;
__declspec(dllimport) BLResult __cdecl blContextFillGlyphRunD(BLContextCore* self, const BLPoint* pt, const BLFontCore* font, const BLGlyphRun* glyphRun) ;
__declspec(dllimport) BLResult __cdecl blContextStrokeRectI(BLContextCore* self, const BLRectI* rect) ;
__declspec(dllimport) BLResult __cdecl blContextStrokeRectD(BLContextCore* self, const BLRect* rect) ;
__declspec(dllimport) BLResult __cdecl blContextStrokePathD(BLContextCore* self, const BLPathCore* path) ;
__declspec(dllimport) BLResult __cdecl blContextStrokeGeometry(BLContextCore* self, uint32_t geometryType, const void* geometryData) ;
__declspec(dllimport) BLResult __cdecl blContextStrokeTextI(BLContextCore* self, const BLPointI* pt, const BLFontCore* font, const void* text, size_t size, uint32_t encoding) ;
__declspec(dllimport) BLResult __cdecl blContextStrokeTextD(BLContextCore* self, const BLPoint* pt, const BLFontCore* font, const void* text, size_t size, uint32_t encoding) ;
__declspec(dllimport) BLResult __cdecl blContextStrokeGlyphRunI(BLContextCore* self, const BLPointI* pt, const BLFontCore* font, const BLGlyphRun* glyphRun) ;
__declspec(dllimport) BLResult __cdecl blContextStrokeGlyphRunD(BLContextCore* self, const BLPoint* pt, const BLFontCore* font, const BLGlyphRun* glyphRun) ;
__declspec(dllimport) BLResult __cdecl blContextBlitImageI(BLContextCore* self, const BLPointI* pt, const BLImageCore* img, const BLRectI* imgArea) ;
__declspec(dllimport) BLResult __cdecl blContextBlitImageD(BLContextCore* self, const BLPoint* pt, const BLImageCore* img, const BLRectI* imgArea) ;
__declspec(dllimport) BLResult __cdecl blContextBlitScaledImageI(BLContextCore* self, const BLRectI* rect, const BLImageCore* img, const BLRectI* imgArea) ;
__declspec(dllimport) BLResult __cdecl blContextBlitScaledImageD(BLContextCore* self, const BLRect* rect, const BLImageCore* img, const BLRectI* imgArea) ;
__declspec(dllimport) BLResult __cdecl blFileInit(BLFileCore* self) ;
__declspec(dllimport) BLResult __cdecl blFileReset(BLFileCore* self) ;
__declspec(dllimport) BLResult __cdecl blFileOpen(BLFileCore* self, const char* fileName, uint32_t openFlags) ;
__declspec(dllimport) BLResult __cdecl blFileClose(BLFileCore* self) ;
__declspec(dllimport) BLResult __cdecl blFileSeek(BLFileCore* self, int64_t offset, uint32_t seekType, int64_t* positionOut) ;
__declspec(dllimport) BLResult __cdecl blFileRead(BLFileCore* self, void* buffer, size_t n, size_t* bytesReadOut) ;
__declspec(dllimport) BLResult __cdecl blFileWrite(BLFileCore* self, const void* buffer, size_t n, size_t* bytesWrittenOut) ;
__declspec(dllimport) BLResult __cdecl blFileTruncate(BLFileCore* self, int64_t maxSize) ;
__declspec(dllimport) BLResult __cdecl blFileGetSize(BLFileCore* self, uint64_t* fileSizeOut) ;
__declspec(dllimport) BLResult __cdecl blFileSystemReadFile(const char* fileName, BLArrayCore* dst, size_t maxSize, uint32_t readFlags) ;
__declspec(dllimport) BLResult __cdecl blFileSystemWriteFile(const char* fileName, const void* data, size_t size, size_t* bytesWrittenOut) ;
__declspec(dllimport) BLResult __cdecl blFontInit(BLFontCore* self) ;
__declspec(dllimport) BLResult __cdecl blFontReset(BLFontCore* self) ;
__declspec(dllimport) BLResult __cdecl blFontAssignMove(BLFontCore* self, BLFontCore* other) ;
__declspec(dllimport) BLResult __cdecl blFontAssignWeak(BLFontCore* self, const BLFontCore* other) ;
__declspec(dllimport) _Bool     __cdecl blFontEquals(const BLFontCore* a, const BLFontCore* b) ;
__declspec(dllimport) BLResult __cdecl blFontCreateFromFace(BLFontCore* self, const BLFontFaceCore* face, float size) ;
__declspec(dllimport) BLResult __cdecl blFontShape(const BLFontCore* self, BLGlyphBufferCore* gb) ;
__declspec(dllimport) BLResult __cdecl blFontMapTextToGlyphs(const BLFontCore* self, BLGlyphBufferCore* gb, BLGlyphMappingState* stateOut) ;
__declspec(dllimport) BLResult __cdecl blFontPositionGlyphs(const BLFontCore* self, BLGlyphBufferCore* gb, uint32_t positioningFlags) ;
__declspec(dllimport) BLResult __cdecl blFontApplyKerning(const BLFontCore* self, BLGlyphBufferCore* gb) ;
__declspec(dllimport) BLResult __cdecl blFontApplyGSub(const BLFontCore* self, BLGlyphBufferCore* gb, size_t index, BLBitWord lookups) ;
__declspec(dllimport) BLResult __cdecl blFontApplyGPos(const BLFontCore* self, BLGlyphBufferCore* gb, size_t index, BLBitWord lookups) ;
__declspec(dllimport) BLResult __cdecl blFontGetMatrix(const BLFontCore* self, BLFontMatrix* out) ;
__declspec(dllimport) BLResult __cdecl blFontGetMetrics(const BLFontCore* self, BLFontMetrics* out) ;
__declspec(dllimport) BLResult __cdecl blFontGetDesignMetrics(const BLFontCore* self, BLFontDesignMetrics* out) ;
__declspec(dllimport) BLResult __cdecl blFontGetTextMetrics(const BLFontCore* self, BLGlyphBufferCore* gb, BLTextMetrics* out) ;
__declspec(dllimport) BLResult __cdecl blFontGetGlyphBounds(const BLFontCore* self, const void* glyphIdData, intptr_t glyphIdAdvance, BLBoxI* out, size_t count) ;
__declspec(dllimport) BLResult __cdecl blFontGetGlyphAdvances(const BLFontCore* self, const void* glyphIdData, intptr_t glyphIdAdvance, BLGlyphPlacement* out, size_t count) ;
__declspec(dllimport) BLResult __cdecl blFontGetGlyphOutlines(const BLFontCore* self, uint32_t glyphId, const BLMatrix2D* userMatrix, BLPathCore* out, BLPathSinkFunc sink, void* closure) ;
__declspec(dllimport) BLResult __cdecl blFontGetGlyphRunOutlines(const BLFontCore* self, const BLGlyphRun* glyphRun, const BLMatrix2D* userMatrix, BLPathCore* out, BLPathSinkFunc sink, void* closure) ;
__declspec(dllimport) BLResult __cdecl blFontDataInit(BLFontDataCore* self) ;
__declspec(dllimport) BLResult __cdecl blFontDataInitFromLoader(BLFontDataCore* self, const BLFontLoaderCore* loader, uint32_t faceIndex) ;
__declspec(dllimport) BLResult __cdecl blFontDataReset(BLFontDataCore* self) ;
__declspec(dllimport) BLResult __cdecl blFontDataAssignMove(BLFontDataCore* self, BLFontDataCore* other) ;
__declspec(dllimport) BLResult __cdecl blFontDataAssignWeak(BLFontDataCore* self, const BLFontDataCore* other) ;
__declspec(dllimport) BLResult __cdecl blFontDataCreateFromLoader(BLFontDataCore* self, const BLFontLoaderCore* loader, uint32_t faceIndex) ;
__declspec(dllimport) _Bool     __cdecl blFontDataEquals(const BLFontDataCore* a, const BLFontDataCore* b) ;
__declspec(dllimport) BLResult __cdecl blFontDataListTags(const BLFontDataCore* self, BLArrayCore* dst) ;
__declspec(dllimport) size_t   __cdecl blFontDataQueryTables(const BLFontDataCore* self, BLFontTable* dst, const BLTag* tags, size_t count) ;
__declspec(dllimport) BLResult __cdecl blFontFaceInit(BLFontFaceCore* self) ;
__declspec(dllimport) BLResult __cdecl blFontFaceReset(BLFontFaceCore* self) ;
__declspec(dllimport) BLResult __cdecl blFontFaceAssignMove(BLFontFaceCore* self, BLFontFaceCore* other) ;
__declspec(dllimport) BLResult __cdecl blFontFaceAssignWeak(BLFontFaceCore* self, const BLFontFaceCore* other) ;
__declspec(dllimport) _Bool     __cdecl blFontFaceEquals(const BLFontFaceCore* a, const BLFontFaceCore* b) ;
__declspec(dllimport) BLResult __cdecl blFontFaceCreateFromFile(BLFontFaceCore* self, const char* fileName, uint32_t readFlags) ;
__declspec(dllimport) BLResult __cdecl blFontFaceCreateFromLoader(BLFontFaceCore* self, const BLFontLoaderCore* loader, uint32_t faceIndex) ;
__declspec(dllimport) BLResult __cdecl blFontFaceGetFaceInfo(const BLFontFaceCore* self, BLFontFaceInfo* out) ;
__declspec(dllimport) BLResult __cdecl blFontFaceGetDesignMetrics(const BLFontFaceCore* self, BLFontDesignMetrics* out) ;
__declspec(dllimport) BLResult __cdecl blFontFaceGetUnicodeCoverage(const BLFontFaceCore* self, BLFontUnicodeCoverage* out) ;
__declspec(dllimport) BLResult __cdecl blFontLoaderInit(BLFontLoaderCore* self) ;
__declspec(dllimport) BLResult __cdecl blFontLoaderReset(BLFontLoaderCore* self) ;
__declspec(dllimport) BLResult __cdecl blFontLoaderAssignMove(BLFontLoaderCore* self, BLFontLoaderCore* other) ;
__declspec(dllimport) BLResult __cdecl blFontLoaderAssignWeak(BLFontLoaderCore* self, const BLFontLoaderCore* other) ;
__declspec(dllimport) _Bool     __cdecl blFontLoaderEquals(const BLFontLoaderCore* a, const BLFontLoaderCore* b) ;
__declspec(dllimport) BLResult __cdecl blFontLoaderCreateFromFile(BLFontLoaderCore* self, const char* fileName, uint32_t readFlags) ;
__declspec(dllimport) BLResult __cdecl blFontLoaderCreateFromDataArray(BLFontLoaderCore* self, const BLArrayCore* dataArray) ;
__declspec(dllimport) BLResult __cdecl blFontLoaderCreateFromData(BLFontLoaderCore* self, const void* data, size_t size, BLDestroyImplFunc destroyFunc, void* destroyData) ;
__declspec(dllimport) BLResult __cdecl blFormatInfoSanitize(BLFormatInfo* self) ;
__declspec(dllimport) BLResult __cdecl blGlyphBufferInit(BLGlyphBufferCore* self) ;
__declspec(dllimport) BLResult __cdecl blGlyphBufferReset(BLGlyphBufferCore* self) ;
__declspec(dllimport) BLResult __cdecl blGlyphBufferClear(BLGlyphBufferCore* self) ;
__declspec(dllimport) BLResult __cdecl blGlyphBufferSetText(BLGlyphBufferCore* self, const void* data, size_t size, uint32_t encoding) ;
__declspec(dllimport) BLResult __cdecl blGlyphBufferSetGlyphIds(BLGlyphBufferCore* self, const void* data, intptr_t advance, size_t size) ;
__declspec(dllimport) BLResult __cdecl blGradientInit(BLGradientCore* self) ;
__declspec(dllimport) BLResult __cdecl blGradientInitAs(BLGradientCore* self, uint32_t type, const void* values, uint32_t extendMode, const BLGradientStop* stops, size_t n, const BLMatrix2D* m) ;
__declspec(dllimport) BLResult __cdecl blGradientReset(BLGradientCore* self) ;
__declspec(dllimport) BLResult __cdecl blGradientAssignMove(BLGradientCore* self, BLGradientCore* other) ;
__declspec(dllimport) BLResult __cdecl blGradientAssignWeak(BLGradientCore* self, const BLGradientCore* other) ;
__declspec(dllimport) BLResult __cdecl blGradientCreate(BLGradientCore* self, uint32_t type, const void* values, uint32_t extendMode, const BLGradientStop* stops, size_t n, const BLMatrix2D* m) ;
__declspec(dllimport) BLResult __cdecl blGradientShrink(BLGradientCore* self) ;
__declspec(dllimport) BLResult __cdecl blGradientReserve(BLGradientCore* self, size_t n) ;
__declspec(dllimport) uint32_t __cdecl blGradientGetType(const BLGradientCore* self) ;
__declspec(dllimport) BLResult __cdecl blGradientSetType(BLGradientCore* self, uint32_t type) ;
__declspec(dllimport) double   __cdecl blGradientGetValue(const BLGradientCore* self, size_t index) ;
__declspec(dllimport) BLResult __cdecl blGradientSetValue(BLGradientCore* self, size_t index, double value) ;
__declspec(dllimport) BLResult __cdecl blGradientSetValues(BLGradientCore* self, size_t index, const double* values, size_t n) ;
__declspec(dllimport) uint32_t __cdecl blGradientGetExtendMode(BLGradientCore* self) ;
__declspec(dllimport) BLResult __cdecl blGradientSetExtendMode(BLGradientCore* self, uint32_t extendMode) ;
__declspec(dllimport) const BLGradientStop* __cdecl blGradientGetStops(const BLGradientCore* self) ;
__declspec(dllimport) size_t __cdecl blGradientGetSize(const BLGradientCore* self) ;
__declspec(dllimport) size_t __cdecl blGradientGetCapacity(const BLGradientCore* self) ;
__declspec(dllimport) BLResult __cdecl blGradientResetStops(BLGradientCore* self) ;
__declspec(dllimport) BLResult __cdecl blGradientAssignStops(BLGradientCore* self, const BLGradientStop* stops, size_t n) ;
__declspec(dllimport) BLResult __cdecl blGradientAddStopRgba32(BLGradientCore* self, double offset, uint32_t argb32) ;
__declspec(dllimport) BLResult __cdecl blGradientAddStopRgba64(BLGradientCore* self, double offset, uint64_t argb64) ;
__declspec(dllimport) BLResult __cdecl blGradientRemoveStop(BLGradientCore* self, size_t index) ;
__declspec(dllimport) BLResult __cdecl blGradientRemoveStopByOffset(BLGradientCore* self, double offset, uint32_t all) ;
__declspec(dllimport) BLResult __cdecl blGradientRemoveStops(BLGradientCore* self, const BLRange* range) ;
__declspec(dllimport) BLResult __cdecl blGradientRemoveStopsFromTo(BLGradientCore* self, double offsetMin, double offsetMax) ;
__declspec(dllimport) BLResult __cdecl blGradientReplaceStopRgba32(BLGradientCore* self, size_t index, double offset, uint32_t rgba32) ;
__declspec(dllimport) BLResult __cdecl blGradientReplaceStopRgba64(BLGradientCore* self, size_t index, double offset, uint64_t rgba64) ;
__declspec(dllimport) size_t   __cdecl blGradientIndexOfStop(const BLGradientCore* self, double offset) ;
__declspec(dllimport) BLResult __cdecl blGradientApplyMatrixOp(BLGradientCore* self, uint32_t opType, const void* opData) ;
__declspec(dllimport) _Bool     __cdecl blGradientEquals(const BLGradientCore* a, const BLGradientCore* b) ;
__declspec(dllimport) BLResult __cdecl blImageInit(BLImageCore* self) ;
__declspec(dllimport) BLResult __cdecl blImageInitAs(BLImageCore* self, int w, int h, uint32_t format) ;
__declspec(dllimport) BLResult __cdecl blImageInitAsFromData(BLImageCore* self, int w, int h, uint32_t format, void* pixelData, intptr_t stride, BLDestroyImplFunc destroyFunc, void* destroyData) ;
__declspec(dllimport) BLResult __cdecl blImageReset(BLImageCore* self) ;
__declspec(dllimport) BLResult __cdecl blImageAssignMove(BLImageCore* self, BLImageCore* other) ;
__declspec(dllimport) BLResult __cdecl blImageAssignWeak(BLImageCore* self, const BLImageCore* other) ;
__declspec(dllimport) BLResult __cdecl blImageAssignDeep(BLImageCore* self, const BLImageCore* other) ;
__declspec(dllimport) BLResult __cdecl blImageCreate(BLImageCore* self, int w, int h, uint32_t format) ;
__declspec(dllimport) BLResult __cdecl blImageCreateFromData(BLImageCore* self, int w, int h, uint32_t format, void* pixelData, intptr_t stride, BLDestroyImplFunc destroyFunc, void* destroyData) ;
__declspec(dllimport) BLResult __cdecl blImageGetData(const BLImageCore* self, BLImageData* dataOut) ;
__declspec(dllimport) BLResult __cdecl blImageMakeMutable(BLImageCore* self, BLImageData* dataOut) ;
__declspec(dllimport) _Bool     __cdecl blImageEquals(const BLImageCore* a, const BLImageCore* b) ;
__declspec(dllimport) BLResult __cdecl blImageScale(BLImageCore* dst, const BLImageCore* src, const BLSizeI* size, uint32_t filter, const BLImageScaleOptions* options) ;
__declspec(dllimport) BLResult __cdecl blImageReadFromFile(BLImageCore* self, const char* fileName, const BLArrayCore* codecs) ;
__declspec(dllimport) BLResult __cdecl blImageReadFromData(BLImageCore* self, const void* data, size_t size, const BLArrayCore* codecs) ;
__declspec(dllimport) BLResult __cdecl blImageWriteToFile(const BLImageCore* self, const char* fileName, const BLImageCodecCore* codec) ;
__declspec(dllimport) BLResult __cdecl blImageWriteToData(const BLImageCore* self, BLArrayCore* dst, const BLImageCodecCore* codec) ;
__declspec(dllimport) BLResult __cdecl blImageCodecInit(BLImageCodecCore* self) ;
__declspec(dllimport) BLResult __cdecl blImageCodecReset(BLImageCodecCore* self) ;
__declspec(dllimport) BLResult __cdecl blImageCodecAssignWeak(BLImageCodecCore* self, const BLImageCodecCore* other) ;
__declspec(dllimport) BLResult __cdecl blImageCodecFindByName(BLImageCodecCore* self, const char* name, size_t size, const BLArrayCore* codecs) ;
__declspec(dllimport) BLResult __cdecl blImageCodecFindByData(BLImageCodecCore* self, const void* data, size_t size, const BLArrayCore* codecs) ;
__declspec(dllimport) uint32_t __cdecl blImageCodecInspectData(const BLImageCodecCore* self, const void* data, size_t size) ;
__declspec(dllimport) BLResult __cdecl blImageCodecCreateDecoder(const BLImageCodecCore* self, BLImageDecoderCore* dst) ;
__declspec(dllimport) BLResult __cdecl blImageCodecCreateEncoder(const BLImageCodecCore* self, BLImageEncoderCore* dst) ;
__declspec(dllimport) BLResult __cdecl blImageCodecArrayInitBuiltInCodecs(BLArrayCore* self) ;
__declspec(dllimport) BLResult __cdecl blImageCodecArrayAssignBuiltInCodecs(BLArrayCore* self) ;
__declspec(dllimport) BLResult __cdecl blImageCodecAddToBuiltIn(const BLImageCodecCore* codec) ;
__declspec(dllimport) BLResult __cdecl blImageCodecRemoveFromBuiltIn(const BLImageCodecCore* codec) ;
__declspec(dllimport) BLResult __cdecl blImageDecoderInit(BLImageDecoderCore* self) ;
__declspec(dllimport) BLResult __cdecl blImageDecoderReset(BLImageDecoderCore* self) ;
__declspec(dllimport) BLResult __cdecl blImageDecoderAssignMove(BLImageDecoderCore* self, BLImageDecoderCore* other) ;
__declspec(dllimport) BLResult __cdecl blImageDecoderAssignWeak(BLImageDecoderCore* self, const BLImageDecoderCore* other) ;
__declspec(dllimport) BLResult __cdecl blImageDecoderRestart(BLImageDecoderCore* self) ;
__declspec(dllimport) BLResult __cdecl blImageDecoderReadInfo(BLImageDecoderCore* self, BLImageInfo* infoOut, const uint8_t* data, size_t size) ;
__declspec(dllimport) BLResult __cdecl blImageDecoderReadFrame(BLImageDecoderCore* self, BLImageCore* imageOut, const uint8_t* data, size_t size) ;
__declspec(dllimport) BLResult __cdecl blImageEncoderInit(BLImageEncoderCore* self) ;
__declspec(dllimport) BLResult __cdecl blImageEncoderReset(BLImageEncoderCore* self) ;
__declspec(dllimport) BLResult __cdecl blImageEncoderAssignMove(BLImageEncoderCore* self, BLImageEncoderCore* other) ;
__declspec(dllimport) BLResult __cdecl blImageEncoderAssignWeak(BLImageEncoderCore* self, const BLImageEncoderCore* other) ;
__declspec(dllimport) BLResult __cdecl blImageEncoderRestart(BLImageEncoderCore* self) ;
__declspec(dllimport) BLResult __cdecl blImageEncoderWriteFrame(BLImageEncoderCore* self, BLArrayCore* dst, const BLImageCore* image) ;
__declspec(dllimport) BLResult __cdecl blMatrix2DSetIdentity(BLMatrix2D* self) ;
__declspec(dllimport) BLResult __cdecl blMatrix2DSetTranslation(BLMatrix2D* self, double x, double y) ;
__declspec(dllimport) BLResult __cdecl blMatrix2DSetScaling(BLMatrix2D* self, double x, double y) ;
__declspec(dllimport) BLResult __cdecl blMatrix2DSetSkewing(BLMatrix2D* self, double x, double y) ;
__declspec(dllimport) BLResult __cdecl blMatrix2DSetRotation(BLMatrix2D* self, double angle, double cx, double cy) ;
__declspec(dllimport) BLResult __cdecl blMatrix2DApplyOp(BLMatrix2D* self, uint32_t opType, const void* opData) ;
__declspec(dllimport) BLResult __cdecl blMatrix2DInvert(BLMatrix2D* dst, const BLMatrix2D* src) ;
__declspec(dllimport) uint32_t __cdecl blMatrix2DGetType(const BLMatrix2D* self) ;
__declspec(dllimport) BLResult __cdecl blMatrix2DMapPointDArray(const BLMatrix2D* self, BLPoint* dst, const BLPoint* src, size_t count) ;
__declspec(dllimport) BLResult __cdecl blPathInit(BLPathCore* self) ;
__declspec(dllimport) BLResult __cdecl blPathReset(BLPathCore* self) ;
__declspec(dllimport) size_t   __cdecl blPathGetSize(const BLPathCore* self) ;
__declspec(dllimport) size_t   __cdecl blPathGetCapacity(const BLPathCore* self) ;
__declspec(dllimport) const uint8_t* __cdecl blPathGetCommandData(const BLPathCore* self) ;
__declspec(dllimport) const BLPoint* __cdecl blPathGetVertexData(const BLPathCore* self) ;
__declspec(dllimport) BLResult __cdecl blPathClear(BLPathCore* self) ;
__declspec(dllimport) BLResult __cdecl blPathShrink(BLPathCore* self) ;
__declspec(dllimport) BLResult __cdecl blPathReserve(BLPathCore* self, size_t n) ;
__declspec(dllimport) BLResult __cdecl blPathModifyOp(BLPathCore* self, uint32_t op, size_t n, uint8_t** cmdDataOut, BLPoint** vtxDataOut) ;
__declspec(dllimport) BLResult __cdecl blPathAssignMove(BLPathCore* self, BLPathCore* other) ;
__declspec(dllimport) BLResult __cdecl blPathAssignWeak(BLPathCore* self, const BLPathCore* other) ;
__declspec(dllimport) BLResult __cdecl blPathAssignDeep(BLPathCore* self, const BLPathCore* other) ;
__declspec(dllimport) BLResult __cdecl blPathSetVertexAt(BLPathCore* self, size_t index, uint32_t cmd, double x, double y) ;
__declspec(dllimport) BLResult __cdecl blPathMoveTo(BLPathCore* self, double x0, double y0) ;
__declspec(dllimport) BLResult __cdecl blPathLineTo(BLPathCore* self, double x1, double y1) ;
__declspec(dllimport) BLResult __cdecl blPathPolyTo(BLPathCore* self, const BLPoint* poly, size_t count) ;
__declspec(dllimport) BLResult __cdecl blPathQuadTo(BLPathCore* self, double x1, double y1, double x2, double y2) ;
__declspec(dllimport) BLResult __cdecl blPathCubicTo(BLPathCore* self, double x1, double y1, double x2, double y2, double x3, double y3) ;
__declspec(dllimport) BLResult __cdecl blPathSmoothQuadTo(BLPathCore* self, double x2, double y2) ;
__declspec(dllimport) BLResult __cdecl blPathSmoothCubicTo(BLPathCore* self, double x2, double y2, double x3, double y3) ;
__declspec(dllimport) BLResult __cdecl blPathArcTo(BLPathCore* self, double x, double y, double rx, double ry, double start, double sweep, _Bool forceMoveTo) ;
__declspec(dllimport) BLResult __cdecl blPathArcQuadrantTo(BLPathCore* self, double x1, double y1, double x2, double y2) ;
__declspec(dllimport) BLResult __cdecl blPathEllipticArcTo(BLPathCore* self, double rx, double ry, double xAxisRotation, _Bool largeArcFlag, _Bool sweepFlag, double x1, double y1) ;
__declspec(dllimport) BLResult __cdecl blPathClose(BLPathCore* self) ;
__declspec(dllimport) BLResult __cdecl blPathAddGeometry(BLPathCore* self, uint32_t geometryType, const void* geometryData, const BLMatrix2D* m, uint32_t dir) ;
__declspec(dllimport) BLResult __cdecl blPathAddBoxI(BLPathCore* self, const BLBoxI* box, uint32_t dir) ;
__declspec(dllimport) BLResult __cdecl blPathAddBoxD(BLPathCore* self, const BLBox* box, uint32_t dir) ;
__declspec(dllimport) BLResult __cdecl blPathAddRectI(BLPathCore* self, const BLRectI* rect, uint32_t dir) ;
__declspec(dllimport) BLResult __cdecl blPathAddRectD(BLPathCore* self, const BLRect* rect, uint32_t dir) ;
__declspec(dllimport) BLResult __cdecl blPathAddPath(BLPathCore* self, const BLPathCore* other, const BLRange* range) ;
__declspec(dllimport) BLResult __cdecl blPathAddTranslatedPath(BLPathCore* self, const BLPathCore* other, const BLRange* range, const BLPoint* p) ;
__declspec(dllimport) BLResult __cdecl blPathAddTransformedPath(BLPathCore* self, const BLPathCore* other, const BLRange* range, const BLMatrix2D* m) ;
__declspec(dllimport) BLResult __cdecl blPathAddReversedPath(BLPathCore* self, const BLPathCore* other, const BLRange* range, uint32_t reverseMode) ;
__declspec(dllimport) BLResult __cdecl blPathAddStrokedPath(BLPathCore* self, const BLPathCore* other, const BLRange* range, const BLStrokeOptionsCore* options, const BLApproximationOptions* approx) ;
__declspec(dllimport) BLResult __cdecl blPathTranslate(BLPathCore* self, const BLRange* range, const BLPoint* p) ;
__declspec(dllimport) BLResult __cdecl blPathTransform(BLPathCore* self, const BLRange* range, const BLMatrix2D* m) ;
__declspec(dllimport) BLResult __cdecl blPathFitTo(BLPathCore* self, const BLRange* range, const BLRect* rect, uint32_t fitFlags) ;
__declspec(dllimport) _Bool     __cdecl blPathEquals(const BLPathCore* a, const BLPathCore* b) ;
__declspec(dllimport) BLResult __cdecl blPathGetInfoFlags(const BLPathCore* self, uint32_t* flagsOut) ;
__declspec(dllimport) BLResult __cdecl blPathGetControlBox(const BLPathCore* self, BLBox* boxOut) ;
__declspec(dllimport) BLResult __cdecl blPathGetBoundingBox(const BLPathCore* self, BLBox* boxOut) ;
__declspec(dllimport) BLResult __cdecl blPathGetFigureRange(const BLPathCore* self, size_t index, BLRange* rangeOut) ;
__declspec(dllimport) BLResult __cdecl blPathGetLastVertex(const BLPathCore* self, BLPoint* vtxOut) ;
__declspec(dllimport) BLResult __cdecl blPathGetClosestVertex(const BLPathCore* self, const BLPoint* p, double maxDistance, size_t* indexOut, double* distanceOut) ;
__declspec(dllimport) uint32_t __cdecl blPathHitTest(const BLPathCore* self, const BLPoint* p, uint32_t fillRule) ;
__declspec(dllimport) BLResult __cdecl blPatternInit(BLPatternCore* self) ;
__declspec(dllimport) BLResult __cdecl blPatternInitAs(BLPatternCore* self, const BLImageCore* image, const BLRectI* area, uint32_t extendMode, const BLMatrix2D* m) ;
__declspec(dllimport) BLResult __cdecl blPatternReset(BLPatternCore* self) ;
__declspec(dllimport) BLResult __cdecl blPatternAssignMove(BLPatternCore* self, BLPatternCore* other) ;
__declspec(dllimport) BLResult __cdecl blPatternAssignWeak(BLPatternCore* self, const BLPatternCore* other) ;
__declspec(dllimport) BLResult __cdecl blPatternAssignDeep(BLPatternCore* self, const BLPatternCore* other) ;
__declspec(dllimport) BLResult __cdecl blPatternCreate(BLPatternCore* self, const BLImageCore* image, const BLRectI* area, uint32_t extendMode, const BLMatrix2D* m) ;
__declspec(dllimport) BLResult __cdecl blPatternSetImage(BLPatternCore* self, const BLImageCore* image, const BLRectI* area) ;
__declspec(dllimport) BLResult __cdecl blPatternSetArea(BLPatternCore* self, const BLRectI* area) ;
__declspec(dllimport) BLResult __cdecl blPatternSetExtendMode(BLPatternCore* self, uint32_t extendMode) ;
__declspec(dllimport) BLResult __cdecl blPatternApplyMatrixOp(BLPatternCore* self, uint32_t opType, const void* opData) ;
__declspec(dllimport) _Bool     __cdecl blPatternEquals(const BLPatternCore* a, const BLPatternCore* b) ;
__declspec(dllimport) BLResult __cdecl blPixelConverterInit(BLPixelConverterCore* self) ;
__declspec(dllimport) BLResult __cdecl blPixelConverterInitWeak(BLPixelConverterCore* self, const BLPixelConverterCore* other) ;
__declspec(dllimport) BLResult __cdecl blPixelConverterReset(BLPixelConverterCore* self) ;
__declspec(dllimport) BLResult __cdecl blPixelConverterAssign(BLPixelConverterCore* self, const BLPixelConverterCore* other) ;
__declspec(dllimport) BLResult __cdecl blPixelConverterCreate(BLPixelConverterCore* self, const BLFormatInfo* dstInfo, const BLFormatInfo* srcInfo) ;
__declspec(dllimport) BLResult __cdecl blPixelConverterConvert(const BLPixelConverterCore* self,
  void* dstData, intptr_t dstStride,
  const void* srcData, intptr_t srcStride,
  uint32_t w, uint32_t h, const BLPixelConverterOptions* options) ;
__declspec(dllimport) void     __cdecl blRandomReset(BLRandom* self, uint64_t seed) ;
__declspec(dllimport) uint32_t __cdecl blRandomNextUInt32(BLRandom* self) ;
__declspec(dllimport) uint64_t __cdecl blRandomNextUInt64(BLRandom* self) ;
__declspec(dllimport) double   __cdecl blRandomNextDouble(BLRandom* self) ;
__declspec(dllimport) BLResult __cdecl blRegionInit(BLRegionCore* self) ;
__declspec(dllimport) BLResult __cdecl blRegionReset(BLRegionCore* self) ;
__declspec(dllimport) BLResult __cdecl blRegionClear(BLRegionCore* self) ;
__declspec(dllimport) BLResult __cdecl blRegionShrink(BLRegionCore* self) ;
__declspec(dllimport) BLResult __cdecl blRegionReserve(BLRegionCore* self, size_t n) ;
__declspec(dllimport) BLResult __cdecl blRegionAssignMove(BLRegionCore* self, BLRegionCore* other) ;
__declspec(dllimport) BLResult __cdecl blRegionAssignWeak(BLRegionCore* self, const BLRegionCore* other) ;
__declspec(dllimport) BLResult __cdecl blRegionAssignDeep(BLRegionCore* self, const BLRegionCore* other) ;
__declspec(dllimport) BLResult __cdecl blRegionAssignBoxI(BLRegionCore* self, const BLBoxI* src) ;
__declspec(dllimport) BLResult __cdecl blRegionAssignBoxIArray(BLRegionCore* self, const BLBoxI* data, size_t n) ;
__declspec(dllimport) BLResult __cdecl blRegionAssignRectI(BLRegionCore* self, const BLRectI* rect) ;
__declspec(dllimport) BLResult __cdecl blRegionAssignRectIArray(BLRegionCore* self, const BLRectI* data, size_t n) ;
__declspec(dllimport) BLResult __cdecl blRegionCombine(BLRegionCore* self, const BLRegionCore* a, const BLRegionCore* b, uint32_t op) ;
__declspec(dllimport) BLResult __cdecl blRegionCombineRB(BLRegionCore* self, const BLRegionCore* a, const BLBoxI* b, uint32_t op) ;
__declspec(dllimport) BLResult __cdecl blRegionCombineBR(BLRegionCore* self, const BLBoxI* a, const BLRegionCore* b, uint32_t op) ;
__declspec(dllimport) BLResult __cdecl blRegionCombineBB(BLRegionCore* self, const BLBoxI* a, const BLBoxI* b, uint32_t op) ;
__declspec(dllimport) BLResult __cdecl blRegionTranslate(BLRegionCore* self, const BLRegionCore* r, const BLPointI* pt) ;
__declspec(dllimport) BLResult __cdecl blRegionTranslateAndClip(BLRegionCore* self, const BLRegionCore* r, const BLPointI* pt, const BLBoxI* clipBox) ;
__declspec(dllimport) BLResult __cdecl blRegionIntersectAndClip(BLRegionCore* self, const BLRegionCore* a, const BLRegionCore* b, const BLBoxI* clipBox) ;
__declspec(dllimport) _Bool     __cdecl blRegionEquals(const BLRegionCore* a, const BLRegionCore* b) ;
__declspec(dllimport) uint32_t __cdecl blRegionGetType(const BLRegionCore* self) ;
__declspec(dllimport) uint32_t __cdecl blRegionHitTest(const BLRegionCore* self, const BLPointI* pt) ;
__declspec(dllimport) uint32_t __cdecl blRegionHitTestBoxI(const BLRegionCore* self, const BLBoxI* box) ;
__declspec(dllimport) BLResult __cdecl blRuntimeInit() ;
__declspec(dllimport) BLResult __cdecl blRuntimeShutdown() ;
__declspec(dllimport) BLResult __cdecl blRuntimeCleanup(uint32_t cleanupFlags) ;
__declspec(dllimport) BLResult __cdecl blRuntimeQueryInfo(uint32_t infoType, void* infoOut) ;
__declspec(dllimport) BLResult __cdecl blRuntimeMessageOut(const char* msg) ;
__declspec(dllimport) BLResult __cdecl blRuntimeMessageFmt(const char* fmt, ...) ;
__declspec(dllimport) BLResult __cdecl blRuntimeMessageVFmt(const char* fmt, va_list ap) ;
__declspec(dllimport) uint32_t __cdecl blRuntimeGetTickCount(void) ;
__declspec(dllimport) __declspec(noreturn) void __cdecl blRuntimeAssertionFailure(const char* file, int line, const char* msg) ;
__declspec(dllimport) BLResult __cdecl blResultFromWinError(uint32_t e) ;
__declspec(dllimport) BLResult __cdecl blStringInit(BLStringCore* self) ;
__declspec(dllimport) BLResult __cdecl blStringReset(BLStringCore* self) ;
__declspec(dllimport) size_t   __cdecl blStringGetSize(const BLStringCore* self) ;
__declspec(dllimport) size_t   __cdecl blStringGetCapacity(const BLStringCore* self) ;
__declspec(dllimport) const char* __cdecl blStringGetData(const BLStringCore* self) ;
__declspec(dllimport) BLResult __cdecl blStringClear(BLStringCore* self) ;
__declspec(dllimport) BLResult __cdecl blStringShrink(BLStringCore* self) ;
__declspec(dllimport) BLResult __cdecl blStringReserve(BLStringCore* self, size_t n) ;
__declspec(dllimport) BLResult __cdecl blStringResize(BLStringCore* self, size_t n, char fill) ;
__declspec(dllimport) BLResult __cdecl blStringMakeMutable(BLStringCore* self, char** dataOut) ;
__declspec(dllimport) BLResult __cdecl blStringModifyOp(BLStringCore* self, uint32_t op, size_t n, char** dataOut) ;
__declspec(dllimport) BLResult __cdecl blStringInsertOp(BLStringCore* self, size_t index, size_t n, char** dataOut) ;
__declspec(dllimport) BLResult __cdecl blStringAssignMove(BLStringCore* self, BLStringCore* other) ;
__declspec(dllimport) BLResult __cdecl blStringAssignWeak(BLStringCore* self, const BLStringCore* other) ;
__declspec(dllimport) BLResult __cdecl blStringAssignDeep(BLStringCore* self, const BLStringCore* other) ;
__declspec(dllimport) BLResult __cdecl blStringAssignData(BLStringCore* self, const char* str, size_t n) ;
__declspec(dllimport) BLResult __cdecl blStringApplyOpChar(BLStringCore* self, uint32_t op, char c, size_t n) ;
__declspec(dllimport) BLResult __cdecl blStringApplyOpData(BLStringCore* self, uint32_t op, const char* str, size_t n) ;
__declspec(dllimport) BLResult __cdecl blStringApplyOpString(BLStringCore* self, uint32_t op, const BLStringCore* other) ;
__declspec(dllimport) BLResult __cdecl blStringApplyOpFormat(BLStringCore* self, uint32_t op, const char* fmt, ...) ;
__declspec(dllimport) BLResult __cdecl blStringApplyOpFormatV(BLStringCore* self, uint32_t op, const char* fmt, va_list ap) ;
__declspec(dllimport) BLResult __cdecl blStringInsertChar(BLStringCore* self, size_t index, char c, size_t n) ;
__declspec(dllimport) BLResult __cdecl blStringInsertData(BLStringCore* self, size_t index, const char* str, size_t n) ;
__declspec(dllimport) BLResult __cdecl blStringInsertString(BLStringCore* self, size_t index, const BLStringCore* other) ;
__declspec(dllimport) BLResult __cdecl blStringRemoveRange(BLStringCore* self, const BLRange* range) ;
__declspec(dllimport) _Bool     __cdecl blStringEquals(const BLStringCore* self, const BLStringCore* other) ;
__declspec(dllimport) _Bool     __cdecl blStringEqualsData(const BLStringCore* self, const char* str, size_t n) ;
__declspec(dllimport) int      __cdecl blStringCompare(const BLStringCore* self, const BLStringCore* other) ;
__declspec(dllimport) int      __cdecl blStringCompareData(const BLStringCore* self, const char* str, size_t n) ;
__declspec(dllimport) BLResult __cdecl blStrokeOptionsInit(BLStrokeOptionsCore* self) ;
__declspec(dllimport) BLResult __cdecl blStrokeOptionsInitMove(BLStrokeOptionsCore* self, BLStrokeOptionsCore* other) ;
__declspec(dllimport) BLResult __cdecl blStrokeOptionsInitWeak(BLStrokeOptionsCore* self, const BLStrokeOptionsCore* other) ;
__declspec(dllimport) BLResult __cdecl blStrokeOptionsReset(BLStrokeOptionsCore* self) ;
__declspec(dllimport) BLResult __cdecl blStrokeOptionsAssignMove(BLStrokeOptionsCore* self, BLStrokeOptionsCore* other) ;
__declspec(dllimport) BLResult __cdecl blStrokeOptionsAssignWeak(BLStrokeOptionsCore* self, const BLStrokeOptionsCore* other) ;
__declspec(dllimport) BLResult __cdecl blVariantInit(void* self) ;
__declspec(dllimport) BLResult __cdecl blVariantInitMove(void* self, void* other) ;
__declspec(dllimport) BLResult __cdecl blVariantInitWeak(void* self, const void* other) ;
__declspec(dllimport) BLResult __cdecl blVariantReset(void* self) ;
__declspec(dllimport) uint32_t __cdecl blVariantGetImplType(const void* self) ;
__declspec(dllimport) BLResult __cdecl blVariantAssignMove(void* self, void* other) ;
__declspec(dllimport) BLResult __cdecl blVariantAssignWeak(void* self, const void* other) ;
__declspec(dllimport) _Bool     __cdecl blVariantEquals(const void* a, const void* b) ;
enum BLImplType {
  BL_IMPL_TYPE_NULL = 0,
  BL_IMPL_TYPE_BIT_ARRAY = 1,
  BL_IMPL_TYPE_STRING = 2,
  BL_IMPL_TYPE_ARRAY_VAR = 3,
  BL_IMPL_TYPE_ARRAY_I8 = 4,
  BL_IMPL_TYPE_ARRAY_U8 = 5,
  BL_IMPL_TYPE_ARRAY_I16 = 6,
  BL_IMPL_TYPE_ARRAY_U16 = 7,
  BL_IMPL_TYPE_ARRAY_I32 = 8,
  BL_IMPL_TYPE_ARRAY_U32 = 9,
  BL_IMPL_TYPE_ARRAY_I64 = 10,
  BL_IMPL_TYPE_ARRAY_U64 = 11,
  BL_IMPL_TYPE_ARRAY_F32 = 12,
  BL_IMPL_TYPE_ARRAY_F64 = 13,
  BL_IMPL_TYPE_ARRAY_STRUCT_1 = 14,
  BL_IMPL_TYPE_ARRAY_STRUCT_2 = 15,
  BL_IMPL_TYPE_ARRAY_STRUCT_3 = 16,
  BL_IMPL_TYPE_ARRAY_STRUCT_4 = 17,
  BL_IMPL_TYPE_ARRAY_STRUCT_6 = 18,
  BL_IMPL_TYPE_ARRAY_STRUCT_8 = 19,
  BL_IMPL_TYPE_ARRAY_STRUCT_10 = 20,
  BL_IMPL_TYPE_ARRAY_STRUCT_12 = 21,
  BL_IMPL_TYPE_ARRAY_STRUCT_16 = 22,
  BL_IMPL_TYPE_ARRAY_STRUCT_20 = 23,
  BL_IMPL_TYPE_ARRAY_STRUCT_24 = 24,
  BL_IMPL_TYPE_ARRAY_STRUCT_32 = 25,
  BL_IMPL_TYPE_PATH = 32,
  BL_IMPL_TYPE_REGION = 33,
  BL_IMPL_TYPE_IMAGE = 34,
  BL_IMPL_TYPE_IMAGE_CODEC = 35,
  BL_IMPL_TYPE_IMAGE_DECODER = 36,
  BL_IMPL_TYPE_IMAGE_ENCODER = 37,
  BL_IMPL_TYPE_GRADIENT = 38,
  BL_IMPL_TYPE_PATTERN = 39,
  BL_IMPL_TYPE_CONTEXT = 40,
  BL_IMPL_TYPE_FONT = 50,
  BL_IMPL_TYPE_FONT_FACE = 51,
  BL_IMPL_TYPE_FONT_DATA = 52,
  BL_IMPL_TYPE_FONT_LOADER = 53,
  BL_IMPL_TYPE_FONT_FEATURE_OPTIONS = 54,
  BL_IMPL_TYPE_FONT_VARIATION_OPTIONS = 55,
  BL_IMPL_TYPE_COUNT = 64
};
enum BLImplTraits {
  BL_IMPL_TRAIT_MUTABLE = 0x01u,
  BL_IMPL_TRAIT_IMMUTABLE = 0x02u,
  BL_IMPL_TRAIT_EXTERNAL = 0x04u,
  BL_IMPL_TRAIT_FOREIGN = 0x08u,
  BL_IMPL_TRAIT_VIRT = 0x10u,
  BL_IMPL_TRAIT_NULL = 0x80u
};
struct BLVariantImpl {
  union {
    
    const void* virt;
    
    uintptr_t header[3];
  };
  volatile size_t refCount;
  uint8_t implType;
  uint8_t implTraits;
  uint16_t memPoolData;
  uint8_t reserved[4];
};
struct BLVariantCore {
  BLVariantImpl* impl;
};
__declspec(dllimport) BLVariantCore blNone[BL_IMPL_TYPE_COUNT];
struct BLArrayImpl {
  union {
    struct {
      
      void* data;
      
      size_t size;
    };
    
    BLDataView view;
  };
  size_t capacity;
  volatile size_t refCount;
  uint8_t implType;
  uint8_t implTraits;
  uint16_t memPoolData;
  uint8_t itemSize;
  uint8_t dispatchType;
  uint8_t reserved[2];
};
struct BLArrayCore {
  BLArrayImpl* impl;
};
enum BLGeometryDirection {
  BL_GEOMETRY_DIRECTION_NONE = 0,
  BL_GEOMETRY_DIRECTION_CW = 1,
  BL_GEOMETRY_DIRECTION_CCW = 2
};
enum BLGeometryType {
  BL_GEOMETRY_TYPE_NONE = 0,
  BL_GEOMETRY_TYPE_BOXI = 1,
  BL_GEOMETRY_TYPE_BOXD = 2,
  BL_GEOMETRY_TYPE_RECTI = 3,
  BL_GEOMETRY_TYPE_RECTD = 4,
  BL_GEOMETRY_TYPE_CIRCLE = 5,
  BL_GEOMETRY_TYPE_ELLIPSE = 6,
  BL_GEOMETRY_TYPE_ROUND_RECT = 7,
  BL_GEOMETRY_TYPE_ARC = 8,
  BL_GEOMETRY_TYPE_CHORD = 9,
  BL_GEOMETRY_TYPE_PIE = 10,
  BL_GEOMETRY_TYPE_LINE = 11,
  BL_GEOMETRY_TYPE_TRIANGLE = 12,
  BL_GEOMETRY_TYPE_POLYLINEI = 13,
  BL_GEOMETRY_TYPE_POLYLINED = 14,
  BL_GEOMETRY_TYPE_POLYGONI = 15,
  BL_GEOMETRY_TYPE_POLYGOND = 16,
  BL_GEOMETRY_TYPE_ARRAY_VIEW_BOXI = 17,
  BL_GEOMETRY_TYPE_ARRAY_VIEW_BOXD = 18,
  BL_GEOMETRY_TYPE_ARRAY_VIEW_RECTI = 19,
  BL_GEOMETRY_TYPE_ARRAY_VIEW_RECTD = 20,
  BL_GEOMETRY_TYPE_PATH = 21,
  BL_GEOMETRY_TYPE_REGION = 22,
  BL_GEOMETRY_TYPE_COUNT = 23
};
enum BLFillRule {
  BL_FILL_RULE_NON_ZERO = 0,
  BL_FILL_RULE_EVEN_ODD = 1,
  BL_FILL_RULE_COUNT = 2
};
enum BLHitTest {
  BL_HIT_TEST_IN = 0,
  BL_HIT_TEST_PART = 1,
  BL_HIT_TEST_OUT = 2,
  BL_HIT_TEST_INVALID = 0xFFFFFFFFu
};
struct BLPointI {
  int x;
  int y;
};
struct BLSizeI {
  int w;
  int h;
};
struct BLBoxI {
  int x0;
  int y0;
  int x1;
  int y1;
};
struct BLRectI {
  int x;
  int y;
  int w;
  int h;
};
struct BLPoint {
  double x;
  double y;
};
struct BLSize {
  double w;
  double h;
};
struct BLBox {
  double x0;
  double y0;
  double x1;
  double y1;
};
struct BLRect {
  double x;
  double y;
  double w;
  double h;
};
struct BLLine {
  double x0, y0;
  double x1, y1;
};
struct BLTriangle {
  double x0, y0;
  double x1, y1;
  double x2, y2;
};
struct BLRoundRect {
  double x, y, w, h;
  double rx, ry;
};
struct BLCircle {
  double cx, cy;
  double r;
};
struct BLEllipse {
  double cx, cy;
  double rx, ry;
};
struct BLArc {
  double cx, cy;
  double rx, ry;
  double start;
  double sweep;
};
enum BLGlyphItemFlags {
  BL_GLYPH_ITEM_FLAG_MARK = 0x80000000u
};
enum BLGlyphPlacementType {
  BL_GLYPH_PLACEMENT_TYPE_NONE = 0,
  BL_GLYPH_PLACEMENT_TYPE_ADVANCE_OFFSET = 1,
  BL_GLYPH_PLACEMENT_TYPE_DESIGN_UNITS = 2,
  BL_GLYPH_PLACEMENT_TYPE_USER_UNITS = 3,
  BL_GLYPH_PLACEMENT_TYPE_ABSOLUTE_UNITS = 4
};
enum BLGlyphRunFlags {
  BL_GLYPH_RUN_FLAG_UCS4_CONTENT              = 0x10000000u,
  BL_GLYPH_RUN_FLAG_INVALID_TEXT              = 0x20000000u,
  BL_GLYPH_RUN_FLAG_UNDEFINED_GLYPHS          = 0x40000000u,
  BL_GLYPH_RUN_FLAG_INVALID_FONT_DATA         = 0x80000000u
};
enum BLFontFaceType {
  BL_FONT_FACE_TYPE_NONE = 0,
  BL_FONT_FACE_TYPE_OPENTYPE = 1,
  BL_FONT_FACE_TYPE_COUNT = 2
};
enum BLFontFaceFlags {
  BL_FONT_FACE_FLAG_TYPOGRAPHIC_NAMES         = 0x00000001u,
  BL_FONT_FACE_FLAG_TYPOGRAPHIC_METRICS       = 0x00000002u,
  BL_FONT_FACE_FLAG_CHAR_TO_GLYPH_MAPPING     = 0x00000004u,
  BL_FONT_FACE_FLAG_HORIZONTAL_METIRCS        = 0x00000010u,
  BL_FONT_FACE_FLAG_VERTICAL_METRICS          = 0x00000020u,
  BL_FONT_FACE_FLAG_HORIZONTAL_KERNING        = 0x00000040u,
  BL_FONT_FACE_FLAG_VERTICAL_KERNING          = 0x00000080u,
  BL_FONT_FACE_FLAG_OPENTYPE_FEATURES         = 0x00000100u,
  BL_FONT_FACE_FLAG_OPENTYPE_VARIATIONS       = 0x20000000u,
  BL_FONT_FACE_FLAG_PANOSE_DATA               = 0x00000200u,
  BL_FONT_FACE_FLAG_UNICODE_COVERAGE          = 0x00000400u,
  BL_FONT_FACE_FLAG_VARIATION_SEQUENCES       = 0x10000000u,
  BL_FONT_FACE_FLAG_SYMBOL_FONT               = 0x40000000u,
  BL_FONT_FACE_FLAG_LAST_RESORT_FONT          = 0x80000000u
};
enum BLFontFaceDiagFlags {
  BL_FONT_FACE_DIAG_WRONG_NAME_DATA           = 0x00000001u,
  BL_FONT_FACE_DIAG_FIXED_NAME_DATA           = 0x00000002u,
  BL_FONT_FACE_DIAG_WRONG_KERN_DATA           = 0x00000004u,
  BL_FONT_FACE_DIAG_FIXED_KERN_DATA           = 0x00000008u,
  BL_FONT_FACE_DIAG_WRONG_CMAP_DATA           = 0x00000010u,
  BL_FONT_FACE_DIAG_WRONG_CMAP_FORMAT         = 0x00000020u,
  BL_FONT_FACE_DIAG_WRONG_GDEF_DATA           = 0x00000100u,
  BL_FONT_FACE_DIAG_WRONG_GPOS_DATA           = 0x00000400u,
  BL_FONT_FACE_DIAG_WRONG_GSUB_DATA           = 0x00001000u
};
enum BLFontLoaderFlags {
  BL_FONT_LOADER_FLAG_COLLECTION              = 0x00000001u  
};
enum BLFontOutlineType {
  BL_FONT_OUTLINE_TYPE_NONE                   = 0,
  BL_FONT_OUTLINE_TYPE_TRUETYPE               = 1,
  BL_FONT_OUTLINE_TYPE_CFF                    = 2,
  BL_FONT_OUTLINE_TYPE_CFF2                   = 3
};
enum BLFontStretch {
  BL_FONT_STRETCH_ULTRA_CONDENSED             = 1,
  BL_FONT_STRETCH_EXTRA_CONDENSED             = 2,
  BL_FONT_STRETCH_CONDENSED                   = 3,
  BL_FONT_STRETCH_SEMI_CONDENSED              = 4,
  BL_FONT_STRETCH_NORMAL                      = 5,
  BL_FONT_STRETCH_SEMI_EXPANDED               = 6,
  BL_FONT_STRETCH_EXPANDED                    = 7,
  BL_FONT_STRETCH_EXTRA_EXPANDED              = 8,
  BL_FONT_STRETCH_ULTRA_EXPANDED              = 9
};
enum BLFontStyle {
  BL_FONT_STYLE_NORMAL                        = 0,
  BL_FONT_STYLE_OBLIQUE                       = 1,
  BL_FONT_STYLE_ITALIC                        = 2,
  BL_FONT_STYLE_COUNT                         = 3
};
enum BLFontWeight {
  BL_FONT_WEIGHT_THIN                         = 100,
  BL_FONT_WEIGHT_EXTRA_LIGHT                  = 200,
  BL_FONT_WEIGHT_LIGHT                        = 300,
  BL_FONT_WEIGHT_SEMI_LIGHT                   = 350,
  BL_FONT_WEIGHT_NORMAL                       = 400,
  BL_FONT_WEIGHT_MEDIUM                       = 500,
  BL_FONT_WEIGHT_SEMI_BOLD                    = 600,
  BL_FONT_WEIGHT_BOLD                         = 700,
  BL_FONT_WEIGHT_EXTRA_BOLD                   = 800,
  BL_FONT_WEIGHT_BLACK                        = 900,
  BL_FONT_WEIGHT_EXTRA_BLACK                  = 950
};
enum BLFontStringId {
  BL_FONT_STRING_COPYRIGHT_NOTICE             = 0,
  BL_FONT_STRING_FAMILY_NAME                  = 1,
  BL_FONT_STRING_SUBFAMILY_NAME               = 2,
  BL_FONT_STRING_UNIQUE_IDENTIFIER            = 3,
  BL_FONT_STRING_FULL_NAME                    = 4,
  BL_FONT_STRING_VERSION_STRING               = 5,
  BL_FONT_STRING_POST_SCRIPT_NAME             = 6,
  BL_FONT_STRING_TRADEMARK                    = 7,
  BL_FONT_STRING_MANUFACTURER_NAME            = 8,
  BL_FONT_STRING_DESIGNER_NAME                = 9,
  BL_FONT_STRING_DESCRIPTION                  = 10,
  BL_FONT_STRING_VENDOR_URL                   = 11,
  BL_FONT_STRING_DESIGNER_URL                 = 12,
  BL_FONT_STRING_LICENSE_DESCRIPTION          = 13,
  BL_FONT_STRING_LICENSE_INFO_URL             = 14,
  BL_FONT_STRING_RESERVED                     = 15,
  BL_FONT_STRING_TYPOGRAPHIC_FAMILY_NAME      = 16,
  BL_FONT_STRING_TYPOGRAPHIC_SUBFAMILY_NAME   = 17,
  BL_FONT_STRING_COMPATIBLE_FULL_NAME         = 18,
  BL_FONT_STRING_SAMPLE_TEXT                  = 19,
  BL_FONT_STRING_POST_SCRIPT_CID_NAME         = 20,
  BL_FONT_STRING_WWS_FAMILY_NAME              = 21,
  BL_FONT_STRING_WWS_SUBFAMILY_NAME           = 22,
  BL_FONT_STRING_LIGHT_BACKGROUND_PALETTE     = 23,
  BL_FONT_STRING_DARK_BACKGROUND_PALETTE      = 24,
  BL_FONT_STRING_VARIATIONS_POST_SCRIPT_PREFIX= 25,
  BL_FONT_STRING_COMMON_COUNT                 = 26,
  BL_FONT_STRING_CUSTOM_START_INDEX           = 255
};
enum BLFontUnicodeCoverageIndex {
  BL_FONT_UC_INDEX_BASIC_LATIN,                              
  BL_FONT_UC_INDEX_LATIN1_SUPPLEMENT,                        
  BL_FONT_UC_INDEX_LATIN_EXTENDED_A,                         
  BL_FONT_UC_INDEX_LATIN_EXTENDED_B,                         
  BL_FONT_UC_INDEX_IPA_EXTENSIONS,                           
                                                             
                                                             
  BL_FONT_UC_INDEX_SPACING_MODIFIER_LETTERS,                 
                                                             
                                                             
  BL_FONT_UC_INDEX_COMBINING_DIACRITICAL_MARKS,              
  BL_FONT_UC_INDEX_GREEK_AND_COPTIC,                         
  BL_FONT_UC_INDEX_COPTIC,                                   
  BL_FONT_UC_INDEX_CYRILLIC,                                 
                                                             
                                                             
                                                             
  BL_FONT_UC_INDEX_ARMENIAN,                                 
  BL_FONT_UC_INDEX_HEBREW,                                   
  BL_FONT_UC_INDEX_VAI,                                      
  BL_FONT_UC_INDEX_ARABIC,                                   
                                                             
  BL_FONT_UC_INDEX_NKO,                                      
  BL_FONT_UC_INDEX_DEVANAGARI,                               
  BL_FONT_UC_INDEX_BENGALI,                                  
  BL_FONT_UC_INDEX_GURMUKHI,                                 
  BL_FONT_UC_INDEX_GUJARATI,                                 
  BL_FONT_UC_INDEX_ORIYA,                                    
  BL_FONT_UC_INDEX_TAMIL,                                    
  BL_FONT_UC_INDEX_TELUGU,                                   
  BL_FONT_UC_INDEX_KANNADA,                                  
  BL_FONT_UC_INDEX_MALAYALAM,                                
  BL_FONT_UC_INDEX_THAI,                                     
  BL_FONT_UC_INDEX_LAO,                                      
  BL_FONT_UC_INDEX_GEORGIAN,                                 
                                                             
  BL_FONT_UC_INDEX_BALINESE,                                 
  BL_FONT_UC_INDEX_HANGUL_JAMO,                              
  BL_FONT_UC_INDEX_LATIN_EXTENDED_ADDITIONAL,                
                                                             
                                                             
  BL_FONT_UC_INDEX_GREEK_EXTENDED,                           
  BL_FONT_UC_INDEX_GENERAL_PUNCTUATION,                      
                                                             
  BL_FONT_UC_INDEX_SUPERSCRIPTS_AND_SUBSCRIPTS,              
  BL_FONT_UC_INDEX_CURRENCY_SYMBOLS,                         
  BL_FONT_UC_INDEX_COMBINING_DIACRITICAL_MARKS_FOR_SYMBOLS,  
  BL_FONT_UC_INDEX_LETTERLIKE_SYMBOLS,                       
  BL_FONT_UC_INDEX_NUMBER_FORMS,                             
  BL_FONT_UC_INDEX_ARROWS,                                   
                                                             
                                                             
                                                             
  BL_FONT_UC_INDEX_MATHEMATICAL_OPERATORS,                   
                                                             
                                                             
                                                             
  BL_FONT_UC_INDEX_MISCELLANEOUS_TECHNICAL,                  
  BL_FONT_UC_INDEX_CONTROL_PICTURES,                         
  BL_FONT_UC_INDEX_OPTICAL_CHARACTER_RECOGNITION,            
  BL_FONT_UC_INDEX_ENCLOSED_ALPHANUMERICS,                   
  BL_FONT_UC_INDEX_BOX_DRAWING,                              
  BL_FONT_UC_INDEX_BLOCK_ELEMENTS,                           
  BL_FONT_UC_INDEX_GEOMETRIC_SHAPES,                         
  BL_FONT_UC_INDEX_MISCELLANEOUS_SYMBOLS,                    
  BL_FONT_UC_INDEX_DINGBATS,                                 
  BL_FONT_UC_INDEX_CJK_SYMBOLS_AND_PUNCTUATION,              
  BL_FONT_UC_INDEX_HIRAGANA,                                 
  BL_FONT_UC_INDEX_KATAKANA,                                 
                                                             
  BL_FONT_UC_INDEX_BOPOMOFO,                                 
                                                             
  BL_FONT_UC_INDEX_HANGUL_COMPATIBILITY_JAMO,                
  BL_FONT_UC_INDEX_PHAGS_PA,                                 
  BL_FONT_UC_INDEX_ENCLOSED_CJK_LETTERS_AND_MONTHS,          
  BL_FONT_UC_INDEX_CJK_COMPATIBILITY,                        
  BL_FONT_UC_INDEX_HANGUL_SYLLABLES,                         
  BL_FONT_UC_INDEX_NON_PLANE,                                
  BL_FONT_UC_INDEX_PHOENICIAN,                               
  BL_FONT_UC_INDEX_CJK_UNIFIED_IDEOGRAPHS,                   
                                                             
                                                             
                                                             
                                                             
                                                             
                                                             
  BL_FONT_UC_INDEX_PRIVATE_USE_PLANE0,                       
  BL_FONT_UC_INDEX_CJK_STROKES,                              
                                                             
                                                             
  BL_FONT_UC_INDEX_ALPHABETIC_PRESENTATION_FORMS,            
  BL_FONT_UC_INDEX_ARABIC_PRESENTATION_FORMS_A,              
  BL_FONT_UC_INDEX_COMBINING_HALF_MARKS,                     
  BL_FONT_UC_INDEX_VERTICAL_FORMS,                           
                                                             
  BL_FONT_UC_INDEX_SMALL_FORM_VARIANTS,                      
  BL_FONT_UC_INDEX_ARABIC_PRESENTATION_FORMS_B,              
  BL_FONT_UC_INDEX_HALFWIDTH_AND_FULLWIDTH_FORMS,            
  BL_FONT_UC_INDEX_SPECIALS,                                 
  BL_FONT_UC_INDEX_TIBETAN,                                  
  BL_FONT_UC_INDEX_SYRIAC,                                   
  BL_FONT_UC_INDEX_THAANA,                                   
  BL_FONT_UC_INDEX_SINHALA,                                  
  BL_FONT_UC_INDEX_MYANMAR,                                  
  BL_FONT_UC_INDEX_ETHIOPIC,                                 
                                                             
                                                             
  BL_FONT_UC_INDEX_CHEROKEE,                                 
  BL_FONT_UC_INDEX_UNIFIED_CANADIAN_ABORIGINAL_SYLLABICS,    
  BL_FONT_UC_INDEX_OGHAM,                                    
  BL_FONT_UC_INDEX_RUNIC,                                    
  BL_FONT_UC_INDEX_KHMER,                                    
                                                             
  BL_FONT_UC_INDEX_MONGOLIAN,                                
  BL_FONT_UC_INDEX_BRAILLE_PATTERNS,                         
  BL_FONT_UC_INDEX_YI_SYLLABLES_AND_RADICALS,                
                                                             
  BL_FONT_UC_INDEX_TAGALOG_HANUNOO_BUHID_TAGBANWA,           
                                                             
                                                             
                                                             
  BL_FONT_UC_INDEX_OLD_ITALIC,                               
  BL_FONT_UC_INDEX_GOTHIC,                                   
  BL_FONT_UC_INDEX_DESERET,                                  
  BL_FONT_UC_INDEX_MUSICAL_SYMBOLS,                          
                                                             
                                                             
  BL_FONT_UC_INDEX_MATHEMATICAL_ALPHANUMERIC_SYMBOLS,        
  BL_FONT_UC_INDEX_PRIVATE_USE_PLANE_15_16,                  
                                                             
  BL_FONT_UC_INDEX_VARIATION_SELECTORS,                      
                                                             
  BL_FONT_UC_INDEX_TAGS,                                     
  BL_FONT_UC_INDEX_LIMBU,                                    
  BL_FONT_UC_INDEX_TAI_LE,                                   
  BL_FONT_UC_INDEX_NEW_TAI_LUE,                              
  BL_FONT_UC_INDEX_BUGINESE,                                 
  BL_FONT_UC_INDEX_GLAGOLITIC,                               
  BL_FONT_UC_INDEX_TIFINAGH,                                 
  BL_FONT_UC_INDEX_YIJING_HEXAGRAM_SYMBOLS,                  
  BL_FONT_UC_INDEX_SYLOTI_NAGRI,                             
  BL_FONT_UC_INDEX_LINEAR_B_SYLLABARY_AND_IDEOGRAMS,         
                                                             
                                                             
  BL_FONT_UC_INDEX_ANCIENT_GREEK_NUMBERS,                    
  BL_FONT_UC_INDEX_UGARITIC,                                 
  BL_FONT_UC_INDEX_OLD_PERSIAN,                              
  BL_FONT_UC_INDEX_SHAVIAN,                                  
  BL_FONT_UC_INDEX_OSMANYA,                                  
  BL_FONT_UC_INDEX_CYPRIOT_SYLLABARY,                        
  BL_FONT_UC_INDEX_KHAROSHTHI,                               
  BL_FONT_UC_INDEX_TAI_XUAN_JING_SYMBOLS,                    
  BL_FONT_UC_INDEX_CUNEIFORM,                                
                                                             
  BL_FONT_UC_INDEX_COUNTING_ROD_NUMERALS,                    
  BL_FONT_UC_INDEX_SUNDANESE,                                
  BL_FONT_UC_INDEX_LEPCHA,                                   
  BL_FONT_UC_INDEX_OL_CHIKI,                                 
  BL_FONT_UC_INDEX_SAURASHTRA,                               
  BL_FONT_UC_INDEX_KAYAH_LI,                                 
  BL_FONT_UC_INDEX_REJANG,                                   
  BL_FONT_UC_INDEX_CHAM,                                     
  BL_FONT_UC_INDEX_ANCIENT_SYMBOLS,                          
  BL_FONT_UC_INDEX_PHAISTOS_DISC,                            
  BL_FONT_UC_INDEX_CARIAN_LYCIAN_LYDIAN,                     
                                                             
                                                             
  BL_FONT_UC_INDEX_DOMINO_AND_MAHJONG_TILES,                 
                                                             
  BL_FONT_UC_INDEX_INTERNAL_USAGE_123,                       
  BL_FONT_UC_INDEX_INTERNAL_USAGE_124,                       
  BL_FONT_UC_INDEX_INTERNAL_USAGE_125,                       
  BL_FONT_UC_INDEX_INTERNAL_USAGE_126,                       
  BL_FONT_UC_INDEX_INTERNAL_USAGE_127                        
};
enum BLTextDirection {
  BL_TEXT_DIRECTION_LTR = 0,
  BL_TEXT_DIRECTION_RTL = 1,
  BL_TEXT_DIRECTION_COUNT = 2
};
enum BLTextOrientation {
  BL_TEXT_ORIENTATION_HORIZONTAL = 0,
  BL_TEXT_ORIENTATION_VERTICAL = 1,
  BL_TEXT_ORIENTATION_COUNT = 2
};
struct BLGlyphItem {
  union {
    uint32_t value;
    struct {
    
      BLGlyphId glyphId;
      uint16_t reserved;
    
    };
  };
};
struct BLGlyphInfo {
  uint32_t cluster;
  uint32_t reserved[2];
};
struct BLGlyphPlacement {
  BLPointI placement;
  BLPointI advance;
};
struct BLGlyphMappingState {
  size_t glyphCount;
  size_t undefinedFirst;
  size_t undefinedCount;
};
struct BLGlyphOutlineSinkInfo {
  size_t glyphIndex;
  size_t contourCount;
};
struct BLGlyphRun {
  void* glyphIdData;
  void* placementData;
  size_t size;
  uint8_t glyphIdSize;
  uint8_t placementType;
  int8_t glyphIdAdvance;
  int8_t placementAdvance;
  uint32_t flags;
};
struct BLFontFaceInfo {
  uint8_t faceType;
  uint8_t outlineType;
  uint16_t glyphCount;
  uint32_t faceIndex;
  uint32_t faceFlags;
  uint32_t diagFlags;
};
struct BLFontTable {
  const uint8_t* data;
  size_t size;
};
struct BLFontFeature {
  BLTag tag;
  uint32_t value;
};
struct BLFontVariation {
  BLTag tag;
  float value;
};
struct BLFontUnicodeCoverage {
  uint32_t data[4];
};
struct BLFontPanose {
  union {
    uint8_t data[10];
    uint8_t familyKind;
    struct {
      uint8_t familyKind;
      uint8_t serifStyle;
      uint8_t weight;
      uint8_t proportion;
      uint8_t contrast;
      uint8_t strokeVariation;
      uint8_t armStyle;
      uint8_t letterform;
      uint8_t midline;
      uint8_t xHeight;
    } text;
    struct {
      uint8_t familyKind;
      uint8_t toolKind;
      uint8_t weight;
      uint8_t spacing;
      uint8_t aspectRatio;
      uint8_t contrast;
      uint8_t topology;
      uint8_t form;
      uint8_t finials;
      uint8_t xAscent;
    } script;
    struct {
      uint8_t familyKind;
      uint8_t decorativeClass;
      uint8_t weight;
      uint8_t aspect;
      uint8_t contrast;
      uint8_t serifVariant;
      uint8_t treatment;
      uint8_t lining;
      uint8_t topology;
      uint8_t characterRange;
    } decorative;
    struct {
      uint8_t familyKind;
      uint8_t symbolKind;
      uint8_t weight;
      uint8_t spacing;
      uint8_t aspectRatioAndContrast;
      uint8_t aspectRatio94;
      uint8_t aspectRatio119;
      uint8_t aspectRatio157;
      uint8_t aspectRatio163;
      uint8_t aspectRatio211;
    } symbol;
  };
};
struct BLFontMatrix {
  union {
    double m[4];
    struct {
      double m00;
      double m01;
      double m10;
      double m11;
    };
  };
};
struct BLFontMetrics {
  float size;
  union {
    struct {
      
      float ascent;
      
      float vAscent;
      
      float descent;
      
      float vDescent;
    };
    struct {
      float ascentByOrientation[2];
      float descentByOrientation[2];
    };
  };
  float lineGap;
  float xHeight;
  float capHeight;
  float underlinePosition;
  float underlineThickness;
  float strikethroughPosition;
  float strikethroughThickness;
};
struct BLFontDesignMetrics {
  int unitsPerEm;
  int lineGap;
  int xHeight;
  int capHeight;
  union {
    struct {
      
      int ascent;
      
      int vAscent;
      
      int descent;
      
      int vDescent;
      
      int hMinLSB;
      
      int vMinLSB;
      
      int hMinTSB;
      
      int vMinTSB;
      
      int hMaxAdvance;
      
      int vMaxAdvance;
    };
    struct {
      
      int ascentByOrientation[2];
      
      int descentByOrientation[2];
      
      int minLSBByOrientation[2];
      
      int minTSBByOrientation[2];
      
      int maxAdvanceByOrientation[2];
    };
  };
  int underlinePosition;
  int underlineThickness;
  int strikethroughPosition;
  int strikethroughThickness;
};
struct BLTextMetrics {
  BLPoint advance;
  BLBox boundingBox;
};
struct BLGlyphBufferImpl {
  union {
    struct {
      
      BLGlyphItem* glyphItemData;
      
      BLGlyphPlacement* placementData;
      
      size_t size;
      
      uint32_t reserved;
      
      uint32_t flags;
    };
    
    BLGlyphRun glyphRun;
  };
  BLGlyphInfo* glyphInfoData;
};
struct BLGlyphBufferCore {
  BLGlyphBufferImpl* impl;
};
enum BLPathCmd {
  BL_PATH_CMD_MOVE = 0,
  BL_PATH_CMD_ON = 1,
  BL_PATH_CMD_QUAD = 2,
  BL_PATH_CMD_CUBIC = 3,
  BL_PATH_CMD_CLOSE = 4,
  BL_PATH_CMD_COUNT = 5
};
enum BLPathCmdExtra {
  BL_PATH_CMD_PRESERVE = 0xFFFFFFFFu
};
enum BLPathFlags {
  BL_PATH_FLAG_EMPTY = 0x00000001u,
  BL_PATH_FLAG_MULTIPLE = 0x00000002u,
  BL_PATH_FLAG_QUADS = 0x00000004u,
  BL_PATH_FLAG_CUBICS = 0x00000008u,
  BL_PATH_FLAG_INVALID = 0x40000000u,
  BL_PATH_FLAG_DIRTY = 0x80000000u
};
enum BLPathReverseMode {
  BL_PATH_REVERSE_MODE_COMPLETE = 0,
  BL_PATH_REVERSE_MODE_SEPARATE = 1,
  BL_PATH_REVERSE_MODE_COUNT = 2
};
enum BLStrokeJoin {
  BL_STROKE_JOIN_MITER_CLIP = 0,
  BL_STROKE_JOIN_MITER_BEVEL = 1,
  BL_STROKE_JOIN_MITER_ROUND = 2,
  BL_STROKE_JOIN_BEVEL = 3,
  BL_STROKE_JOIN_ROUND = 4,
  BL_STROKE_JOIN_COUNT = 5
};
enum BLStrokeCapPosition {
  BL_STROKE_CAP_POSITION_START = 0,
  BL_STROKE_CAP_POSITION_END = 1,
  BL_STROKE_CAP_POSITION_COUNT = 2
};
enum BLStrokeCap {
  BL_STROKE_CAP_BUTT = 0,
  BL_STROKE_CAP_SQUARE = 1,
  BL_STROKE_CAP_ROUND = 2,
  BL_STROKE_CAP_ROUND_REV = 3,
  BL_STROKE_CAP_TRIANGLE = 4,
  BL_STROKE_CAP_TRIANGLE_REV = 5,
  BL_STROKE_CAP_COUNT = 6
};
enum BLStrokeTransformOrder {
  BL_STROKE_TRANSFORM_ORDER_AFTER = 0,
  BL_STROKE_TRANSFORM_ORDER_BEFORE = 1,
  BL_STROKE_TRANSFORM_ORDER_COUNT = 2
};
enum BLFlattenMode {
  BL_FLATTEN_MODE_DEFAULT = 0,
  BL_FLATTEN_MODE_RECURSIVE = 1,
  BL_FLATTEN_MODE_COUNT = 2
};
enum BLOffsetMode {
  BL_OFFSET_MODE_DEFAULT = 0,
  BL_OFFSET_MODE_ITERATIVE = 1,
  BL_OFFSET_MODE_COUNT = 2
};
struct BLApproximationOptions {
  uint8_t flattenMode;
  uint8_t offsetMode;
  uint8_t reservedFlags[6];
  double flattenTolerance;
  double simplifyTolerance;
  double offsetParameter;
};
__declspec(dllimport) const BLApproximationOptions blDefaultApproximationOptions;
struct BLStrokeOptionsCore {
  union {
    struct {
      uint8_t startCap;
      uint8_t endCap;
      uint8_t join;
      uint8_t transformOrder;
      uint8_t reserved[4];
    };
    uint8_t caps[BL_STROKE_CAP_POSITION_COUNT];
    uint64_t hints;
  };
  double width;
  double miterLimit;
  double dashOffset;
  BLArrayCore dashArray;
};
struct BLPathView {
  const uint8_t* commandData;
  const BLPoint* vertexData;
  size_t size;
};
struct BLPathImpl {
  union {
    struct {
      
      uint8_t* commandData;
      
      BLPoint* vertexData;
      
      size_t size;
    };
    
    BLPathView view;
  };
  volatile size_t refCount;
  uint8_t implType;
  uint8_t implTraits;
  uint16_t memPoolData;
  volatile uint32_t flags;
  size_t capacity;
};
struct BLPathCore {
  BLPathImpl* impl;
};
struct BLStringImpl {
  union {
    struct {
      
      char* data;
      
      size_t size;
    };
    
    BLStringView view;
  };
  size_t capacity;
  volatile size_t refCount;
  uint8_t implType;
  uint8_t implTraits;
  uint16_t memPoolData;
  uint8_t reserved[4];
};
struct BLStringCore {
  BLStringImpl* impl;
};
struct BLFontDataVirt {
  BLResult (__cdecl* destroy)(BLFontDataImpl* impl) ;
  BLResult (__cdecl* listTags)(const BLFontDataImpl* impl, BLArrayCore* out) ;
  size_t (__cdecl* queryTables)(const BLFontDataImpl* impl, BLFontTable* dst, const BLTag* tags, size_t n) ;
};
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
struct BLFontDataCore {
  BLFontDataImpl* impl;
};
struct BLFontLoaderVirt {
  BLResult (__cdecl* destroy)(BLFontLoaderImpl* impl) ;
  BLFontDataImpl* (__cdecl* dataByFaceIndex)(BLFontLoaderImpl* impl, uint32_t faceIndex) ;
};
struct BLFontLoaderImpl {
  const BLFontLoaderVirt* virt;
  void* data;
  size_t size;
  volatile size_t refCount;
  uint8_t implType;
  uint8_t implTraits;
  uint16_t memPoolData;
  uint8_t faceType;
  uint32_t faceCount;
  uint32_t loaderFlags;
};
struct BLFontLoaderCore {
  BLFontLoaderImpl* impl;
};
struct BLFontFaceVirt {
  BLResult (__cdecl* destroy)(BLFontFaceImpl* impl) ;
};
struct BLFontFaceImpl {
  const BLFontFaceVirt* virt;
  BLFontDataCore data;
  BLFontLoaderCore loader;
  volatile size_t refCount;
  uint8_t implType;
  uint8_t implTraits;
  uint16_t memPoolData;
  uint16_t weight;
  uint8_t stretch;
  uint8_t style;
  BLFontFaceInfo faceInfo;
  uint64_t faceUniqueId;
  BLStringCore fullName;
  BLStringCore familyName;
  BLStringCore subfamilyName;
  BLStringCore postScriptName;
  BLFontDesignMetrics designMetrics;
  BLFontUnicodeCoverage unicodeCoverage;
  BLFontPanose panose;
};
struct BLFontFaceCore {
  BLFontFaceImpl* impl;
};
struct BLFontImpl {
  BLFontFaceCore face;
  BLArrayCore features;
  BLArrayCore variations;
  volatile size_t refCount;
  uint8_t implType;
  uint8_t implTraits;
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
enum BLFormat {
  BL_FORMAT_NONE = 0,
  BL_FORMAT_PRGB32 = 1,
  BL_FORMAT_XRGB32 = 2,
  BL_FORMAT_A8 = 3,
  BL_FORMAT_COUNT = 4,
  BL_FORMAT_RESERVED_COUNT = 16
};
enum BLFormatFlags {
  BL_FORMAT_FLAG_RGB = 0x00000001u,
  BL_FORMAT_FLAG_ALPHA = 0x00000002u,
  BL_FORMAT_FLAG_RGBA = 0x00000003u,
  BL_FORMAT_FLAG_LUM = 0x00000004u,
  BL_FORMAT_FLAG_LUMA = 0x00000006u,
  BL_FORMAT_FLAG_INDEXED = 0x00000010u,
  BL_FORMAT_FLAG_PREMULTIPLIED = 0x00000100u,
  BL_FORMAT_FLAG_BYTE_SWAP = 0x00000200u,
  BL_FORMAT_FLAG_BYTE_ALIGNED = 0x00010000u
};
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
__declspec(dllimport) const BLFormatInfo blFormatInfo[BL_FORMAT_RESERVED_COUNT];
enum BLImageCodecFeatures {
  BL_IMAGE_CODEC_FEATURE_READ                 = 0x00000001u,
  BL_IMAGE_CODEC_FEATURE_WRITE                = 0x00000002u,
  BL_IMAGE_CODEC_FEATURE_LOSSLESS             = 0x00000004u,
  BL_IMAGE_CODEC_FEATURE_LOSSY                = 0x00000008u,
  BL_IMAGE_CODEC_FEATURE_MULTI_FRAME          = 0x00000010u,
  BL_IMAGE_CODEC_FEATURE_IPTC                 = 0x10000000u,
  BL_IMAGE_CODEC_FEATURE_EXIF                 = 0x20000000u,
  BL_IMAGE_CODEC_FEATURE_XMP                  = 0x40000000u
};
enum BLImageInfoFlags {
  BL_IMAGE_INFO_FLAG_PROGRESSIVE              = 0x00000001u
};
enum BLImageScaleFilter {
  BL_IMAGE_SCALE_FILTER_NONE = 0,
  BL_IMAGE_SCALE_FILTER_NEAREST = 1,
  BL_IMAGE_SCALE_FILTER_BILINEAR = 2,
  BL_IMAGE_SCALE_FILTER_BICUBIC = 3,
  BL_IMAGE_SCALE_FILTER_BELL = 4,
  BL_IMAGE_SCALE_FILTER_GAUSS = 5,
  BL_IMAGE_SCALE_FILTER_HERMITE = 6,
  BL_IMAGE_SCALE_FILTER_HANNING = 7,
  BL_IMAGE_SCALE_FILTER_CATROM = 8,
  BL_IMAGE_SCALE_FILTER_BESSEL = 9,
  BL_IMAGE_SCALE_FILTER_SINC = 10,
  BL_IMAGE_SCALE_FILTER_LANCZOS = 11,
  BL_IMAGE_SCALE_FILTER_BLACKMAN = 12,
  BL_IMAGE_SCALE_FILTER_MITCHELL = 13,
  BL_IMAGE_SCALE_FILTER_USER = 14,
  BL_IMAGE_SCALE_FILTER_COUNT = 15
};
typedef BLResult (__cdecl* BLImageScaleUserFunc)(double* dst, const double* tArray, size_t n, const void* data) ;
struct BLImageData {
  void* pixelData;
  intptr_t stride;
  BLSizeI size;
  uint32_t format;
  uint32_t flags;
};
struct BLImageInfo {
  BLSizeI size;
  BLSize density;
  uint32_t flags;
  uint16_t depth;
  uint16_t planeCount;
  uint64_t frameCount;
  char format[16];
  char compression[16];
};
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
struct BLImageCore {
  BLImageImpl* impl;
};
struct BLImageCodecVirt {
  BLResult (__cdecl* destroy)(BLImageCodecImpl* impl) ;
  uint32_t (__cdecl* inspectData)(const BLImageCodecImpl* impl, const uint8_t* data, size_t size) ;
  BLResult (__cdecl* createDecoder)(const BLImageCodecImpl* impl, BLImageDecoderCore* dst) ;
  BLResult (__cdecl* createEncoder)(const BLImageCodecImpl* impl, BLImageEncoderCore* dst) ;
};
struct BLImageCodecImpl {
  const BLImageCodecVirt* virt;
  const char* name;
  const char* vendor;
  volatile size_t refCount;
  uint8_t implType;
  uint8_t implTraits;
  uint16_t memPoolData;
  uint32_t features;
  const char* mimeType;
  const char* extensions;
};
struct BLImageCodecCore {
  BLImageCodecImpl* impl;
};
struct BLImageDecoderVirt {
  BLResult (__cdecl* destroy)(BLImageDecoderImpl* impl) ;
  BLResult (__cdecl* restart)(BLImageDecoderImpl* impl) ;
  BLResult (__cdecl* readInfo)(BLImageDecoderImpl* impl, BLImageInfo* infoOut, const uint8_t* data, size_t size) ;
  BLResult (__cdecl* readFrame)(BLImageDecoderImpl* impl, BLImageCore* imageOut, const uint8_t* data, size_t size) ;
};
struct BLImageDecoderImpl {
  const BLImageDecoderVirt* virt;
  BLImageCodecCore codec;
  void* handle;
  volatile size_t refCount;
  uint8_t implType;
  uint8_t implTraits;
  uint16_t memPoolData;
  BLResult lastResult;
  uint64_t frameIndex;
  size_t bufferIndex;
};
struct BLImageDecoderCore {
  BLImageDecoderImpl* impl;
};
struct BLImageEncoderVirt {
  BLResult (__cdecl* destroy)(BLImageEncoderImpl* impl) ;
  BLResult (__cdecl* restart)(BLImageEncoderImpl* impl) ;
  BLResult (__cdecl* writeFrame)(BLImageEncoderImpl* impl, BLArrayCore* dst, const BLImageCore* image) ;
};
struct BLImageEncoderImpl {
  const BLImageEncoderVirt* virt;
  BLImageCodecCore codec;
  void* handle;
  volatile size_t refCount;
  uint8_t implType;
  uint8_t implTraits;
  uint16_t memPoolData;
  BLResult lastResult;
  uint64_t frameIndex;
  size_t bufferIndex;
};
struct BLImageEncoderCore {
  BLImageEncoderImpl* impl;
};
typedef BLResult (__cdecl* BLMapPointDArrayFunc)(const void* ctx, BLPoint* dst, const BLPoint* src, size_t count) ;
enum BLMatrix2DType {
  BL_MATRIX2D_TYPE_IDENTITY = 0,
  BL_MATRIX2D_TYPE_TRANSLATE = 1,
  BL_MATRIX2D_TYPE_SCALE = 2,
  BL_MATRIX2D_TYPE_SWAP = 3,
  BL_MATRIX2D_TYPE_AFFINE = 4,
  BL_MATRIX2D_TYPE_INVALID = 5,
  BL_MATRIX2D_TYPE_COUNT = 6
};
enum BLMatrix2DValue {
  BL_MATRIX2D_VALUE_00 = 0,
  BL_MATRIX2D_VALUE_01 = 1,
  BL_MATRIX2D_VALUE_10 = 2,
  BL_MATRIX2D_VALUE_11 = 3,
  BL_MATRIX2D_VALUE_20 = 4,
  BL_MATRIX2D_VALUE_21 = 5,
  BL_MATRIX2D_VALUE_COUNT = 6
};
enum BLMatrix2DOp {
  BL_MATRIX2D_OP_RESET = 0,
  BL_MATRIX2D_OP_ASSIGN = 1,
  BL_MATRIX2D_OP_TRANSLATE = 2,
  BL_MATRIX2D_OP_SCALE = 3,
  BL_MATRIX2D_OP_SKEW = 4,
  BL_MATRIX2D_OP_ROTATE = 5,
  BL_MATRIX2D_OP_ROTATE_PT = 6,
  BL_MATRIX2D_OP_TRANSFORM = 7,
  BL_MATRIX2D_OP_POST_TRANSLATE = 8,
  BL_MATRIX2D_OP_POST_SCALE = 9,
  BL_MATRIX2D_OP_POST_SKEW = 10,
  BL_MATRIX2D_OP_POST_ROTATE = 11,
  BL_MATRIX2D_OP_POST_ROTATE_PT = 12,
  BL_MATRIX2D_OP_POST_TRANSFORM = 13,
  BL_MATRIX2D_OP_COUNT = 14
};
struct BLMatrix2D {
  union {
    
    double m[BL_MATRIX2D_VALUE_COUNT];
    
    struct {
      double m00;
      double m01;
      double m10;
      double m11;
      double m20;
      double m21;
    };
  };
};
__declspec(dllimport) BLMapPointDArrayFunc blMatrix2DMapPointDArrayFuncs[BL_MATRIX2D_TYPE_COUNT];
struct BLRgba32 {
  union {
    uint32_t value;
    struct {
    
      uint32_t b : 8;
      uint32_t g : 8;
      uint32_t r : 8;
      uint32_t a : 8;
    
    };
  };
};
struct BLRgba64 {
  union {
    uint64_t value;
    struct {
    
      uint32_t b : 16;
      uint32_t g : 16;
      uint32_t r : 16;
      uint32_t a : 16;
    
    };
  };
};
struct BLRgba128 {
  float r;
  float g;
  float b;
  float a;
};
enum BLRegionType {
  BL_REGION_TYPE_EMPTY = 0,
  BL_REGION_TYPE_RECT = 1,
  BL_REGION_TYPE_COMPLEX = 2,
  BL_REGION_TYPE_COUNT = 3
};
struct BLRegionImpl {
  union {
    struct {
      
      BLBoxI* data;
      
      size_t size;
    };
    
    BLRegionView view;
  };
  size_t capacity;
  volatile size_t refCount;
  uint8_t implType;
  uint8_t implTraits;
  uint16_t memPoolData;
  uint8_t reserved[4];
  BLBoxI boundingBox;
};
struct BLRegionCore {
  BLRegionImpl* impl;
};
enum BLContextType {
  BL_CONTEXT_TYPE_NONE = 0,
  BL_CONTEXT_TYPE_DUMMY = 1,
  BL_CONTEXT_TYPE_RASTER = 3,
  BL_CONTEXT_TYPE_COUNT = 4
};
enum BLContextHint {
  BL_CONTEXT_HINT_RENDERING_QUALITY = 0,
  BL_CONTEXT_HINT_GRADIENT_QUALITY = 1,
  BL_CONTEXT_HINT_PATTERN_QUALITY = 2,
  BL_CONTEXT_HINT_COUNT = 8
};
enum BLContextOpType {
  BL_CONTEXT_OP_TYPE_FILL = 0,
  BL_CONTEXT_OP_TYPE_STROKE = 1,
  BL_CONTEXT_OP_TYPE_COUNT = 2
};
enum BLContextFlushFlags {
  BL_CONTEXT_FLUSH_SYNC = 0x80000000u
};
enum BLContextCreateFlags {
  BL_CONTEXT_CREATE_FLAG_FORCE_THREADS = 0x00000001u,
  BL_CONTEXT_CREATE_FLAG_FALLBACK_TO_SYNC = 0x00000002u,
  BL_CONTEXT_CREATE_FLAG_ISOLATED_THREADS = 0x00000010u,
  BL_CONTEXT_CREATE_FLAG_ISOLATED_JIT = 0x00000020u,
  BL_CONTEXT_CREATE_FLAG_OVERRIDE_CPU_FEATURES = 0x00000040u
};
enum BLClipMode {
  BL_CLIP_MODE_ALIGNED_RECT = 0,
  BL_CLIP_MODE_UNALIGNED_RECT = 1,
  BL_CLIP_MODE_MASK = 2,
  BL_CLIP_MODE_COUNT = 3
};
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
enum BLGradientQuality {
  BL_GRADIENT_QUALITY_NEAREST = 0,
  BL_GRADIENT_QUALITY_COUNT = 1
};
enum BLPatternQuality {
  BL_PATTERN_QUALITY_NEAREST = 0,
  BL_PATTERN_QUALITY_BILINEAR = 1,
  BL_PATTERN_QUALITY_COUNT = 2
};
enum BLRenderingQuality {
  BL_RENDERING_QUALITY_ANTIALIAS = 0,
  BL_RENDERING_QUALITY_COUNT = 1
};
struct BLContextCreateInfo {
  uint32_t flags;
  uint32_t threadCount;
  uint32_t cpuFeatures;
  uint32_t reserved[5];
};
struct BLContextCookie {
  uint64_t data[2];
};
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
struct BLContextState {
  BLContextHints hints;
  uint8_t compOp;
  uint8_t fillRule;
  uint8_t styleType[2];
  uint8_t reserved[4];
  BLApproximationOptions approximationOptions;
  double globalAlpha;
  double styleAlpha[2];
  BLStrokeOptionsCore strokeOptions;
  BLMatrix2D metaMatrix;
  BLMatrix2D userMatrix;
  size_t savedStateCount;
};
struct BLContextVirt {
  BLResult (__cdecl* destroy                )(BLContextImpl* impl) ;
  BLResult (__cdecl* flush                  )(BLContextImpl* impl, uint32_t flags) ;
  BLResult (__cdecl* save                   )(BLContextImpl* impl, BLContextCookie* cookie) ;
  BLResult (__cdecl* restore                )(BLContextImpl* impl, const BLContextCookie* cookie) ;
  BLResult (__cdecl* matrixOp               )(BLContextImpl* impl, uint32_t opType, const void* opData) ;
  BLResult (__cdecl* userToMeta             )(BLContextImpl* impl) ;
  BLResult (__cdecl* setHint                )(BLContextImpl* impl, uint32_t hintType, uint32_t value) ;
  BLResult (__cdecl* setHints               )(BLContextImpl* impl, const BLContextHints* hints) ;
  BLResult (__cdecl* setFlattenMode         )(BLContextImpl* impl, uint32_t mode) ;
  BLResult (__cdecl* setFlattenTolerance    )(BLContextImpl* impl, double tolerance) ;
  BLResult (__cdecl* setApproximationOptions)(BLContextImpl* impl, const BLApproximationOptions* options) ;
  BLResult (__cdecl* setCompOp              )(BLContextImpl* impl, uint32_t compOp) ;
  BLResult (__cdecl* setGlobalAlpha         )(BLContextImpl* impl, double alpha) ;
  BLResult (__cdecl* setStyleAlpha[2]       )(BLContextImpl* impl, double alpha) ;
  BLResult (__cdecl* getStyle[2]            )(BLContextImpl* impl, void* object) ;
  BLResult (__cdecl* getStyleRgba32[2]      )(BLContextImpl* impl, uint32_t* rgba32) ;
  BLResult (__cdecl* getStyleRgba64[2]      )(BLContextImpl* impl, uint64_t* rgba64) ;
  BLResult (__cdecl* setStyle[2]            )(BLContextImpl* impl, const void* object) ;
  BLResult (__cdecl* setStyleRgba32[2]      )(BLContextImpl* impl, uint32_t rgba32) ;
  BLResult (__cdecl* setStyleRgba64[2]      )(BLContextImpl* impl, uint64_t rgba64) ;
  BLResult (__cdecl* setFillRule            )(BLContextImpl* impl, uint32_t fillRule) ;
  BLResult (__cdecl* setStrokeWidth         )(BLContextImpl* impl, double width) ;
  BLResult (__cdecl* setStrokeMiterLimit    )(BLContextImpl* impl, double miterLimit) ;
  BLResult (__cdecl* setStrokeCap           )(BLContextImpl* impl, uint32_t position, uint32_t strokeCap) ;
  BLResult (__cdecl* setStrokeCaps          )(BLContextImpl* impl, uint32_t strokeCap) ;
  BLResult (__cdecl* setStrokeJoin          )(BLContextImpl* impl, uint32_t strokeJoin) ;
  BLResult (__cdecl* setStrokeDashOffset    )(BLContextImpl* impl, double dashOffset) ;
  BLResult (__cdecl* setStrokeDashArray     )(BLContextImpl* impl, const BLArrayCore* dashArray) ;
  BLResult (__cdecl* setStrokeTransformOrder)(BLContextImpl* impl, uint32_t transformOrder) ;
  BLResult (__cdecl* setStrokeOptions       )(BLContextImpl* impl, const BLStrokeOptionsCore* options) ;
  BLResult (__cdecl* clipToRectI            )(BLContextImpl* impl, const BLRectI* rect) ;
  BLResult (__cdecl* clipToRectD            )(BLContextImpl* impl, const BLRect* rect) ;
  BLResult (__cdecl* restoreClipping        )(BLContextImpl* impl) ;
  BLResult (__cdecl* clearAll               )(BLContextImpl* impl) ;
  BLResult (__cdecl* clearRectI             )(BLContextImpl* impl, const BLRectI* rect) ;
  BLResult (__cdecl* clearRectD             )(BLContextImpl* impl, const BLRect* rect) ;
  BLResult (__cdecl* fillAll                )(BLContextImpl* impl) ;
  BLResult (__cdecl* fillRectI              )(BLContextImpl* impl, const BLRectI* rect) ;
  BLResult (__cdecl* fillRectD              )(BLContextImpl* impl, const BLRect* rect) ;
  BLResult (__cdecl* fillPathD              )(BLContextImpl* impl, const BLPathCore* path) ;
  BLResult (__cdecl* fillGeometry           )(BLContextImpl* impl, uint32_t geometryType, const void* geometryData) ;
  BLResult (__cdecl* fillTextI              )(BLContextImpl* impl, const BLPointI* pt, const BLFontCore* font, const void* text, size_t size, uint32_t encoding) ;
  BLResult (__cdecl* fillTextD              )(BLContextImpl* impl, const BLPoint* pt, const BLFontCore* font, const void* text, size_t size, uint32_t encoding) ;
  BLResult (__cdecl* fillGlyphRunI          )(BLContextImpl* impl, const BLPointI* pt, const BLFontCore* font, const BLGlyphRun* glyphRun) ;
  BLResult (__cdecl* fillGlyphRunD          )(BLContextImpl* impl, const BLPoint* pt, const BLFontCore* font, const BLGlyphRun* glyphRun) ;
  BLResult (__cdecl* strokeRectI            )(BLContextImpl* impl, const BLRectI* rect) ;
  BLResult (__cdecl* strokeRectD            )(BLContextImpl* impl, const BLRect*  rect) ;
  BLResult (__cdecl* strokePathD            )(BLContextImpl* impl, const BLPathCore* path) ;
  BLResult (__cdecl* strokeGeometry         )(BLContextImpl* impl, uint32_t geometryType, const void* geometryData) ;
  BLResult (__cdecl* strokeTextI            )(BLContextImpl* impl, const BLPointI* pt, const BLFontCore* font, const void* text, size_t size, uint32_t encoding) ;
  BLResult (__cdecl* strokeTextD            )(BLContextImpl* impl, const BLPoint* pt, const BLFontCore* font, const void* text, size_t size, uint32_t encoding) ;
  BLResult (__cdecl* strokeGlyphRunI        )(BLContextImpl* impl, const BLPointI* pt, const BLFontCore* font, const BLGlyphRun* glyphRun) ;
  BLResult (__cdecl* strokeGlyphRunD        )(BLContextImpl* impl, const BLPoint* pt, const BLFontCore* font, const BLGlyphRun* glyphRun) ;
  BLResult (__cdecl* blitImageI             )(BLContextImpl* impl, const BLPointI* pt, const BLImageCore* img, const BLRectI* imgArea) ;
  BLResult (__cdecl* blitImageD             )(BLContextImpl* impl, const BLPoint* pt, const BLImageCore* img, const BLRectI* imgArea) ;
  BLResult (__cdecl* blitScaledImageI       )(BLContextImpl* impl, const BLRectI* rect, const BLImageCore* img, const BLRectI* imgArea) ;
  BLResult (__cdecl* blitScaledImageD       )(BLContextImpl* impl, const BLRect* rect, const BLImageCore* img, const BLRectI* imgArea) ;
};
struct BLContextImpl {
  const BLContextVirt* virt;
  const BLContextState* state;
  void* reservedHeader;
  volatile size_t refCount;
  uint8_t implType;
  uint8_t implTraits;
  uint16_t memPoolData;
  uint32_t contextType;
  BLSize targetSize;
};
struct BLContextCore {
  BLContextImpl* impl;
};
enum BLFileOpenFlags {
  BL_FILE_OPEN_READ = 0x00000001u,
  BL_FILE_OPEN_WRITE = 0x00000002u,
  BL_FILE_OPEN_RW = 0x00000003u,
  BL_FILE_OPEN_CREATE = 0x00000004u,
  BL_FILE_OPEN_DELETE = 0x00000008u,
  BL_FILE_OPEN_TRUNCATE = 0x00000010u,
  BL_FILE_OPEN_READ_EXCLUSIVE = 0x10000000u,
  BL_FILE_OPEN_WRITE_EXCLUSIVE = 0x20000000u,
  BL_FILE_OPEN_RW_EXCLUSIVE = 0x30000000u,
  BL_FILE_OPEN_CREATE_EXCLUSIVE = 0x40000000u,
  BL_FILE_OPEN_DELETE_EXCLUSIVE = 0x80000000u
};
enum BLFileSeek {
  BL_FILE_SEEK_SET = 0,
  BL_FILE_SEEK_CUR = 1,
  BL_FILE_SEEK_END = 2,
  BL_FILE_SEEK_COUNT = 3
};
enum BLFileReadFlags {
  BL_FILE_READ_MMAP_ENABLED = 0x00000001u,
  BL_FILE_READ_MMAP_AVOID_SMALL = 0x00000002u,
  BL_FILE_READ_MMAP_NO_FALLBACK = 0x00000008u
};
struct BLFileCore {
  intptr_t handle;
};
enum BLGradientType {
  BL_GRADIENT_TYPE_LINEAR = 0,
  BL_GRADIENT_TYPE_RADIAL = 1,
  BL_GRADIENT_TYPE_CONICAL = 2,
  BL_GRADIENT_TYPE_COUNT = 3
};
enum BLGradientValue {
  BL_GRADIENT_VALUE_COMMON_X0 = 0,
  BL_GRADIENT_VALUE_COMMON_Y0 = 1,
  BL_GRADIENT_VALUE_COMMON_X1 = 2,
  BL_GRADIENT_VALUE_COMMON_Y1 = 3,
  BL_GRADIENT_VALUE_RADIAL_R0 = 4,
  BL_GRADIENT_VALUE_CONICAL_ANGLE = 2,
  BL_GRADIENT_VALUE_COUNT = 6
};
struct BLGradientStop {
  double offset;
  BLRgba64 rgba;
};
struct BLLinearGradientValues {
  double x0;
  double y0;
  double x1;
  double y1;
};
struct BLRadialGradientValues {
  double x0;
  double y0;
  double x1;
  double y1;
  double r0;
};
struct BLConicalGradientValues {
  double x0;
  double y0;
  double angle;
};
struct BLGradientImpl {
  union {
    struct {
      
      BLGradientStop* stops;
      
      size_t size;
    };
    BLArrayView values;
  };
  size_t capacity;
  size_t refCount;
  uint8_t implType;
  uint8_t implTraits;
  uint16_t memPoolData;
  uint8_t gradientType;
  uint8_t extendMode;
  uint8_t matrixType;
  uint8_t reserved[1];
  BLMatrix2D matrix;
  union {
    
    double values[BL_GRADIENT_VALUE_COUNT];
    
    BLLinearGradientValues linear;
    
    BLRadialGradientValues radial;
    
    BLConicalGradientValues conical;
  };
};
struct BLGradientCore {
  BLGradientImpl* impl;
};
struct BLPatternImpl {
  BLImageCore image;
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
};
struct BLPatternCore {
  BLPatternImpl* impl;
};
typedef BLResult (__cdecl* BLPixelConverterFunc)(
  const BLPixelConverterCore* self,
  uint8_t* dstData, intptr_t dstStride,
  const uint8_t* srcData, intptr_t srcStride,
  uint32_t w, uint32_t h, const BLPixelConverterOptions* options) ;
struct BLPixelConverterOptions {
  BLPointI origin;
  size_t gap;
};
struct BLPixelConverterCore {
  BLPixelConverterFunc convertFunc;
  union {
    uint8_t strategy;
    
    uint8_t data[64];
  };
};
struct BLRandom {
  uint64_t data[2];
};
enum BLRuntimeLimits {
  BL_RUNTIME_MAX_IMAGE_SIZE = 65535,
  BL_RUNTIME_MAX_THREAD_COUNT = 32
};
enum BLRuntimeInfoType {
  BL_RUNTIME_INFO_TYPE_BUILD = 0,
  BL_RUNTIME_INFO_TYPE_SYSTEM = 1,
  BL_RUNTIME_INFO_TYPE_MEMORY = 2,
  BL_RUNTIME_INFO_TYPE_COUNT = 3
};
enum BLRuntimeBuildType {
  BL_RUNTIME_BUILD_TYPE_DEBUG = 0,
  BL_RUNTIME_BUILD_TYPE_RELEASE = 1
};
enum BLRuntimeCpuArch {
  BL_RUNTIME_CPU_ARCH_UNKNOWN = 0,
  BL_RUNTIME_CPU_ARCH_X86 = 1,
  BL_RUNTIME_CPU_ARCH_ARM = 2,
  BL_RUNTIME_CPU_ARCH_MIPS = 3
};
enum BLRuntimeCpuFeatures {
  BL_RUNTIME_CPU_FEATURE_X86_SSE2 = 0x00000001u,
  BL_RUNTIME_CPU_FEATURE_X86_SSE3 = 0x00000002u,
  BL_RUNTIME_CPU_FEATURE_X86_SSSE3 = 0x00000004u,
  BL_RUNTIME_CPU_FEATURE_X86_SSE4_1 = 0x00000008u,
  BL_RUNTIME_CPU_FEATURE_X86_SSE4_2 = 0x00000010u,
  BL_RUNTIME_CPU_FEATURE_X86_AVX = 0x00000020u,
  BL_RUNTIME_CPU_FEATURE_X86_AVX2 = 0x00000040u
};
enum BLRuntimeCleanupFlags {
  BL_RUNTIME_CLEANUP_OBJECT_POOL = 0x00000001u,
  BL_RUNTIME_CLEANUP_ZEROED_POOL = 0x00000002u,
  BL_RUNTIME_CLEANUP_THREAD_POOL = 0x00000010u,
  BL_RUNTIME_CLEANUP_EVERYTHING = 0xFFFFFFFFu
};
struct BLRuntimeBuildInfo {
  union {
    
    uint32_t version;
    
    struct {
    
      uint8_t patchVersion;
      uint8_t minorVersion;
      uint16_t majorVersion;
    
    };
  };
  uint32_t buildType;
  uint32_t baselineCpuFeatures;
  uint32_t supportedCpuFeatures;
  uint32_t maxImageSize;
  uint32_t maxThreadCount;
  uint32_t reserved[2];
  char compilerInfo[32];
};
struct BLRuntimeSystemInfo {
  uint32_t cpuArch;
  uint32_t cpuFeatures;
  uint32_t coreCount;
  uint32_t threadCount;
  uint32_t minThreadStackSize;
  uint32_t minWorkerStackSize;
  uint32_t allocationGranularity;
  uint32_t reserved[5];
};
struct BLRuntimeMemoryInfo {
  size_t vmUsed;
  size_t vmReserved;
  size_t vmOverhead;
  size_t vmBlockCount;
  size_t zmUsed;
  size_t zmReserved;
  size_t zmOverhead;
  size_t zmBlockCount;
  size_t dynamicPipelineCount;
};
]]

return ffi.load("blend2d")