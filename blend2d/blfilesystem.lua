--[[
// [Blend2D]
// 2D Vector Graphics Powered by a JIT Compiler.
//
// [License]
// ZLIB - See LICENSE.md file in the package.
--]]

local ffi = require("ffi")
local C = ffi.C 

if not BLEND2D_BLFILESYSTEM_H then
BLEND2D_BLFILESYSTEM_H = true

local blapi = require("blend2d.blapi")
require("blend2d.blarray")


ffi.cdef[[
enum   BLFileOpenFlags {
  BL_FILE_OPEN_READ = 0x00000001,
  BL_FILE_OPEN_WRITE = 0x00000002,
  BL_FILE_OPEN_RW = 0x00000003,

  BL_FILE_OPEN_CREATE = 0x00000004,
  BL_FILE_OPEN_CREATE_ONLY = 0x00000008,
  BL_FILE_OPEN_TRUNCATE = 0x00000010,

  BL_FILE_OPEN_SHARE_READ = 0x10000000,
  BL_FILE_OPEN_SHARE_WRITE = 0x20000000,
  BL_FILE_OPEN_SHARE_RW = 0x30000000,
  BL_FILE_OPEN_SHARE_DELETE = 0x40000000
};


enum  BLFileSeek {
  BL_FILE_SEEK_SET = 0,
  BL_FILE_SEEK_CUR = 1,
  BL_FILE_SEEK_END = 2,

  BL_FILE_SEEK_COUNT = 3
};

struct BLFileCore {
  intptr_t handle;
};
]]



end -- BLEND2D_BLFILESYSTEM_H
