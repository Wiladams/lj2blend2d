--[[
// [Blend2D]
// 2D Vector Graphics Powered by a JIT Compiler.
//
// [License]
// ZLIB - See LICENSE.md file in the package.
--]]

local ffi = require("ffi")
local C = ffi.C 

if not BLEND2D_BLPATTERN_H then
BLEND2D_BLPATTERN_H = true

local blapi = require("blend2d.blapi")

require("blend2d.blgeometry")
require("blend2d.blimage")
require("blend2d.blmatrix")
require("blend2d.blvariant")


ffi.cdef[[
//! Pattern [C Interface - Impl].
struct BLPatternImpl {
  //! Image used by the pattern.
  //BL_TYPED_MEMBER(BLImageCore, BLImage, image);
  union {BLImageCore image;};


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

  //BL_HAS_TYPED_MEMBERS(BLPatternImpl)
};

//! Pattern [C Interface - Core].
struct BLPatternCore {
  BLPatternImpl* impl;
};
]]
BLPattern = ffi.typeof("struct BLPatternCore")
BLPatternCore = BLPattern
local BLPattern_mt = {
    __gc = function(self)
        blapi.blPatternReset(self) ;
    end;

  --  BLResult __cdecl blPatternInit(BLPatternCore* self) ;
--BLResult __cdecl blPatternInitAs(BLPatternCore* self, const BLImageCore* image, const BLRectI* area, uint32_t extendMode, const BLMatrix2D* m) ;

    __new = function(ct, ...)
        local nargs = select('#', ...)
        local obj = ffi.new(ct)
        if nargs == 0 then
            blapi.blPatternInit(obj) ;
        elseif nargs == 1 then
            blapi.blPatternInitAs(obj, select(1,...), nil, 0, nil);
        end

        return obj;
    end;

    __index = {
        _applyMatrixOp = function(self, opType, opData)
            local bResult = blapi.blPatternApplyMatrixOp(self, opType, opData) ;
            return bResult == C.BL_SUCCESS or bResult
        end;
    };

    __eq = function(self, other)
        return blapi.blPatternEquals(self, other) ;
    end;
}
ffi.metatype(BLPattern, BLPattern_mt)



--[[

BLResult __cdecl blPatternAssignMove(BLPatternCore* self, BLPatternCore* other) ;
BLResult __cdecl blPatternAssignWeak(BLPatternCore* self, const BLPatternCore* other) ;
BLResult __cdecl blPatternAssignDeep(BLPatternCore* self, const BLPatternCore* other) ;
BLResult __cdecl blPatternCreate(BLPatternCore* self, const BLImageCore* image, const BLRectI* area, uint32_t extendMode, const BLMatrix2D* m) ;
BLResult __cdecl blPatternSetImage(BLPatternCore* self, const BLImageCore* image, const BLRectI* area) ;
BLResult __cdecl blPatternSetArea(BLPatternCore* self, const BLRectI* area) ;
BLResult __cdecl blPatternSetExtendMode(BLPatternCore* self, uint32_t extendMode) ;
bool     __cdecl blPatternEquals(const BLPatternCore* a, const BLPatternCore* b) ;
]]

end -- BLEND2D_BLPATTERN_H
