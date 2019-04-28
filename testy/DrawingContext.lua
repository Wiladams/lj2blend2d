--[[
    DrawingContext

    This object represents a convenient drawing API that connects Lua to 
    Blend2D.  As such, it encapsulates a BLContext, but is NOT a BLContext.

    This allows the context to take on Lua semantics, such as attaching more
    state to the context if desired.

    The intention is to not use the metatype connected to the BLContext itself
    and just rely on this simplified interface instead.

    Some features:
    Enums are encapsulated in DrawingContext
    Where there are multiple forms of interfaces (int and double) double will be favored

--]]

local ffi = require("ffi")
local C = ffi.C 


local blapi = require("blend2d.blapi")

require("blend2d.blfont");
require("blend2d.blgeometry");
require("blend2d.blimage");
require("blend2d.blmatrix");
require("blend2d.blpath");
require("blend2d.blrgba");
require("blend2d.blregion");
require("blend2d.blvariant");
require("blend2d.blcontext")
local enum = require("blend2d.enum")



local DrawingContext = {

    -- Rendering context type.
    BLContextType = enum {
        [0] = "BL_CONTEXT_TYPE_NONE",
        "BL_CONTEXT_TYPE_DUMMY",
        "BL_CONTEXT_TYPE_RASTER",
        "BL_CONTEXT_TYPE_RASTER_ASYNC",

        --[4] = "BL_CONTEXT_TYPE_COUNT"
    };

    -- Rendering context hint.
    BLContextHint = enum {
        [0] = "BL_CONTEXT_HINT_RENDERING_QUALITY" = 0,
        [1] = "BL_CONTEXT_HINT_GRADIENT_QUALITY" = 1,
        [2] = "BL_CONTEXT_HINT_PATTERN_QUALITY" = 2,

        --[8] = "BL_CONTEXT_HINT_COUNT" = 8
    };

    -- Describes a rendering operation type - fill or stroke.
    BLContextOpType = enum {
        [0] = "BL_CONTEXT_OP_TYPE_FILL",
        [1] = "BL_CONTEXT_OP_TYPE_STROKE",

        --[2] = "BL_CONTEXT_OP_TYPE_COUNT"
    };

    -- Rendering context flush-flags, use with `BLContext::flush()`.
    BLContextFlushFlags = enum {
        [0x80000000] = "BL_CONTEXT_FLUSH_SYNC"
    };


    BLContextCreateFlags = enum {
        [0x10000000] = "BL_CONTEXT_CREATE_FLAG_ISOLATED_RUNTIME",
        [0x20000000] = "BL_CONTEXT_CREATE_FLAG_OVERRIDE_FEATURES"
    };

    -- Clip operation.
    BLClipOp = enum {
        [0] = "BL_CLIP_OP_REPLACE",
        [1] = "BL_CLIP_OP_INTERSECT",

        --[2] = BL_CLIP_OP_COUNT"
    };

    -- Clip mode.
    BLClipMode = enum {
        [0] = "BL_CLIP_MODE_ALIGNED_RECT";
        "BL_CLIP_MODE_UNALIGNED_RECT" = 1;
        "BL_CLIP_MODE_MASK" = 2;

        --BL_CLIP_MODE_COUNT = 3
    };

    -- Composition & blending operator.
    BLCompOp = enum {
        [0] = "BL_COMP_OP_SRC_OVER";
        "BL_COMP_OP_SRC_COPY";
        "BL_COMP_OP_SRC_IN";
        "BL_COMP_OP_SRC_OUT";
        "BL_COMP_OP_SRC_ATOP";
        "BL_COMP_OP_DST_OVER";
        "BL_COMP_OP_DST_COPY";
        "BL_COMP_OP_DST_IN";
        "BL_COMP_OP_DST_OUT";
        "BL_COMP_OP_DST_ATOP";
        "BL_COMP_OP_XOR";
        "BL_COMP_OP_CLEAR";
        "BL_COMP_OP_PLUS";
        "BL_COMP_OP_MINUS";
        "BL_COMP_OP_MULTIPLY";
        "BL_COMP_OP_SCREEN";
        "BL_COMP_OP_OVERLAY";
        "BL_COMP_OP_DARKEN";
        "BL_COMP_OP_LIGHTEN";
        "BL_COMP_OP_COLOR_DODGE";
        "BL_COMP_OP_COLOR_BURN";
        "BL_COMP_OP_LINEAR_BURN";
        "BL_COMP_OP_LINEAR_LIGHT";
        "BL_COMP_OP_PIN_LIGHT";
        "BL_COMP_OP_HARD_LIGHT";
        "BL_COMP_OP_SOFT_LIGHT";
        "BL_COMP_OP_DIFFERENCE";
        "BL_COMP_OP_EXCLUSION";

        --"BL_COMP_OP_COUNT"
    };

    -- Gradient rendering quality.
    BLGradientQuality = enum {
        [0] = "BL_GRADIENT_QUALITY_NEAREST",
        [1] = "BL_GRADIENT_QUALITY_COUNT"
    };

    -- Pattern quality.
    BLPatternQuality = enum {
        [0] = "BL_PATTERN_QUALITY_NEAREST",
        [1] = "BL_PATTERN_QUALITY_BILINEAR",
    
        --"BL_PATTERN_QUALITY_COUNT"
    };

    -- Rendering quality.
    BLRenderingQuality = enum {
        [0] = "BL_RENDERING_QUALITY_ANTIALIAS",
        "BL_RENDERING_QUALITY_COUNT"
    };
}
setmetatable(DrawingContext, {
    __call (self, ...)
        return self:new(...)
    end
})

function DrawingContext.new(self, w, h)
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self;

    obj.DC = obj.DC or ffi.new("struct BLContextCore")
    obj.Image = obj.Image or BLImage(w, h)
    local bResult = blapi.blContextInitAs(obj.DC, obj.Image, nil)
    if bResult ~= C.BL_SUCCESS then
      return nil, bResult;
    end

    return obj;
end

function DrawingContext.clip(self, x, y, w, y)
    local bResult = blapi.blContextClipToRectI(self.DC, BLRectI(x,y,w,h)) ;
    if bResult ~= C.BL_SUCCESS then
        return nil, bResult;
    end

    return self;
end

function DrawingContext.removeClip(self)
    local bResult = blapi.blContextRestoreClipping(self.DC) ;
    
    if bResult ~= C.BL_SUCCESS then
        return nil, bResult;
    end

    return self;
end


function DrawingContext.finish (self)
    local bResult = blapi.blContextEnd(self.DC);
    
    if bResult == C.BL_SUCCESS then
        return self;
    end
    
    return false, bResult
end

function DrawingContext.flush (self, flags)
    flags = flags or C.BL_CONTEXT_FLUSH_SYNC;

    local bResult = self.DC.impl.virt.flush(self.DC.impl, flags);
    if bResult == C.BL_SUCCESS then
        return self;
    end

    return false, bResult
end

function DrawingContext.save (self, cookie)
    local bResult = self.DC.impl.virt.save(self.DC.impl, cookie);
    if bResult == C.BL_SUCCESS then
        return self;
    end

    return false, bResult
end
      
function DrawingContext.restore (self, cookie)
    local bResult = self.DC.impl.virt.restore(self.DC.impl, cookie);
    if bResult == C.BL_SUCCESS then
        return self;
    end

    return false, bResult
end

-- Applies a matrix operation to the current transformation matrix (internal).
local function _applyMatrixOp (self, opType, opData)
    local bResult = self.DC.impl.virt.matrixOp(self.DC.impl, opType, opData);
    if bResult == C.BL_SUCCESS then
        return self;
    end

    return false, bResult
end
      
local function _applyMatrixOpV(self, opType, ...)
        local opData = ffi.new("double[?]",select('#',...), {...});
        local bResult = self.DC.impl.virt.matrixOp(self.DC.impl, opType, opData);
        if bResult == C.BL_SUCCESS then
            return self;
        end

        return false, bResult
end

      -- overloaded rotate
      -- 1 value - an angle (in radians)
      -- 3 values - an angle, and a point to rotate around
function DrawingContext.rotateAroundPoint(self, rads, x, y)
    return _applyMatrixOpV(self.DC, C.BL_MATRIX2D_OP_ROTATE_PT,rads, x, y);
end

function DrawingContext.rotate (self, rads)
    return self:rotateAroundPoint(rads, 0,0)
end

function DrawingContext.translate (self, x, y)
    return _applyMatrixOpV(self.DC, C.BL_MATRIX2D_OP_TRANSLATE, x, y);
end

function DrawingContext.scale(self, ...)
          local nargs = select('#',...)
          --print("nargs: ", nargs)
          local x, y = 1, 1;
          if nargs == 1 then
              if typeof(select(1,...) == "number") then
                  x = select(1,...)
                  y = x;
                  --print("blcontext.scale: ", x, y)
                  return _applyMatrixOpV(self.DC, C.BL_MATRIX2D_OP_SCALE, x, y)
              end
          elseif nargs == 2 then
              x = select(1,...)
              y = select(2,...)

              if x and y then
                  return _applyMatrixOpV(self.DC, C.BL_MATRIX2D_OP_SCALE, x, y)
              end
          end 
          
          return false, "invalid arguments"
end

      
function DrawingContext.setCompOp (self, compOp)
    --print("setCompOp: ", self, compOp)
    local bResult = blapi.blContextSetCompOp(self.DC, compOp);
    
    if bResult == C.BL_SUCCESS then
        return self;
    end

    return false, bResult
end
    
function DrawingContext.setFillStyle (self, obj)
        if ffi.typeof(obj) == BLRgba32 then
            return self:setFillStyleRgba32(obj.value)
    end

    local bResult = blapi.blContextSetFillStyle(self.DC, obj);
    
    if bResult == C.BL_SUCCESS then
        return self;
    end

    return false, bResult
end
    
function DrawingContext.setFillStyleRgba32 (self, rgba32)
        local bResult = blapi.blContextSetFillStyleRgba32(self.DC, rgba32);
        
        if bResult == C.BL_SUCCESS then
            return self;
        end
    
        return false, bResult
end


--[[
        Actual Drawing
]]
function DrawingContext.blit (self, img, pt)
    local bResult = blapi.blContextBlitImageD(self.DC, const BLPoint* pt, const BLImageCore* img, const BLRectI* imgArea) ;
    
    if bResult == C.BL_SUCCESS then
        return self;
    end

    return false, bResult
end

function DrawingContext.stretchBlt (self, dstRect, img, imgArea)
    local bResult = blapi.blContextBlitScaledImageD(self.DC, dstRect, img, imgArea) ;

    if bResult == C.BL_SUCCESS then
        return self;
    end

    return false, bResult
end

function DrawingContext.setStrokeStartCap (self, strokeCap)
        local bResult = blapi.blContextSetStrokeCap(self.DC, C.BL_STROKE_CAP_POSITION_START, strokeCap) ;

    if bResult == C.BL_SUCCESS then
        return self;
    end
    
    return false, bResult
end

function DrawingContext.setStrokeEndCap (self, strokeCap)
    local bResult = blapi.blContextSetStrokeCap(self.DC, C.BL_STROKE_CAP_POSITION_END, strokeCap) ;
    
    if bResult == C.BL_SUCCESS then
        return self;
    end

    return false, bResult
end

-- joinKind == BLStrokeJoin
function DrawingContext.setStrokeJoin (self, joinKind)
    local bResult = blapi.blContextSetStrokeJoin(self.DC, joinKind) ;
    
    if bResult == C.BL_SUCCESS then
        return self;
    end

    return false, bResult
end

function DrawingContext.setStrokeStyleRgba32 (self, rgba32)
    local bResult = blapi.blContextSetStrokeStyleRgba32(self.DC, rgba32);

    if bResult == C.BL_SUCCESS then
            return self;
    end
        
    return false, bResult
end

function DrawingContext.setStrokeStyle (self, obj)
    if ffi.typeof(obj) == BLRgba32 then
            local bResult = blapi.blContextSetStrokeStyleRgba32(self.DC, obj.value);
            if bResult == C.BL_SUCCESS then
                return self;
            end

            return false, bResult
    end

    local bResult = blapi.blContextSetStrokeStyle(self.DC, obj) ;
    
    if bResult == C.BL_SUCCESS then
        return self;
    end
    
    return false, bResult
end

function DrawingContext.setStrokeWidth (self, width)
    local bResult = blapi.blContextSetStrokeWidth(self.DC, width) ;
    
    if bResult == C.BL_SUCCESS then
        return self;
    end

    return false, bResult
end

-- Whole canvas drawing functions
function DrawingContext.clear (self)
    local bResult = self.DC.impl.virt.clearAll(self.DC.impl)

    if bResult == C.BL_SUCCESS then
        return self;
    end

    return false, bResult
end

function DrawingContext.fillAll (self)
    local bResult = self.DC.impl.virt.fillAll(self.DC.impl);
    
    if bResult == C.BL_SUCCESS then
        return self;
    end

    return false, bResult
end

-- Geometry drawing functions
function DrawingContext.fillGeometry (self, geometryType, geometryData)
    local bResult = self.DC.impl.virt.fillGeometry(self.DC.impl, geometryType, geometryData);
    
    if bResult == C.BL_SUCCESS then
        return self;
    end

    return false, bResult
end


function DrawingContext.fillCircle (self, ...)
    local nargs = select('#', ...)
    if nargs == 1 then
        local circle = select(1,...)
        return self:fillGeometry(C.BL_GEOMETRY_TYPE_CIRCLE, circle);
    elseif nargs == 3 then
        local cx = select(1,...)
        local cy = select(2,...)
        local r = select(3,...)
        local circle = BLCircle(cx, cy, r)
        return self:fillGeometry(C.BL_GEOMETRY_TYPE_CIRCLE, circle)
    end
end


function DrawingContext.fillEllipse (self, ...)
    local nargs = select("#",...)
    if nargs == 4 then
        local geo = BLEllipse(...)
            --print("fillEllipse: ", geo.cx, geo.cy, geo.rx, geo.ry)
        retyrn self:fillGeometry(C.BL_GEOMETRY_TYPE_ELLIPSE, geo)
    end
end

function DrawingContext.fillPath (self, path)
    local bReasult = blapi.blContextFillPathD(self.DC, path) ;
    if bResult == C.BL_SUCCESS then
        return self;
    end

    return false, bResult
end

function DrawingContext.fillPolygon (self, pts)
    --print("fillPolygon: ", pts)
    if type(pts) == "table" then
            local npts = #pts
            local polypts = ffi.new("struct BLPoint[?]", npts,pts)
            local arrview = BLPointView(polypts, npts)

            return self:fillGeometry(C.BL_GEOMETRY_TYPE_POLYGOND, arrview)
            --print(polypts, arrview.data, arrview.size)
    end
end

function DrawingContext.fillRectI (self, rect)
    local bResult = self.DC.impl.virt.fillRectI(self.DC.impl, rect);
    
    if bResult == C.BL_SUCCESS then
        return self;
    end

    return false, bResult
end

function DrawingContext.fillRectD (self, x, y, w, h)
    local rect = BLRect(x,y,w,h)
    local bResult = self.DC.impl.virt.fillRectD(self.DC.impl, rect);
        
    if bResult == C.BL_SUCCESS then
            return self;
    end
    
    return false, bResult
end

function DrawingContext.fillRoundRect (self, ...)
    local nargs = select('#', ...)
        
    if nargs < 1 then return false end

    local rrect = select(1,...)

    if nargs == 1 then
          return self:fillGeometry(C.BL_GEOMETRY_TYPE_ROUND_RECT, rrect)
    elseif nargs == 2 then
          return self:fillGeometry(C.BL_GEOMETRY_TYPE_ROUND_RECT, rr)
    elseif nargs == 3 then
          local rrect = BLRoundRect(rect.x, rect.y, rect.w, rect.h, select(2,...), select(3,...))
          return self:fillGeometry(C.BL_GEOMETRY_TYPE_ROUND_RECT, rrect)
    elseif nargs == 5 then
          local rrect = BLRoundRect(select(1,...), select(2,...), select(3,...), select(4,...), select(5,...), select(5,...))
          return self:fillGeometry(C.BL_GEOMETRY_TYPE_ROUND_RECT, rrect)
    end
end

function DrawingContext.fillTriangle (self, ...)
    local nargs = select("#",...)
    if nargs == 6 then
        local tri = BLTriangle(...)
        return self:fillGeometry(C.BL_GEOMETRY_TYPE_TRIANGLE, tri)
    end

    return false, "wrong number of parameters"
end



      -- Fills the passed UTF-8 text by using the given `font`.
      -- the 'size' is the number of characters in the text.
      -- This is vague, as for utf8 and latin, it's a one to one with 
      -- the bytes.  With unicode, it's the number of code points.
function DrawingContext.fillUtf8Text (self, dst, font, text, size)
    size = size or math.huge
    local bResult = return self.DC.impl.virt.fillTextD(self.DC.impl, dst, font, text, size, C.BL_TEXT_ENCODING_UTF8);

    if bResult == C.BL_SUCCESS then
        return self;
    end

    return false, bResult
end


function DrawingContext.strokeGeometry (self, geometryType, geometryData)
    local bResult = self.DC.impl.virt.strokeGeometry(self.DC.impl, geometryType, geometryData);
    
    if bResult == C.BL_SUCCESS then
            return self;
    end
    
    return false, bResult
end
      
function DrawingContext.strokeGlyphRunI (self, pt, font, glyphRun)
    local bResult = self.DC.impl.virt.strokeGlyphRunI(self.DC.impl,  pt, font, glyphRun);
    
    if bResult == C.BL_SUCCESS then
        return self;
    end

    return false, bResult
end

function DrawingContext.strokeGlyphRunD (self, pt, font, glyphRun)
    local bResult = self.DC.impl.virt.strokeGlyphRunD(self.DC.impl, pt, font, glyphRun);
    
    if bResult == C.BL_SUCCESS then
        return self;
    end

    return false, bResult
end

function DrawingContext.strokeGlyphRun = DrawingContext.strokeGlyphRunD;

function DrawingContext.strokeEllipse (self, ...)
    local nargs = select("#",...)
    if nargs == 4 then
        local geo = BLEllipse(...)
        return self:strokeGeometry(C.BL_GEOMETRY_TYPE_ELLIPSE, geo)
    end

    return false, "wrong number of arguments"
end

function DrawingContext.strokePolygon (self, pts)
    if type(pts) == "table" then
        local npts = #pts
        local polypts = ffi.new("struct BLPoint[?]", npts,pts)
        local arrview = BLPointView(polypts, npts)

        return self:strokeGeometry(C.BL_GEOMETRY_TYPE_POLYGOND, arrview)
    end

    return false, "wrong number of arguments"
end

function DrawingContext.strokeRectI (self, rect)
    local bResult = self.DC.impl.virt.strokeRectI(self.DC.impl, rect);

    if bResult == C.BL_SUCCESS then
        return self;
    end
    
    return false, bResult    
end

function DrawingContext.strokeRectD (self, rect)
    local bResult = self.DC.impl.virt.strokeRectD(self.DC.impl, rect);
    
    if bResult == C.BL_SUCCESS then
        return self;
    end
    
    return false, bResult 
end

function DrawingContext.strokeRect(self, x, y, w, y)
    return self:DrawingContext:strokeRectD(BLRect(x,y,w,h))
end

function DrawingContext.strokePathD(self, path)
    local bResult = self.DC.impl.virt.strokePathD(self.DC.impl, path);
    if bResult == C.BL_SUCCESS then
        return self;
    end
    
    return false, bResult 
end

function DrawingContext.strokePath (self, path)
    return self:strokePathD(path)
end


function DrawingContext.strokeLine (self, x1, y1, x2, y2)
    local aLine = BLLine(x1,y1,x2,y2)
    return self:strokeGeometry(C.BL_GEOMETRY_TYPE_LINE, aLine);
end

function DrawingContext.strokeTextI (self, pt, font, text, size, encoding)
        local bResult = self.DC.impl.virt.strokeTextI(self.DC.impl, pt, font, text, size, encoding);
        if bResult == C.BL_SUCCESS then
            return self;
        end
        
        return false, bResult 
end

function DrawingContext.strokeTextD (self, pt, font, text, size, encoding)
        local bResult = self.DC.impl.virt.strokeTextD(self.DC.impl, pt, font, text, size, encoding);
        
        if bResult == C.BL_SUCCESS then
            return self;
        end
        
        return false, bResult 
end

function DrawingContext.strokeTriangle (self, ...)
    local nargs = select("#",...)

    if nargs == 6 then
        local tri = BLTriangle(...)
        return self:strokeGeometry(C.BL_GEOMETRY_TYPE_TRIANGLE, tri)
    end
end

return DrawingContext
