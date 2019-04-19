--[[
// [Blend2D]
// 2D Vector Graphics Powered by a JIT Compiler.
//
// [License]
// ZLIB - See LICENSE.md file in the package.
--]]

local ffi = require("ffi")



local blapi = require("blend2d.blapi")

ffi.cdef[[
struct BLRandom {
  uint64_t data[2];
};
]]
BLRandom = ffi.typeof("struct BLRandom")
ffi.metatype(BLRandom, {
    __index = {
        __new = function(ct, ...)
            local obj = ffi.new(ct)
            blapi.blRandomReset(obj, math.random(1, 65535))

            return obj;
        end;

        reset = function(self, seed)
            return blapi.blRandomReset(self, seed)
        end;
      
        nextUInt32 = function(self)
            return blapi.blRandomNextUInt32(self);
        end;

        nextUInt64 = function(self)
            return blapi.blRandomNextUInt64(self);
        end;

        nextDouble = function(self)
            return blapi.blRandomNextDouble(self);
        end;

    }
})


return BLRandom
