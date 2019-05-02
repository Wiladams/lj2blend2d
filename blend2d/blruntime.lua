--[[
// [Blend2D]
// 2D Vector Graphics Powered by a JIT Compiler.
//
// [License]
// ZLIB - See LICENSE.md file in the package.
--]]

local ffi = require("ffi")

if not BLEND2D_BLRUNTIME_H then
BLEND2D_BLRUNTIME_H = true

--require("blend2d.blapi")

ffi.cdef[[
//! Runtime limits.
enum BLRuntimeLimits {
  //! Maximum width and height of an image.
  BL_RUNTIME_MAX_IMAGE_SIZE = 65535
};
]]

ffi.cdef[[
//! Type of runtime information that can be queried through `blRuntimeQueryInfo()`.
enum  BLRuntimeInfoType {
  //! Runtime information about Blend2D build.
  BL_RUNTIME_INFO_TYPE_BUILD = 0,
  //! Runtime information about host CPU.
  BL_RUNTIME_INFO_TYPE_CPU = 1,
  //! Runtime information regarding memory used, reserved, etc...
  BL_RUNTIME_INFO_TYPE_MEMORY = 2,

  //! Count of runtime information types.
  BL_RUNTIME_INFO_TYPE_COUNT = 3
};
]]

ffi.cdef[[
//! Blend2D runtime build type.
enum  BLRuntimeBuildType {
  //! Describes a Blend2D debug build.
  BL_RUNTIME_BUILD_TYPE_DEBUG = 0,
  //! Describes a Blend2D release build.
  BL_RUNTIME_BUILD_TYPE_RELEASE = 1
};
]]

ffi.cdef[[
//! CPU architecture that can be queried by `BLRuntime::queryCpuInfo()`.
enum BLRuntimeCpuArch {
  //! Unknown architecture.
  BL_RUNTIME_CPU_ARCH_UNKNOWN = 0,
  //! 32-bit or 64-bit X86 architecture.
  BL_RUNTIME_CPU_ARCH_X86 = 1,
  //! 32-bit or 64-bit ARM architecture.
  BL_RUNTIME_CPU_ARCH_ARM = 2,
  //! 32-bit or 64-bit MIPS architecture.
  BL_RUNTIME_CPU_ARCH_MIPS = 3
};
]]

ffi.cdef[[
//! CPU features Blend2D supports.
enum BLRuntimeCpuFeatures {
  BL_RUNTIME_CPU_FEATURE_X86_SSE = 0x00000001u,
  BL_RUNTIME_CPU_FEATURE_X86_SSE2 = 0x00000002u,
  BL_RUNTIME_CPU_FEATURE_X86_SSE3 = 0x00000004u,
  BL_RUNTIME_CPU_FEATURE_X86_SSSE3 = 0x00000008u,
  BL_RUNTIME_CPU_FEATURE_X86_SSE4_1 = 0x00000010u,
  BL_RUNTIME_CPU_FEATURE_X86_SSE4_2 = 0x00000020u,
  BL_RUNTIME_CPU_FEATURE_X86_AVX = 0x00000040u,
  BL_RUNTIME_CPU_FEATURE_X86_AVX2 = 0x00000080u
};
]]

ffi.cdef[[
//! Runtime cleanup flags that can be used through `BLRuntime::cleanup()`.
enum BLRuntimeCleanupFlags {
  BL_RUNTIME_CLEANUP_OBJECT_POOL = 0x00000001u,
  BL_RUNTIME_CLEANUP_ZEROED_POOL = 0x00000002u,
  BL_RUNTIME_CLEANUP_EVERYTHING = 0xFFFFFFFFu
};
]]

-- ============================================================================
-- [BLRuntime - BuildInfo]
-- ============================================================================
if BL_BUILD_BYTE_ORDER == 1234 then
ffi.cdef[[
//! Blend2D build information.
struct BLRuntimeBuildInfo {
  union {
    //! Blend2D version stored as `((MAJOR << 16) | (MINOR << 8) | PATCH)`.
    uint32_t version;

    //! Decomposed Blend2D version so its easier to access without bit shifting.
    struct {
      uint8_t patchVersion;
      uint8_t minorVersion;
      uint16_t majorVersion;
    };
  };

  //! Blend2D build type, see `BLRuntimeBuildType`.
  uint32_t buildType;

  //! Identification of the C++ compiler used to build Blend2D.
  char compilerInfo[24];
};
]]
else
ffi.cdef[[
        //! Blend2D build information.
        struct BLRuntimeBuildInfo {
          union {
            //! Blend2D version stored as `((MAJOR << 16) | (MINOR << 8) | PATCH)`.
            uint32_t version;
        
            //! Decomposed Blend2D version so its easier to access without bit shifting.
            struct {
              uint16_t majorVersion;
              uint8_t minorVersion;
              uint8_t patchVersion;
            };
          };
        
          //! Blend2D build type, see `BLRuntimeBuildType`.
          uint32_t buildType;
        
          //! Identification of the C++ compiler used to build Blend2D.
          char compilerInfo[24];
};
]]
end

ffi.cdef[[
// ============================================================================
// [BLRuntime - CpuInfo]
// ============================================================================

//! CPU information queried by the runtime.
struct BLRuntimeCpuInfo {
  //! Host CPU architecture, see `BLRuntimeCpuArch`.
  uint32_t arch;
  //! Host CPU features, see `BLRuntimeCpuFeatures`.
  uint32_t features;
  //! Number of threads of the host CPU.
  uint32_t threadCount;

};
]]

ffi.cdef[[
// ============================================================================
// [BLRuntime - MemoryInfo]
// ============================================================================

//! Blend2D memory information that provides how much memory Blend2D allocated
//! and some other details about memory use.
struct BLRuntimeMemoryInfo {
  //! Virtual memory used at this time.
  size_t vmUsed;
  //! Virtual memory reserved (allocated internally).
  size_t vmReserved;
  //! Overhead required to manage virtual memory allocations.
  size_t vmOverhead;
  //! Number of blocks of virtual memory allocated.
  size_t vmBlockCount;

  //! Zeroed memory used at this time.
  size_t zmUsed;
  //! Zeroed memory reserved (allocated internally).
  size_t zmReserved;
  //! Overhead required to manage zeroed memory allocations.
  size_t zmOverhead;
  //! Number of blocks of zeroed memory allocated.
  size_t zmBlockCount;

  //! Count of dynamic pipelines created and cached.
  size_t dynamicPipelineCount;


};
]]

end -- BLEND2D_BLRUNTIME_H
