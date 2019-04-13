--[[
// [Blend2D]
// 2D Vector Graphics Powered by a JIT Compiler.
//
// [License]
// ZLIB - See LICENSE.md file in the package.
--]]

local ffi = require("ffi")

if not BLEND2D_BLPATH_H then
BLEND2D_BLPATH_H = true

require("blend2d.blarray")
require("blend2d.blgeometry")
require("blend2d.blvariant")

ffi.cdef[[
//! Path command.
enum  BLPathCmd  {
  //! Move-to command (starts a new figure).
  BL_PATH_CMD_MOVE = 0,
  //! On-path command (interpreted as line-to or the end of a curve).
  BL_PATH_CMD_ON = 1,
  //! Quad-to control point.
  BL_PATH_CMD_QUAD = 2,
  //! Cubic-to control point (always used as a pair of commands).
  BL_PATH_CMD_CUBIC = 3,
  //! Close path.
  BL_PATH_CMD_CLOSE = 4,

  //! Count of path commands.
  BL_PATH_CMD_COUNT = 5
};

//! Path command (never stored in path).
enum  BLPathCmdExtra  {
  //! Used by `BLPath::setVertexAt` to preserve the current command value.
  BL_PATH_CMD_PRESERVE = 0xFFFFFFFFu
};

//! Path flags.
enum  BLPathFlags  {
  //! Path is empty (no commands or close commands only).
  BL_PATH_FLAG_EMPTY = 0x00000001u,
  //! Path contains multiple figures.
  BL_PATH_FLAG_MULTIPLE = 0x00000002u,
  //! Path contains quad curves (at least one).
  BL_PATH_FLAG_QUADS = 0x00000004u,
  //! Path contains cubic curves (at least one).
  BL_PATH_FLAG_CUBICS = 0x00000008u,
  //! Path is invalid.
  BL_PATH_FLAG_INVALID = 0x40000000u,
  //! Flags are dirty (not reflecting the current status).
  BL_PATH_FLAG_DIRTY = 0x80000000u
};

//! Path reversal mode.
enum  BLPathReverseMode  {
  //! Reverse each figure and their order as well (default).
  BL_PATH_REVERSE_MODE_COMPLETE = 0,
  //! Reverse each figure separately (keeps their order).
  BL_PATH_REVERSE_MODE_SEPARATE = 1,

  //! Count of path-reversal modes
  BL_PATH_REVERSE_MODE_COUNT = 2
};

//! Stroke join type.
enum  BLStrokeJoin  {
  //! Miter-join possibly clipped at `miterLimit` [default].
  BL_STROKE_JOIN_MITER_CLIP = 0,
  //! Miter-join or bevel-join depending on miterLimit condition.
  BL_STROKE_JOIN_MITER_BEVEL = 1,
  //! Miter-join or round-join depending on miterLimit condition.
  BL_STROKE_JOIN_MITER_ROUND = 2,
  //! Bevel-join.
  BL_STROKE_JOIN_BEVEL = 3,
  //! Round-join.
  BL_STROKE_JOIN_ROUND = 4,

  //! Count of stroke join types.
  BL_STROKE_JOIN_COUNT = 5
};

//! Position of a stroke-cap.
enum  BLStrokeCapPosition  {
  //! Start of the path.
  BL_STROKE_CAP_POSITION_START = 0,
  //! End of the path.
  BL_STROKE_CAP_POSITION_END = 1,

  //! Count of stroke position options.
  BL_STROKE_CAP_POSITION_COUNT = 2
};

//! A presentation attribute defining the shape to be used at the end of open subpaths.
enum  BLStrokeCap  {
  //! Butt cap [default].
  BL_STROKE_CAP_BUTT = 0,
  //! Square cap.
  BL_STROKE_CAP_SQUARE = 1,
  //! Round cap.
  BL_STROKE_CAP_ROUND = 2,
  //! Round cap reversed.
  BL_STROKE_CAP_ROUND_REV = 3,
  //! Triangle cap.
  BL_STROKE_CAP_TRIANGLE = 4,
  //! Triangle cap reversed.
  BL_STROKE_CAP_TRIANGLE_REV = 5,

  //! Used to catch invalid arguments.
  BL_STROKE_CAP_COUNT = 6
};

//! Stroke transform order.
enum  BLStrokeTransformOrder  {
  //! Transform after stroke  => `Transform(Stroke(Input))` [default].
  BL_STROKE_TRANSFORM_ORDER_AFTER = 0,
  //! Transform before stroke => `Stroke(Transform(Input))`.
  BL_STROKE_TRANSFORM_ORDER_BEFORE = 1,

  //! Count of transform order types.
  BL_STROKE_TRANSFORM_ORDER_COUNT = 2
};

//! Mode that specifies how curves are approximated to line segments.
enum  BLFlattenMode  {
  //! Use default mode (decided by Blend2D).
  BL_FLATTEN_MODE_DEFAULT = 0,
  //! Recursive subdivision flattening.
  BL_FLATTEN_MODE_RECURSIVE = 1,

  //! Count of flatten modes.
  BL_FLATTEN_MODE_COUNT = 2
};

//! Mode that specifies how to construct offset curves.
enum  BLOffsetMode  {
  //! Use default mode (decided by Blend2D).
  BL_OFFSET_MODE_DEFAULT = 0,
  //! Iterative offset construction.
  BL_OFFSET_MODE_ITERATIVE = 1,

  //! Count of offset modes.
  BL_OFFSET_MODE_COUNT = 2
};
]]

ffi.cdef[[
// ============================================================================
// [BLApproximationOptions]
// ============================================================================

struct BLApproximationOptions {
  //! Specifies how curves are flattened, see `BLFlattenMode`.
  uint8_t flattenMode;
  //! Specifies how curves are offsetted (used by stroking), see `BLOffsetMode`.
  uint8_t offsetMode;
  //! Reserved for future use, must be zero.
  uint8_t reservedFlags[6];

  //! Tolerance used to flatten curves.
  double flattenTolerance;
  //! Tolerance used to approximatecubic curves qith quadratic curves.
  double simplifyTolerance;
  //! Curve offsetting parameter, exact meaning depends on `offsetMode`.
  double offsetParameter;
};
]]

--//! Default approximation options used by Blend2D.
--BL_API_C const BLApproximationOptions blDefaultApproximationOptions;

ffi.cdef[[
struct BLStrokeOptionsCore {
  union {
    struct {
      uint8_t startCap;
      uint8_t endCap;
      uint8_t join;
      uint8_t transformOrder;
      uint8_t reserved[4];
    };
    uint8_t caps[BL_STROKE_CAP_POSITION_COUNT];
    uint64_t hints;
  };

  double width;
  double miterLimit;
  double dashOffset;
  //BL_TYPED_MEMBER(BLArrayCore, BLArray<double>, dashArray);
  // BUGBUG union { BLArray<double> dashArray};
};
]]

ffi.cdef[[
//! 2D path view provides pointers to vertex and command data along with their
//! size.
struct BLPathView {
  const uint8_t* commandData;
  const BLPoint* vertexData;
  size_t size;
};
]]

ffi.cdef[[
//! 2D vector path [C Interface - Impl].
struct BLPathImpl {
  //! Union of either raw path-data or their `view`.
  union {
    struct {
      //! Command data
      uint8_t* commandData;
      //! Vertex data.
      BLPoint* vertexData;
      //! Vertex/command count.
      size_t size;
    };
    //! Path data as view.
    BLPathView view;
  };

  //! Reference count.
   size_t refCount;
  //! Impl type.
  uint8_t implType;
  //! Impl traits.
  uint8_t implTraits;
  //! Memory pool data.
  uint16_t memPoolData;

  //! Path flags related to caching.
   uint32_t flags;
  //! Path vertex/command capacity.
  size_t capacity;
};

//! 2D vector path [C Interface - Core].
struct BLPathCore {
  BLPathImpl* impl;
};
]]

end -- BLEND2D_BLPATH_H
