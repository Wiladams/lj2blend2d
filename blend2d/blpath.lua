local ffi = require("ffi")
local C = ffi.C 
local bit = require("bit")
local bor, band = bit.bor, bit.band

local min, max = math.min, math.max

local blapi = require("blend2d.blend2d_ffi")

--[[
    BLPath
]]

BLPath = ffi.typeof("struct BLPathCore")

local pathCommands = {
  assignMove = blapi.blPathAssignMove  ;
  addignWeak = blapi.blPathAssignWeak  ;
  assignDeep = blapi.blPathAssignDeep  ;
  equals = blapi.blPathEquals ;

  -- meta commands
  clear = blapi.blPathClear;
  close = blapi.blPathClose ;
  fitTo = blapi.blPathFitTo  ;
  shrink = blapi.blPathShrink ;
  reserve = blapi.blPathReserve ;
  modifyOp = blapi.blPathModifyOp  ;
  setVertexAt = blapi.blPathSetVertexAt  ;
  translate = blapi.blPathTranslate  ;
  transform = blapi.blPathTransform  ;
  pathHitTest = blapi.blPathHitTest ;

  -- Getting stuff
getSize = blapi.blPathGetSize ;
getCapacity = blapi.blPathGetCapacity ;
getCommandData = blapi.blPathGetCommandData ;
getVertexData = blapi.blPathGetVertexData ;
getInfoFlags = blapi.blPathGetInfoFlags ;
getControlBox = blapi.blPathGetControlBox ;
getBoundingBox = blapi.blPathGetBoundingBox ;
getFigureRange = blapi.blPathGetFigureRange ;
getLastVertex = blapi.blPathGetLastVertex ;
getClosestVertex = blapi.blPathGetClosestVertex ;

  -- extending path
arcTo = blapi.blPathArcTo  ;
arcQuadrantTo = blapi.blPathArcQuadrantTo  ;
cubicTo = blapi.blPathCubicTo  ;
ellipticArcTo = blapi.blPathEllipticArcTo  ;
moveTo = blapi.blPathMoveTo  ;
lineTo = blapi.blPathLineTo  ;
polyTo = blapi.blPathPolyTo  ;
quadTo = blapi.blPathQuadTo  ;
smoothQuadTo = blapi.blPathSmoothQuadTo  ;
smoothCubicTo = blapi.blPathSmoothCubicTo  ;

addGeometry = blapi.blPathAddGeometry  ;
addBoxI = blapi.blPathAddBoxI  ;
addBoxD = blapi.blPathAddBoxD  ;
addRectI = blapi.blPathAddRectI  ;
addRectD = blapi.blPathAddRectD  ;
addPath = blapi.blPathAddPath  ;
addTranslatedPath = blapi.blPathAddTranslatedPath  ;
addTransformedPath = blapi.blPathAddTransformedPath  ;
addReversedPath = blapi.blPathAddReversedPath  ;

addStrokedPath = blapi.blPathAddStrokedPath ;
}

-- return the last vertex in the current path
function pathCommands.currentPoint(self)
    local n = self:getSize()
    if n < 1 then
      return 0,0
    end
    
    local vtxOut = BLPoint()
    self:getLastVertex(vtxOut)

    return vtxOut.x, vtxOut.y
end

function pathCommands.rlineTo(self, dx, dy)
    local x, y = self:currentPoint()
    x = x + dx;
    y = y + dy;

    self:lineTo(x, y)
end

function pathCommands.rmoveTo(self, dx, dy)
  local x, y = self:currentPoint()
  x = x + dx;
  y = y + dy;

  self:moveTo(x, y)
end

local BLPath_mt = {
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
        local pcmd = pathCommands[key]
        --print("Path.__index: ", self, key, pcmd)

        return pcmd
    end;
}
ffi.metatype(BLPath, BLPath_mt)

return BLPath