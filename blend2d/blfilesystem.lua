--[[
// [Blend2D]
// 2D Vector Graphics Powered by a JIT Compiler.
//
// [License]
// ZLIB - See LICENSE.md file in the package.
--]]

local ffi = require("ffi")

if not BLEND2D_BLFILESYSTEM_H then
BLEND2D_BLFILESYSTEM_H = true

require("blend2d.blarray")


ffi.cdef[[
enum   BLFileOpenFlags {
  //! Open file for reading (O_RDONLY).
  BL_FILE_OPEN_READ = 0x00000001u,
  //! Open file for writing (O_WRONLY).
  BL_FILE_OPEN_WRITE = 0x00000002u,
  //! Open file for reading & writing (O_RDWR).
  BL_FILE_OPEN_RW = 0x00000003u,
  //! Create the file if it doesnt exist (O_CREAT).
  BL_FILE_OPEN_CREATE = 0x00000004u,
  //! Always create the file, fail if it already exists (O_EXCL).
  BL_FILE_OPEN_CREATE_ONLY = 0x00000008u,
  //! Truncate the file (O_TRUNC).
  BL_FILE_OPEN_TRUNCATE = 0x00000010u,
  //! Enables FILE_SHARE_READ option (Windows).
  BL_FILE_OPEN_SHARE_READ = 0x10000000u,
  //! Enables FILE_SHARE_WRITE option (Windows).
  BL_FILE_OPEN_SHARE_WRITE = 0x20000000u,
  //! Enables both FILE_SHARE_READ and FILE_SHARE_WRITE options (Windows).
  BL_FILE_OPEN_SHARE_RW = 0x30000000u,
  //! Enables FILE_SHARE_DELETE option (Windows).
  BL_FILE_OPEN_SHARE_DELETE = 0x40000000u
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
