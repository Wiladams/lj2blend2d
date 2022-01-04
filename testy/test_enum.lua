local ffi = require("ffi")
local C = ffi.C

ffi.cdef[[
typedef enum BLFormat BLFormat; 
enum  BLFormat {
  BL_FORMAT_NONE = 0,
  BL_FORMAT_PRGB32 = 1,
  BL_FORMAT_XRGB32 = 2,
  BL_FORMAT_A8 = 3,
  BL_FORMAT_MAX_VALUE = 3,
  BL_FORMAT_RESERVED_COUNT = 16
  ,BL_FORMAT_FORCE_UINT = 0xFFFFFFFFu
};
]]

print(ffi.C.BL_FORMAT_PRGB32)
