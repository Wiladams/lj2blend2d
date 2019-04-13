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

require("blend2d.blgeometry")
require("blend2d.blmatrix")
require("blend2d.blrgba")
require("blend2d.blvariant")

ffi.cdef[[
//! Gradient type.
enum BLGradientType {
  //! Linear gradient type.
  BL_GRADIENT_TYPE_LINEAR = 0,
  //! Radial gradient type.
  BL_GRADIENT_TYPE_RADIAL = 1,
  //! Conical gradient type.
  BL_GRADIENT_TYPE_CONICAL = 2,

  //! Count of gradient types.
  BL_GRADIENT_TYPE_COUNT = 3
};

//! Gradient data index.
enum BLGradientValue {
  //! x0 - start 'x' for Linear/Radial and center 'x' for Conical.
  BL_GRADIENT_VALUE_COMMON_X0 = 0,
  //! y0 - start 'y' for Linear/Radial and center 'y' for Conical.
  BL_GRADIENT_VALUE_COMMON_Y0 = 1,
  //! x1 - end 'x' for Linear/Radial.
  BL_GRADIENT_VALUE_COMMON_X1 = 2,
  //! y1 - end 'y' for Linear/Radial.
  BL_GRADIENT_VALUE_COMMON_Y1 = 3,
  //! Radial gradient r0 radius.
  BL_GRADIENT_VALUE_RADIAL_R0 = 4,
  //! Conical gradient angle.
  BL_GRADIENT_VALUE_CONICAL_ANGLE = 2,

  //! Count of gradient values.
  BL_GRADIENT_VALUE_COUNT = 6
};
]]

ffi.cdef[[
// ============================================================================
// [BLGradientStop]
// ============================================================================

//! Defines an `offset` and `rgba` color that us used by `BLGradient` to define
//! a linear transition between colors.
struct BLGradientStop {
  double offset;
  BLRgba64 rgba;
};
]]


ffi.cdef[[
// ============================================================================
// [BLLinearGradientValues]
// ============================================================================

//! Linear gradient values packed into a structure.
struct BLLinearGradientValues {
  double x0;
  double y0;
  double x1;
  double y1;
};
]]


ffi.cdef[[
// ============================================================================
// [BLRadialGradientValues]
// ============================================================================

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
// ============================================================================
// [BLConicalGradientValues]
// ============================================================================

//! Conical gradient values packed into a structure.
struct BLConicalGradientValues {
  double x0;
  double y0;
  double angle;
};
]]


ffi.cdef[[
// ============================================================================
// [BLGradient - Core]
// ============================================================================

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

  //! Stop capacity.
  size_t capacity;

  //! Reference count.
  volatile size_t refCount;
  //! Impl type.
  uint8_t implType;
  //! Impl traits.
  uint8_t implTraits;
  //! Memory pool data.
  uint16_t memPoolData;

  //! Gradient type, see `BLGradientType`.
  uint8_t gradientType;
  //! Gradient extend mode, see `BLExtendMode`.
  uint8_t extendMode;
  //! Type of the transformation matrix.
  uint8_t matrixType;
  //! Reserved, must be zero.
  uint8_t reserved[1];

  //! Gradient transformation matrix.
  BLMatrix2D matrix;

  union {
    //! Gradient values (coordinates, radius, angle).
    double values[BL_GRADIENT_VALUE_COUNT];
    //! Linear parameters.
    BLLinearGradientValues linear;
    //! Radial parameters.
    BLRadialGradientValues radial;
    //! Conical parameters.
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

end -- BLEND2D_BLGRADIENT_H
