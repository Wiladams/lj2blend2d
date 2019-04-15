--[[
// [Blend2D]
// 2D Vector Graphics Powered by a JIT Compiler.
//
// [License]
// ZLIB - See LICENSE.md file in the package.
--]]

local ffi = require("ffi")
local C = ffi.C 

if not BLEND2D_BLPATH_H then
BLEND2D_BLPATH_H = true

local blapi = require("blend2d.blapi")

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

  BL_STROKE_JOIN_MITER_CLIP = 0,
  BL_STROKE_JOIN_MITER_BEVEL = 1,
  BL_STROKE_JOIN_MITER_ROUND = 2,
  BL_STROKE_JOIN_BEVEL = 3,
  BL_STROKE_JOIN_ROUND = 4,

  BL_STROKE_JOIN_COUNT = 5
};

//! Position of a stroke-cap.
enum  BLStrokeCapPosition  {
  BL_STROKE_CAP_POSITION_START = 0,
  BL_STROKE_CAP_POSITION_END = 1,

  BL_STROKE_CAP_POSITION_COUNT = 2
};

//! A presentation attribute defining the shape to be used at the end of open subpaths.
enum  BLStrokeCap  {

  BL_STROKE_CAP_BUTT = 0,

  BL_STROKE_CAP_SQUARE = 1,

  BL_STROKE_CAP_ROUND = 2,

  BL_STROKE_CAP_ROUND_REV = 3,

  BL_STROKE_CAP_TRIANGLE = 4,

  BL_STROKE_CAP_TRIANGLE_REV = 5,


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
  union { BLArrayCore dashArray;};
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
      uint8_t* commandData;
      BLPoint* vertexData;
      size_t size;
    };

    BLPathView view;
  };


   size_t refCount;
  uint8_t implType;
  uint8_t implTraits;
  uint16_t memPoolData;

   uint32_t flags;
  size_t capacity;
};

//! 2D vector path [C Interface - Core].
struct BLPathCore {
  BLPathImpl* impl;
};
]]
BLPathCore = ffi.typeof("struct BLPathCore")
BLPath = BLPathCore

local pathCommands = {

getSize = blapi.blPathGetSize ;
getCapacity = blapi.blPathGetCapacity ;
getCommandData = blapi.blPathGetCommandData ;
getVertexData = blapi.blPathGetVertexdData ;
clear = blapi.blPathClear ;
shrink = blapi.blPathShrink ;
reserve = blapi.blPathReserve ;
modifyOp = blapi.blPathModifyOp  ;
assignMove = blapi.blPathAssignMove  ;
addignWeak = blapi.blPathAssignWeak  ;
assignDeep = blapi.blPathAssignDeep  ;
setVertexAt = blapi.blPathSetVertexAt  ;
moveTo = blapi.blPathMoveTo  ;
lineTo = blapi.blPathLineTo  ;
polyTo = blapi.blPathPolyTo  ;
quadTo = blapi.blPathQuadTo  ;
cubicTo = blapi.blPathCubicTo  ;
smoothQuadTo = blapi.blPathSmoothQuadTo  ;
smoothCubicTo = blapi.blPathSmoothCubicTo  ;
arcTo = blapi.blPathArcTo  ;
arcQuadrantTo = blapi.blPathArcQuadrantTo  ;
ellipticArcTo = blapi.blPathEllipticArcTo  ;
close = blapi.blPathClose ;
addGeometry = blapi.blPathAddGeometry  ;
addBoxI = blapi.blPathAddBoxI  ;
addBoxD = blapi.blPathAddBoxD  ;
addRectI = blapi.blPathAddRectI  ;
addRectD = blapi.blPathAddRectD  ;
addPath = blapi.blPathAddPath  ;
addTranslatedPath = blapi.blPathAddTranslatedPath  ;
addTransformedPath = blapi.blPathAddTransformedPath  ;
addReversedPath = blapi.blPathAddReversedPath  ;
strokePath = blapi.blPathAddStrokedPath ;
translate = blapi.blPathTranslate  ;
transform = blapi.blPathTransform  ;
fitTo = blapi.blPathFitTo  ;
equals = blapi.blPathEquals ;
getInfoFlags = blapi.blPathGetInfoFlags ;
getControlBox = blapi.blPathGetControlBox ;
getBoundingBox = blapi.blPathGetBoundingBox ;
getFigureRange = blapi.blPathGetFigureRange ;
getLastVertex = blapi.blPathGetLastVertex ;
getClosestVertex = blapi.blPathGetClosestVertex ;
pathHitTest = blapi.blPathHitTest ;
}
local BLPathCore_mt = {
    __gc = function(self)
        local bResult = blapi.blPathReset(self);
        return bResult == C.BL_SUCCESS or bResult
    end;

    __new = function(ct, ...)
        local obj = ffi.new(ct);
        local bResult = blapi.blPathInit(obj);
        if bResult ~= C.BL_SUCCESS then
          return false, "error with blPathInit: "..tostring(bResult)
        end

        return obj;
    end;

    __index = function(self, key)
        --print("Path.__index: ", self, key)
        return pathCommands[key]
    end;
}
ffi.metatype(BLPathCore, BLPathCore_mt)


end -- BLEND2D_BLPATH_H
