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


BLFile = ffi.typeof("struct BLFileCore")
local BLFile_mt = {
    __gc = function(self)
        local bResult = blapi.blFileReset(self);
    end;
    
    __new = function(ct, ...)
        local obj = ffi.new(ct)
        local bResult = blapi.blFileInit(obj);
        return obj
    end;

    __index = {
        close = function(self)
            local bResult = blapi.blFileClose(self) ;
            return bResult == C.BL_SUCCESS or bResult;
        end;

        open = function(self, fileName, openFlags)
            --print("open: ", fileName, string.format("0x%x",openFlags))

            openFlags = openFlags or C.BL_FILE_OPEN_READ;
            local bResult = blapi.blFileOpen(self, fileName, openFlags) ;

            if bResult ~= C.BL_SUCCESS then
                return false, bResult
            end

            return true;
        end;

        read = function(self, buffer, size)
            local bytesTransferred = ffi.new("size_t[1]")
            local bResult = blapi.blFileRead(self, buffer, size, bytesTransferred) ;
            
            if bResult ~= C.BL_SUCCESS then
              return false, bResult;
            end

          return bytesTransferred[0]
        end;

        write = function(self, buffer, size)
            local bytesTransferred = ffi.new("size_t[1]")
            local bResult = blapi.blFileWrite(self, buffer, size, bytesTransferred) ;
            if bResult ~= C.BL_SUCCESS then
                return false, bResult;
            end

            return bytesTransferred[0]
        end;

        seek = function(self, offset, seekType)
          seekType = seekType or C.BL_FILE_SEEK_SET
            local pOut = ffi.new("uint64_t[1]")
            local bResult = blapi.blFileSeek(self, offset, seekType, pOut)
            if bResult ~= C.BL_SUCCESS then
                return false, bReasult, pOut[0]
            end
            return pOut[0]
        end;

        size = function(self)
            local pSize = ffi.new("uint64_t[1]")
            local bResult = blapi.blFileGetSize(self, pSize)
            if bResult ~= C.BL_SUCCESS then
                return false, bResult;
            end

            return pSize[0]
        end;

        truncate = function(self, maxSize)
            local bResult = blapi.blFileTruncate(self, maxSize) ;
            return bResult == C.BL_SUCCESS;
        end;
    }
}
ffi.metatype(BLFile, BLFile_mt)

end -- BLEND2D_BLFILESYSTEM_H
