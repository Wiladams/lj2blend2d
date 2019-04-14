--[[
// // [Blend2D]
// 2D Vector Graphics Powered by a JIT Compiler.
//
// [License]
// ZLIB - See LICENSE.md file in the package.
--]]

local ffi = require("ffi")

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
BLLinearGradientValues = ffi.typeof("struct BLLinearGradientValues")

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
  //! Union of either raw `stops` & `size` members or their `view`.
  union {
    struct {
      //! Gradient stop data.
      BLGradientStop* stops;
      //! Gradient stop count.
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
BLGradientCore = ffi.typeof("struct BLGradientCore")
ffi.metatype(BLGradientCore, {
    __gc = function(self)
        return blapi.blGradientReset(self);
    end;

    __new = function(ct, ...)
        local obj = ffi.new(ct);

        if select('#', ...) == 0 then
            local bResult = blapi.blGradientInit(obj) ;
        else
            local bResult = blapi.blGradientInitAs(obj, select(1,...), select(2,...), select(3,...), select(4,...), select(5,...), select(6,...)) ;
        end

        return obj;
    end;

    __index = {
        addStopRgba32 = function(self, offset, argb32)
            return blapi.blGradientAddStopRgba32(self, offset, argb32);
        end;
    };
})


end -- BLEND2D_BLGRADIENT_H
