--[[
// // [Blend2D]
// 2D Vector Graphics Powered by a JIT Compiler.
//
// [License]
// ZLIB - See LICENSE.md file in the package.
--]]

local ffi = require("ffi")
local C = ffi.C 

if not BLEND2D_BLGRADIENT_H then
BLEND2D_BLGRADIENT_H = true

local blapi = require("blend2d.blapi")

require("blend2d.blgeometry")
require("blend2d.blmatrix")
require("blend2d.blrgba")
require("blend2d.blvariant")

ffi.cdef[[
//! Gradient type.
enum BLGradientType {
  BL_GRADIENT_TYPE_LINEAR = 0,
  BL_GRADIENT_TYPE_RADIAL = 1,
  BL_GRADIENT_TYPE_CONICAL = 2,

  BL_GRADIENT_TYPE_COUNT = 3
};

//! Gradient data index.
enum BLGradientValue {

  BL_GRADIENT_VALUE_COMMON_X0 = 0,
  BL_GRADIENT_VALUE_COMMON_Y0 = 1,
  BL_GRADIENT_VALUE_COMMON_X1 = 2,
  BL_GRADIENT_VALUE_COMMON_Y1 = 3,
  BL_GRADIENT_VALUE_RADIAL_R0 = 4,
  BL_GRADIENT_VALUE_CONICAL_ANGLE = 2,

  BL_GRADIENT_VALUE_COUNT = 6
};
]]

ffi.cdef[[
//! Defines an `offset` and `rgba` color that us used by `BLGradient` to define
//! a linear transition between colors.
struct BLGradientStop {
  double offset;
  BLRgba64 rgba;
};
]]

ffi.cdef[[
//! Linear gradient values packed into a structure.
struct BLLinearGradientValues {
  double x0;
  double y0;
  double x1;
  double y1;
};
]]


ffi.cdef[[
//! Radial gradient values packed into a structure.
struct BLRadialGradientValues {
  double x0;
  double y0;
  double x1;
  double y1;
  double r0;
};
]]


ffi.cdef[[
//! Conical gradient values packed into a structure.
struct BLConicalGradientValues {
  double x0;
  double y0;
  double angle;
};
]]


ffi.cdef[[
//! Gradient [C Interface - Impl].
struct BLGradientImpl {
  union {
    struct {
      BLGradientStop* stops;
      size_t size;
    };

  };


  size_t capacity;


  volatile size_t refCount;
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
]]


ffi.cdef[[
//! Gradient [C Interface - Core].
struct BLGradientCore {
  BLGradientImpl* impl;
};
]]



BLGradientStop = ffi.typeof("BLGradientStop")
BLLinearGradientValues = ffi.typeof("struct BLLinearGradientValues")
BLRadialGradientValues = ffi.typeof("struct BLRadialGradientValues")
BLConicalGradientValues = ffi.typeof("struct BLConicalGradientValues")

BLGradientCore = ffi.typeof("struct BLGradientCore")
BLGradient = BLGradientCore
local BLGradient_mt = {
    __gc = function(self)
        return blapi.blGradientReset(self);
    end;

    -- This function is only called when you use the 'constructor'
    -- method of creating a gradient, such as:
    -- BLGradient(BLLinearValues({0,0,256,256}))
    -- it is NOT called when you simply do ffi.new("struct BLGradientCore")
    __new = function(ct, ...)
        local nargs = select("#", ...)
        local obj = ffi.new(ct);

        if nargs == 0 then
            local bResult = blapi.blGradientInit(obj) ;
        elseif nargs == 1 then
            local gType = 0
            local values = select(1,...)
            if ffi.typeof(values) ==   BLLinearGradientValues then
                local bResult = blapi.blGradientInitAs(obj, C.BL_GRADIENT_TYPE_LINEAR, values, C.BL_EXTEND_MODE_PAD, nil, 0, nil) ;
                if bResult ~= C.BL_SUCCESS then
                  return false, bResult;
                end
            elseif ffi.typeof(values) == BLRadialGradientValues then
              local bResult = blapi.blGradientInitAs(obj, C.BL_GRADIENT_TYPE_RADIAL, values, C.BL_EXTEND_MODE_PAD, nil, 0, nil) ;
              if bResult ~= C.BL_SUCCESS then
                return false, bResult;
              end
            elseif ffi.typeof(values) == BLConicalGradientValues then
              local bResult = blapi.blGradientInitAs(obj, C.BL_GRADIENT_TYPE_CONICAL, values, C.BL_EXTEND_MODE_PAD, nil, 0, nil) ;
              if bResult ~= C.BL_SUCCESS then
                return false, bResult;
              end
            end
        elseif nargs == 6 then
            local bResult = blapi.blGradientInitAs(obj, select(1,...), select(2,...), select(3,...), select(4,...), select(5,...), select(6,...)) ;
            if bResult ~= C.BL_SUCCESS then
              return false, bResult;
            end
        end

        return obj;
    end;

    __index = {
        addStopRgba64 = function(self, offset, argb64)
          return blapi.blGradientAddStopRgba64(self, offset, argb64);
        end;
        
        addStopRgba32 = function(self, offset, argb32)
            return blapi.blGradientAddStopRgba32(self, offset, argb32);
        end;

        addStop = function(self, offset, obj)
          if type(obj) == "number" then
            return self:addStopRgba32(offset, obj)
          elseif ffi.typeof(obj) == BLRgba32 then
            return self:addStopRgba32(offset, obj.value)
          end
        end;
    };
}
ffi.metatype(BLGradient, BLGradient_mt )

end -- BLEND2D_BLGRADIENT_H
