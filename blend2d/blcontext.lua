--
-- MUST be included through blend2d.lua, not independently
--
-- since the BLContextCore is by far the biggest object, it makes
-- sense to have it split out on its own for easy maintenance
--
local ffi = require("ffi")
local C = ffi.C 
local bit = require("bit")
local bor, band = bit.bor, bit.band

local min, max = math.min, math.max

local SIZE_MAX = 0xffffffffffffffffULL;

local blapi = require("blend2d.blend2d_ffi")

-- blcontext types
BLContextCreateInfo = ffi.new("struct BLContextCreateInfo")
BLContextCookie = ffi.typeof("struct BLContextCookie")
BLContextHints = ffi.typeof("struct BLContextHints")
BLContextState = ffi.typeof("struct BLContextState")


local  BLContext = ffi.typeof("struct BLContextCore")
    ffi.metatype(BLContext, {
        __gc = function(self)
          --print("BLContext.gc")
          local bResult = blapi.blContextReset(self) ;
        end;
    
        __new = function(ct, ...)
            local nargs = select("#", ...)
            local obj = ffi.new(ct);
    
            if nargs == 0 then
              local bResult = blapi.blContextInit(obj)
              if bResult ~= C.BL_SUCCESS then
                return nil, bResult
              end
            elseif nargs == 1 then
              local bResult = blapi.blContextInitAs(obj, select(1,...), nil) ;
              if bResult ~= C.BL_SUCCESS then
                return nil, bResult
              end
            elseif nargs == 2 then
              -- it could be two numbers indicating size
              -- or it could be an image and creation options
              if ffi.typeof(select(1,...)) == BLImage then
                local bResult = blapi.blContextInitAs(obj, select(1,...), select(2,...)) ;
                if bResult ~= C.BL_SUCCESS then
                  return nil, bResult
                end
              elseif type(select(1,...)) == "number" and type(select(2,...)) == "number" then
                local img = BLImage(select(1, ...), select(2,...))
                local bResult = blapi.blContextInitAs(obj, img, nil)
                if bResult ~= C.BL_SUCCESS then
                  return nil, bResult;
                end
              end
    
            end
    
            return obj;
        end;
    
        __eq = function(self, other)
          return self.impl == other.impl;
        end;
    
        __index = {
          targetSize = function(self) 
            return self.impl.targetSize;
          end;
    
          targetWidth = function(self)
            return self.impl.targetSize.w;
          end;
    
          targetHeight = function(self)
            return self.impl.targetSize.h;
          end;
    
          --
          -- BLImage Attachment
          --
          -- const BLContextCreateInfo& options
          begin = function(self, image, options)
            local bResult = blapi.blContextBegin(self, image, options);
          end;
    
          finish = function(self)
            local bResult = blapi.blContextEnd(self);
            if bResult == C.BL_SUCCESS then
              return true;
            end
    
            return false, bResult;
          end;
    
          flush = function(self, flags)
            flags = flags or C.BL_CONTEXT_FLUSH_SYNC;
    
            local bResult = self.impl.virt.flush(self.impl, flags);
            if bResult == C.BL_SUCCESS then
              return true;
            end
    
            return false, bResult;
          end;
    
    
    --[[
          State Management
    
          If a cookie is specified when saving, then it must be used
          when restoring.
    --]]
          save = function(self, cookie)
            local bResult = self.impl.virt.save(self.impl, cookie);
            if bResult == C.BL_SUCCESS then
              return true;
            end
    
            return false, bResult;
          end;
          
          restore = function(self, cookie)
            local bResult = self.impl.virt.restore(self.impl, cookie);
            if bResult == C.BL_SUCCESS then
              return true;
            end
    
            return false, bResult;
          end;
    
          clipRectI = function(self, rect)
            local bResult = self.impl.virt.clipToRectI(self.impl, rect);
            if bResult == C.BL_SUCCESS then
              return true;
            end
    
            return false, bResult;    
          end;
    
          removeClip = function(self)
            local bResult = self.impl.virt.restoreClipping(self.impl) ;
            if bResult == C.BL_SUCCESS then
              return true;
            end
    
            return false, bResult;
          end;
    
          --[[
          -- Matrix transformations
          -- Applies a matrix operation to the current transformation matrix (internal).
          --]]
          metaMatrix = function(self)
            return self.impl.state.metaMatrix;
          end;
    
          userMatrix = function(self)
             return self.impl.state.userMatrix;
          end;
    
    
          _applyMatrixOp = function(self, opType, opData)
            local bResult= self.impl.virt.matrixOp(self.impl, opType, opData);
    
            if bResult == C.BL_SUCCESS then
              return true;
            end
    
            return false, bResult;
          end;
          
          _applyMatrixOpV = function(self, opType, ...)
            local opData = ffi.new("double[?]",select('#',...), {...});
            local bResult self.impl.virt.matrixOp(self.impl, opType, opData);
    
            if bResult == C.BL_SUCCESS then
              return true;
            end
    
            return false, bResult;
          end;
    
          resetMatrix = function(self)
            local bResult = self.impl.virt.matrixOp(self.impl, C.BL_MATRIX2D_OP_RESET, nil);
            
            if bResult == C.BL_SUCCESS then
              return true;
            end
    
            return false, bResult;
          end;
    
          -- const BLMatrix2D& m
          setMatrix = function(self, m)
            local bResult = self.impl.virt.matrixOp(self.impl, C.BL_MATRIX2D_OP_ASSIGN, m)
            if bResult == C.BL_SUCCESS then
              return true;
            end
    
            return false, bResult;
          end;
    
          translate = function(self, x, y)
              return self:_applyMatrixOpV(C.BL_MATRIX2D_OP_TRANSLATE, x, y);
          end;
    
          scale = function(self, x, y)
              return self:_applyMatrixOpV(C.BL_MATRIX2D_OP_SCALE, x, y)
          end;
    
          skew = function(self, x, y)
            return self:_applyMatrixOpV(C.BL_MATRIX2D_OP_SKEW, x, y);
          end;
    
          -- 3 values - an angle, and a point to rotate around
          rotateAroundPoint = function(self, rads, x, y)
            return self:_applyMatrixOpV(C.BL_MATRIX2D_OP_ROTATE_PT,rads, x, y);
          end;
    
          -- overloaded rotate
          -- 1 value - an angle (in radians)
          rotate = function(self, rads)
            return self:_applyMatrixOp(C.BL_MATRIX2D_OP_ROTATE, ffi.new("double[1]",rads));
          end;      
    
          transform = function(self, m)
            return self:_applyMatrixOp(C.BL_MATRIX2D_OP_TRANSFORM, m);
          end;
    
          userToMeta = function(self)
            local bResult = self.impl.virt.userToMeta(self.impl);
            
            if bResult == C.BL_SUCCESS then
              return true;
            end
    
            return false, bResult;
          end;
    
    
          --
          -- Composition Options
          --
          compOp = function(self)
            return self.impl.state.compOp;
          end;
    
          setCompOp = function(self, cOp)
            --print("setCompOp: ", self, compOp)
            local bResult = self.impl.virt.setCompOp(self.impl, cOp);
            if bResult == C.BL_SUCCESS then
              return true;
            end
    
            return false, bResult;
          end;
        
          -- Returns global alpha value.
          globalAlpha = function(self)
            return self.impl.state.globalAlpha;
          end;
    
          -- Sets global alpha value.
          setGlobalAlpha = function(self, alpha)
            local bResult = self.impl.virt.setGlobalAlpha(self.impl, alpha);
    
            if bResult == C.BL_SUCCESS then
              return true;
            end
    
            return false, bResult;
          end;
          
          --[[
          -- Style Settings
          --]]
          setFillStyle = function(self, obj)
            if ffi.typeof(obj) == BLRgba32 then
                return self:setFillStyleRgba32(obj.value)
            end
    
            local bResult = blapi.blContextSetFillStyle(self, obj);
            return bResult == 0 or bResult;
          end;
        
          setFillStyleRgba32 = function(self, rgba32)
            local bResult = blapi.blContextSetFillStyleRgba32(self, rgba32);
            return bResult == 0 or bResult;
          end;
    
          fillRule = function(self)
            return self.impl.state.fillRule;
          end;
    
          setFillRule = function(self, fillRule)
            local bResult = self.impl.virt.setFillRule(self.impl, fillRule);
            if bResult == C.BL_SUCCESS then
              return true;
            end
    
            return false, bResult;
          end;
    
          --
          -- Stroke specifics
          --
          setStrokeStartCap = function(self, strokeCap)
            local bResult = blapi.blContextSetStrokeCap(self, C.BL_STROKE_CAP_POSITION_START, strokeCap) ;
            if bResult == C.BL_SUCCESS then
              return true;
            end
    
            return false, bResult;
          end;
    
          setStrokeEndCap = function(self, strokeCap)
            local bResult = blapi.blContextSetStrokeCap(self, C.BL_STROKE_CAP_POSITION_END, strokeCap) ;
            if bResult == C.BL_SUCCESS then
              return true;
            end
    
            return false, bResult;
          end;
    
          -- joinKind == BLStrokeJoin
          setStrokeJoin = function(self, joinKind)
            local bResult = blapi.blContextSetStrokeJoin(self, joinKind) ;
            if bResult == C.BL_SUCCESS then
              return true;
            end
    
            return false, bResult;
          end;
    
          setStrokeStyleRgba32 = function(self, rgba32)
            local bResult = blapi.blContextSetStrokeStyleRgba32(self, rgba32);
            if bResult == C.BL_SUCCESS then
              return true;
            end
    
            return false, bResult;
          end;
    
          setStrokeStyle = function(self, obj)
              if ffi.typeof(obj) == BLRgba32 then
                  return self:setStrokeStyleRgba32(obj.value)
              end
    
              local bResult = blapi.blContextSetStrokeStyle(self, obj) ;
              if bResult == C.BL_SUCCESS then
                return true;
              end
      
              return false, bResult;
          end;
    
          setStrokeWidth = function(self, width)
            local bResult = blapi.blContextSetStrokeWidth(self, width) ;
            if bResult == C.BL_SUCCESS then
              return true;
            end
    
            return false, bResult;
          end;
    
          --[[
            Actual Drawing
          ]]
          -- dst is a BLPoint
          -- srcArea is BLRectI or nil
          blitImage = function(self, dst, src, srcArea )
            local bResult = self.impl.virt.blitImageD(self.impl, dst, src, srcArea);
            if bResult == C.BL_SUCCESS then
              return true;
            end
    
            return false, bResult;
          end;
    
          -- dst is a BLRect, 
          -- srcArea is BLRectI, or nil
          blitScaledImage = function(self, dst, src, srcArea)
            local bResult = self.impl.virt.blitScaledImageD(impl, dst, src, srcArea);
            if bResult == C.BL_SUCCESS then
              return true;
            end
    
            return false, bResult;
          end;
    
          -- Whole canvas drawing functions
          clearAll = function(self)
            local bResult = self.impl.virt.clearAll(self.impl);
            if bResult == C.BL_SUCCESS then
              return true;
            end
    
            return false, bResult;
          end;
    
          clearRect = function(self, rect)
            local bResult = self.impl.virt.clearRectD(self.impl, rect);
            if bResult == C.BL_SUCCESS then
              return true;
            end
    
            return false, bResult;
          end;
    
          fillAll = function(self)
              local bResult = self.impl.virt.fillAll(self.impl);
              if bResult == C.BL_SUCCESS then
                return true;
              end
      
              return false, bResult;
          end;
    
          -- Geometry drawing functions
          fillGeometry = function(self, geometryType, geometryData)
            local bResult = self.impl.virt.fillGeometry(self.impl, geometryType, geometryData);
            if bResult == C.BL_SUCCESS then
              return true;
            end
    
            return false, bResult;
          end;
    
    
          fillCircle = function(self, geo)
            return self:fillGeometry(C.BL_GEOMETRY_TYPE_CIRCLE, geo);
          end;
    
    
          fillEllipse = function(self, geo)
            return self:fillGeometry(C.BL_GEOMETRY_TYPE_ELLIPSE, geo)
          end;
    
          fillPathD = function(self, path)
              local bReasult = blapi.blContextFillPathD(self, path) ;
              if bResult == C.BL_SUCCESS then
                return true;
              end
      
              return false, bResult;
          end;
    
          fillPolygon = function(self, pts)
              --print("fillPolygon: ", pts)
              if type(pts) == "table" then
                local npts = #pts
                local polypts = ffi.new("struct BLPoint[?]", npts,pts)
                local arrview = BLArrayView(polypts, npts)
    
                self:fillGeometry(C.BL_GEOMETRY_TYPE_POLYGOND, arrview)
    
                --print(polypts, arrview.data, arrview.size)
              end
          end;
    
          fillRectI = function(self, rect)
            local bResult = self.impl.virt.fillRectI(self.impl, rect);
            if bResult == C.BL_SUCCESS then
              return true;
            end
    
            return false, bResult;
          end;
    
          fillRectD = function(self, rect)
            local bResult = self.impl.virt.fillRectD(self.impl, rect);
            if bResult == C.BL_SUCCESS then
              return true;
            end
    
            return false, bResult;
          end;
    
          fillRoundRect = function(self, rr)
            return self:fillGeometry(C.BL_GEOMETRY_TYPE_ROUND_RECT, rr);
          end;
    
          fillTriangle = function(self, ...)
              local nargs = select("#",...)
              if nargs == 6 then
                  local tri = BLTriangle(...)
                  return self:fillGeometry(C.BL_GEOMETRY_TYPE_TRIANGLE, tri)
              end
          end;
    
    
    
          --(BLContextImpl* impl, const BLPoint* pt, const BLFontCore* font, const void* text, size_t size, uint32_t encoding) ;
          fillTextD = function(self, pt, font, text, size, encoding)
            local bResult = self.impl.virt.fillTextD(self.impl, pt, font, text, size, encoding) ;
          end;
    
          -- Fills the passed UTF-8 text by using the given `font`.
          -- the 'size' is the number of characters in the text.
          -- This is vague, as for utf8 and latin, it's a one to one with 
          -- the bytes.  With unicode, it's the number of code points.
          fillTextUtf8 = function(self, dst, font, text, size)
              size = size or math.huge
              return self:fillTextD(dst, font, text, size, C.BL_TEXT_ENCODING_UTF8)
          end;
    
    
          strokeGeometry = function(self, geometryType, geometryData)
            local bResult = self.impl.virt.strokeGeometry(self.impl, geometryType, geometryData);
            if bResult == C.BL_SUCCESS then
              return true;
            end
    
            return false, bResult;
          end;
          
          strokeGlyphRunI = function(self, pt, font, glyphRun)
            local bResult = self.impl.virt.strokeGlyphRunI(self.impl,  pt, font, glyphRun);
            if bResult == C.BL_SUCCESS then
              return true;
            end
    
            return false, bResult;
          end;
    
          strokeGlyphRunD = function(self, pt, font, glyphRun)
            local bResult = self.impl.virt.strokeGlyphRunD(self.impl, pt, font, glyphRun);
            if bResult == C.BL_SUCCESS then
              return true;
            end
    
            return false, bResult;
          end;
          
          strokeEllipse = function(self, geo)
            return self:strokeGeometry(C.BL_GEOMETRY_TYPE_ELLIPSE, geo)
          end;
    
          strokePolygon = function(self, pts)
            if type(pts) == "table" then
              local npts = #pts
              local polypts = ffi.new("struct BLPoint[?]", npts,pts)
              local arrview = BLArrayView(polypts, npts)
    
              return self:strokeGeometry(C.BL_GEOMETRY_TYPE_POLYGOND, arrview)
            end
          end;
    
          strokeRectI = function(self, rect)
            local bResult = self.impl.virt.strokeRectI(self.impl, rect);
            if bResult == C.BL_SUCCESS then
              return true;
            end
    
            return false, bResult;
          end;
    
          strokeRectD = function(self, rect)
            local bResult = self.impl.virt.strokeRectD(self.impl, rect);
            if bResult == C.BL_SUCCESS then
              return true;
            end
    
            return false, bResult;
          end;
    
          strokeRoundRect = function(self, geo)
            return self:strokeGeometry(C.BL_GEOMETRY_TYPE_ROUND_RECT, geo)
          end;

          strokePathD = function(self, path)
            local bResult = self.impl.virt.strokePathD(self.impl, path);
            if bResult == C.BL_SUCCESS then
              return true;
            end
    
            return false, bResult;
          end;
    
    
    
          strokeLine = function(self, x1, y1, x2, y2)
              local aLine = BLLine(x1,y1,x2,y2)
              return self:strokeGeometry(C.BL_GEOMETRY_TYPE_LINE, aLine);
          end;
    
          strokeTextI = function(self, pt, font, text, size, encoding)
            local bResult = self.impl.virt.strokeTextI(self.impl, pt, font, text, size, encoding);
            if bResult == C.BL_SUCCESS then
              return true;
            end
    
            return false, bResult;
          end;
    
          strokeTextD = function(self, pt, font, text, size, encoding)
            local bResult = self.impl.virt.strokeTextD(self.impl, pt, font, text, size, encoding);
            if bResult == C.BL_SUCCESS then
              return true;
            end
    
            return false, bResult;
          end;
    
          strokeTextUtf8 = function(self,pt, font, text, size)
            return self:strokeTextD(pt, font, text, size, C.BL_TEXT_ENCODING_UTF8)
          end;
    
          strokeTriangle = function(self, ...)
            local nargs = select("#",...)
            if nargs == 6 then
                local tri = BLTriangle(...)
                return self:strokeGeometry(C.BL_GEOMETRY_TYPE_TRIANGLE, tri)
            end    
          end;
    
    
        };
    })
    
    return BLContext
