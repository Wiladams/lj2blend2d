--[[
// [Blend2D]
// 2D Vector Graphics Powered by a JIT Compiler.
//
// [License]
// ZLIB - See LICENSE.md file in the package.
--]]

local ffi = require("ffi")

if not BLEND2D_BLMATRIX_H then
BLEND2D_BLMATRIX_H = true

require("blend2d.blgeometry")

ffi.cdef[[
typedef BLResult (__cdecl * BLMapPointDArrayFunc)(const void* ctx, BLPoint* dst, const BLPoint* src, size_t count);
]]

ffi.cdef[[
enum BLMatrix2DType {
  //! Identity matrix.
  BL_MATRIX2D_TYPE_IDENTITY = 0,
  //! Has translation part (the rest is like identity).
  BL_MATRIX2D_TYPE_TRANSLATE = 1,
  //! Has translation and scaling parts.
  BL_MATRIX2D_TYPE_SCALE = 2,
  //! Has translation and scaling parts, however scaling swaps X/Y.
  BL_MATRIX2D_TYPE_SWAP = 3,
  //! Generic affine matrix.
  BL_MATRIX2D_TYPE_AFFINE = 4,
  //! Invalid/degenerate matrix not useful for transformations.
  BL_MATRIX2D_TYPE_INVALID = 5,

  //! Count of matrix types.
  BL_MATRIX2D_TYPE_COUNT = 6
};
]]

ffi.cdef[[
//! 2D matrix data index.
enum BLMatrix2DValue {
  BL_MATRIX2D_VALUE_00 = 0,
  BL_MATRIX2D_VALUE_01 = 1,
  BL_MATRIX2D_VALUE_10 = 2,
  BL_MATRIX2D_VALUE_11 = 3,
  BL_MATRIX2D_VALUE_20 = 4,
  BL_MATRIX2D_VALUE_21 = 5,

  BL_MATRIX2D_VALUE_COUNT = 6
};
]]

ffi.cdef[[
//! 2D matrix operation.
enum BLMatrix2DOp {
  //! Reset matrix to identity (argument ignored, should be nullptr).
  BL_MATRIX2D_OP_RESET = 0,
  //! Assign (copy) the other matrix.
  BL_MATRIX2D_OP_ASSIGN = 1,

  //! Translate the matrix by [x, y].
  BL_MATRIX2D_OP_TRANSLATE = 2,
  //! Scale the matrix by [x, y].
  BL_MATRIX2D_OP_SCALE = 3,
  //! Skew the matrix by [x, y].
  BL_MATRIX2D_OP_SKEW = 4,
  //! Rotate the matrix by the given angle about [0, 0].
  BL_MATRIX2D_OP_ROTATE = 5,
  //! Rotate the matrix by the given angle about [x, y].
  BL_MATRIX2D_OP_ROTATE_PT = 6,
  //! Transform this matrix by other `BLMatrix2D`.
  BL_MATRIX2D_OP_TRANSFORM = 7,

  //! Post-translate the matrix by [x, y].
  BL_MATRIX2D_OP_POST_TRANSLATE = 8,
  //! Post-scale the matrix by [x, y].
  BL_MATRIX2D_OP_POST_SCALE = 9,
  //! Post-skew the matrix by [x, y].
  BL_MATRIX2D_OP_POST_SKEW = 10,
  //! Post-rotate the matrix about [0, 0].
  BL_MATRIX2D_OP_POST_ROTATE = 11,
  //! Post-rotate the matrix about a reference BLPoint.
  BL_MATRIX2D_OP_POST_ROTATE_PT = 12,
  //! Post-transform this matrix by other `BLMatrix2D`.
  BL_MATRIX2D_OP_POST_TRANSFORM = 13,

  //! Count of matrix operations.
  BL_MATRIX2D_OP_COUNT = 14
};
]]


ffi.cdef[[
// ============================================================================
// [BLMatrix2D]
// ============================================================================

//! 2D matrix represents an affine transformation matrix that can be used to
//! transform geometry and images.
struct BLMatrix2D {
  union {
    //! Matrix values, use `BL_MATRIX2D_VALUE` indexes to get a particular one.
    double m[BL_MATRIX2D_VALUE_COUNT];
    //! Matrix values that map `m` to named values that can be used directly.
    struct {
      double m00;
      double m01;
      double m10;
      double m11;
      double m20;
      double m21;
    };
  };
};
]]

--[[
//! Array of functions for transforming points indexed by `BLMatrixType`. Each
//! function is optimized for the respective type. This is mostly used internally,
//! but exported for users that can take advantage of Blend2D SIMD optimziations.
BL_API_C BLMapPointDArrayFunc blMatrix2DMapPointDArrayFuncs[BL_MATRIX2D_TYPE_COUNT];
--]]

end -- BLEND2D_BLMATRIX_H
