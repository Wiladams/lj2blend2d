--[[
  This file contains a more Lua friendly interface to the blend2d library.
  Whereas the blend2d_ffi.lua file contains a fairly raw, unadulturated 
  access to the library, this provides various conveniences, such as
  metatype binding, with handy methods.

  This file makes interacting with blend2d similar to how you would
  be doing it if programming in C++.

  At the same time, it kind of breaks from the typical Lua convention of
  not polluting the global namespace.  Given the amount of constants and 
  types, it seems far easier to go ahead and pollute the global namespace
  than force every call to be specialized through a lookup table.

  Over time, a better solution, like using namespaces might be even 
  better, but for now, convenience reigns supreme.
]]

local ffi = require("ffi")
local C = ffi.C 
local bit = require("bit")
local bor, band = bit.bor, bit.band

local min, max = math.min, math.max

local SIZE_MAX = 0xffffffffffffffffULL;

local blapi = require("blend2d.blend2d_ffi")

BLArrayView = ffi.typeof("BLArrayView")
BLStringView = ffi.typeof("BLStringView")
BLRegionView = ffi.typeof("BLRegionView")
BLDataView = BLArrayView

-- blcontext types
BLContextCreateInfo = ffi.new("struct BLContextCreateInfo")   -- BLContextCreateOptions
BLContextCookie = ffi.typeof("struct BLContextCookie")
BLContextHints = ffi.typeof("struct BLContextHints")
BLContextState = ffi.typeof("struct BLContextState")

-- Only used by `BLContext` to make invocation of functions in `BLContextVirt`.
--enum OpType : uint32_t {
local  kOpFill = C.BL_CONTEXT_OP_TYPE_FILL;
local kOpStroke = C.BL_CONTEXT_OP_TYPE_STROKE;


--[[
    Geometry types
]]
-- LUA Convenience
BLPointI = ffi.typeof("struct BLPointI")
BLPoint = ffi.typeof("struct BLPoint")
ffi.metatype(BLPoint, {
  -- create a new instance, non-destructive
  __add = function(self, other)
    return BLPoint(self.x + other.x, self.y + other.y)
  end;

  __sub = function(self, other)
    return BLPoint(self.x - other.x, self.y - other.y)
  end;
})

BLSizeI = ffi.typeof("struct BLSizeI");
BLSize = ffi.typeof("struct BLSize")

BLBoxI = ffi.typeof("struct BLBoxI")
BLBox = ffi.typeof("struct BLBox")

BLRectI = ffi.typeof("struct BLRectI")
ffi.metatype("struct BLRectI", {
    __tostring = function(self)
      return string.format("BLRectI(%d, %d, %d, %d)", self.x, self.y, self.w, self.h)
    end;

    -- create a new rectangle that is the union of the two
    __add = function(self, other)
      local minx = min(self.x, other.x)
      local miny = min(self.y, other.y)
      local maxx = max(self.x+self.w, other.x+other.w)
      local maxy = max(self.y+self.h, other.y+other.h)

      local w = maxx - minx;
      local h = maxy - miny;
      
      return BLRectI(minx, miny, w, h)
    end;
})

BLRect = ffi.typeof("struct BLRect")

BLLine = ffi.typeof("struct BLLine")

BLTriangle = ffi.typeof("struct BLTriangle")

BLRoundRect = ffi.typeof("struct BLRoundRect")

BLCircle = ffi.typeof("struct BLCircle")

BLEllipse = ffi.typeof("struct BLEllipse")

BLArc = ffi.typeof("struct BLArc")


BLContext = ffi.typeof("struct BLContextCore")
ffi.metatype(BLContext, {
    __gc = function(self)
      local bResult = blapi.blContextReset(self) ;
      return bResult == 0 or bResult;
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
        local bResult = self.implvirt.userToMeta(self.impl);
        
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
      blit = function(self, img, dstX, dstY, imgArea)
          local imgSize = img:size()
          imgArea = imgArea or BLRectI(0,0,imgSize.w, imgSize.h)
          --print(imgArea)
          --BLResult (__cdecl* blitImageI              )(BLContextImpl* impl, const BLPointI* pt, const BLImageCore* img, const BLRectI* imgArea) ;

          local bResult = self.impl.virt.blitImageI(self.impl, BLPointI(dstX, dstY), img, imgArea)
          if bResult == C.BL_SUCCESS then
            return true;
          end
  
          return false, bResult;
      end;

      stretchBlt = function(self, dstRect, img, imgArea)
          local bResult = blapi.blContextBlitScaledImageD(self, dstRect, img, imgArea) ;
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


      fillCircle = function(self, ...)
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
      end;


      fillEllipse = function(self, ...)
        local nargs = select("#",...)
        if nargs == 4 then
            local geo = BLEllipse(...)
            --print("fillEllipse: ", geo.cx, geo.cy, geo.rx, geo.ry)
            self:fillGeometry(C.BL_GEOMETRY_TYPE_ELLIPSE, geo)
        end
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

      fillRoundRect = function(self, ...)
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
      end;

      fillTriangle = function(self, ...)
          local nargs = select("#",...)
          if nargs == 6 then
              local tri = BLTriangle(...)
              return self:fillGeometry(C.BL_GEOMETRY_TYPE_TRIANGLE, tri)
          end
      end;

      fillRoundRect = function(self, rr)
        return self:fillGeometry(C.BL_GEOMETRY_TYPE_ROUND_RECT, rr);
      end;

--[[
    //! Fills a rounded rectangle.
  BL_INLINE BLResult fillRoundRect(const BLRoundRect& rr) noexcept { return fillGeometry(BL_GEOMETRY_TYPE_ROUND_RECT, &rr); }
  //! \overload
  BL_INLINE BLResult fillRoundRect(const BLRect& rect, double r) noexcept { return fillRoundRect(BLRoundRect(rect.x, rect.y, rect.w, rect.h, r)); }
  //! \overload
  BL_INLINE BLResult fillRoundRect(const BLRect& rect, double rx, double ry) noexcept { return fillRoundRect(BLRoundRect(rect.x, rect.y, rect.w, rect.h, rx, ry)); }
  //! \overload
  BL_INLINE BLResult fillRoundRect(double x, double y, double w, double h, double r) noexcept { return fillRoundRect(BLRoundRect(x, y, w, h, r)); }
  //! \overload
  BL_INLINE BLResult fillRoundRect(double x, double y, double w, double h, double rx, double ry) noexcept { return fillRoundRect(BLRoundRect(x, y, w, h, rx, ry)); }

]]
      --(BLContextImpl* impl, const BLPoint* pt, const BLFontCore* font, const void* text, size_t size, uint32_t encoding) ;
      fillTextD = function(self, pt, font, text, size, encoding)
        local bResult = self.impl.virt.fillTextD(self.impl, pt, font, text, size, encoding) ;
      end;

      -- Fills the passed UTF-8 text by using the given `font`.
      -- the 'size' is the number of characters in the text.
      -- This is vague, as for utf8 and latin, it's a one to one with 
      -- the bytes.  With unicode, it's the number of code points.
      fillUtf8Text = function(self, dst, font, text, size)
          size = size or math.huge
          return self:fillTextD(dst, font, text, size, C.BL_TEXT_ENCODING_UTF8)
      end;


      --[[
BLResult __cdecl blContextSetStrokeMiterLimit(BLContextCore* self, double miterLimit) ;
BLResult __cdecl blContextSetStrokeCaps(BLContextCore* self, uint32_t strokeCap) ;
BLResult __cdecl blContextSetStrokeDashOffset(BLContextCore* self, double dashOffset) ;
BLResult __cdecl blContextSetStrokeDashArray(BLContextCore* self, const BLArrayCore* dashArray) ;
BLResult __cdecl blContextSetStrokeTransformOrder(BLContextCore* self, uint32_t transformOrder) ;
BLResult __cdecl blContextSetStrokeOptions(BLContextCore* self, const BLStrokeOptionsCore* options) ;
BLResult __cdecl blContextSetStrokeAlpha(BLContextCore* self, double alpha) ;
BLResult __cdecl blContextGetStrokeStyle(const BLContextCore* self, void* object) ;
BLResult __cdecl blContextGetStrokeStyleRgba32(const BLContextCore* self, uint32_t* rgba32) ;
BLResult __cdecl blContextGetStrokeStyleRgba64(const BLContextCore* self, uint64_t* rgba64) ;

BLResult __cdecl blContextSetStrokeStyleRgba32(BLContextCore* self, uint32_t rgba32) ;
BLResult __cdecl blContextSetStrokeStyleRgba64(BLContextCore* self, uint64_t rgba64) ;
      ]]

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
      
      strokeEllipse = function(self, ...)
        local nargs = select("#",...)
        if nargs == 4 then
            local geo = BLEllipse(...)
            return self:strokeGeometry(C.BL_GEOMETRY_TYPE_ELLIPSE, geo)
        end

        return false, 'not enough arguments specified'
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

      strokeUtf8Text = function(self,pt, font, text, size)
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


BLFile = ffi.typeof("struct BLFileCore")
local BLFile_mt = {
    __gc = function(self)
        local bResult = blapi.blFileReset(self);
    end;
    
    __new = function(ct, ...)
        local obj = ffi.new(ct)
        local bResult = blapi.blFileInit(obj);
        return obj
    end;

    __index = {
        close = function(self)
            local bResult = blapi.blFileClose(self) ;
            return bResult == C.BL_SUCCESS or bResult;
        end;

        open = function(self, fileName, openFlags)
            --print("open: ", fileName, string.format("0x%x",openFlags))

            openFlags = openFlags or C.BL_FILE_OPEN_READ;
            local bResult = blapi.blFileOpen(self, fileName, openFlags) ;

            if bResult ~= C.BL_SUCCESS then
                return false, bResult
            end

            return true;
        end;

        read = function(self, buffer, size)
            local bytesTransferred = ffi.new("size_t[1]")
            local bResult = blapi.blFileRead(self, buffer, size, bytesTransferred) ;
            
            if bResult ~= C.BL_SUCCESS then
              return false, bResult;
            end

          return bytesTransferred[0]
        end;

        write = function(self, buffer, size)
            local bytesTransferred = ffi.new("size_t[1]")
            local bResult = blapi.blFileWrite(self, buffer, size, bytesTransferred) ;
            if bResult ~= C.BL_SUCCESS then
                return false, bResult;
            end

            return bytesTransferred[0]
        end;

        seek = function(self, offset, seekType)
          seekType = seekType or C.BL_FILE_SEEK_SET
            local pOut = ffi.new("uint64_t[1]")
            local bResult = blapi.blFileSeek(self, offset, seekType, pOut)
            if bResult ~= C.BL_SUCCESS then
                return false, bReasult, pOut[0]
            end
            return pOut[0]
        end;

        size = function(self)
            local pSize = ffi.new("uint64_t[1]")
            local bResult = blapi.blFileGetSize(self, pSize)
            if bResult ~= C.BL_SUCCESS then
                return false, bResult;
            end

            return pSize[0]
        end;

        truncate = function(self, maxSize)
            local bResult = blapi.blFileTruncate(self, maxSize) ;
            return bResult == C.BL_SUCCESS;
        end;
    }
}
ffi.metatype(BLFile, BLFile_mt)


--[[
    BLFontLoader
]]
BLFontLoader = ffi.typeof("struct BLFontLoaderCore")
BLFontLoader_mt = {
  __gc = function(self)
    blapi.blFontLoaderReset(self);
  end;

  __index = {
    -- Meant to be called as: BLFontLoader:createFromFile(filename)
    createFromFile = function(ct, filename)
      local obj = ffi.new(ct);
      local bResult = blapi.blFontLoaderInit(obj);
      if bResult ~= C.BL_SUCCESS then
        return nil, bResult
      end

      local readFlags =  C.BL_FILE_OPEN_READ
      bResult = blapi.blFontLoaderCreateFromFile(obj, filename, readFlags) ;
      if bResult ~= C.BL_SUCCESS then
        return nil, bResult
      end

      return obj;
    end;

    dataByIndex = function(self, faceIndex)
      --BLFontDataImpl* __cdecl blFontLoaderDataByFaceIndex(BLFontLoaderCore* self, uint32_t faceIndex) ;
      local impl = blapi.blFontLoaderDataByFaceIndex(self, faceIndex) ;

    end;
  };
}
ffi.metatype(BLFontLoader, BLFontLoader_mt)



--[[
    BLFontFace
]]
BLFontFace = ffi.typeof("struct BLFontFaceCore")
BLFontFaceCore = BLFontFace;
BLFontFace_mt = {
    __gc = function(self)
        local bResult = blapi.blFontFaceReset(self);
        return bResult == C.BL_SUCCESS;
    end;

    __new = function(ct, ...)
        --print("BLFontFace.__new")
        local obj = ffi.new(ct)
        local bResult = blapi.blFontFaceInit(obj)
        if bResult ~= C.BL_SUCCESS then
            return false, "failed blFontFaceInit"
        end
        return obj;
    end;

    __index = {
        -- Use as; BLFontFace:createFromFile(filename)
        createFromFile = function(ct, fileName)
            --print("BLFontFace.createFromFile: ", ct, fileName)
            local obj = ffi.new(ct)

            local bResult = blapi.blFontFaceInit(obj)
            if bResult ~= C.BL_SUCCESS then
                return nil, "failed blFontFaceInit"
            end

            local readFlags = bor(C.BL_FILE_OPEN_READ, C.BL_FILE_READ_MMAP_ENABLED, C.BL_FILE_READ_MMAP_AVOID_SMALL);
            --local readFlags = bor(C.BL_FILE_OPEN_READ);
            local bResult = blapi.blFontFaceCreateFromFile(obj, fileName, readFlags) ;
            --print("blFontFaceCreateFromFile: ", bResult)

            if bResult ~= C.BL_SUCCESS then
              return nil, bResult 
            end

            return obj;
        end;

        -- FontFaceInfo
        faceInfo = function(self)
          return {
            faceType = self.impl.faceInfo.faceType;
            outlineType = self.impl.faceInfo.outlineType;
            glyphCount = self.impl.faceInfo.glyphCount;
            faceIndex = self.impl.faceInfo.faceIndex;
            faceFlags = self.impl.faceInfo.faceFlags;
            diagFlags =self.impl.faceInfo.diagFlags;
          }
        end;

        -- Attributes of the font face
        designMetrics = function(self)
          return self.impl.designMetrics;
        end;

        weight = function(self)
          return tonumber(self.impl.weight);
        end;

        stretch = function(self)
          return self.impl.stretch;
        end;

        style = function(self)
          return self.impl.style;
        end;

        fullName = function(self)
          return tostring(self.impl.fullName)     -- BLStringCore
        end;

        familyName = function(self)
          return tostring(self.impl.familyName) -- BLStringCore
        end;

        subfamilyName = function(self)
          return tostring(self.impl.subfamilyName);
        end;

        postScriptName = function(self)
          return tostring(self.impl.postScriptName);
        end;
        
        -- Use like this
        -- fontFace:createSizedFont(15)
        createFont = function(self, size)
            if not tonumber(size) then
              return false, "size must be a number"
            end

            local font, err = BLFont();
            if not font then
              return nil, err 
            end

            local bResult = blapi.blFontCreateFromFace(font, self, size) ;
            if bResult ~= C.BL_SUCCESS then
              return false;
            end

            return font;
        end;

        getFaceInfo = function(self)
          local bResult = blapi.blFontFaceGet
        end;
    }
}
ffi.metatype(BLFontFace, BLFontFace_mt)

BLFont = ffi.typeof("struct BLFontCore")
BLFontCore = BLFont
BLFont_mt = {
    __gc = function(self)
        local bResult = blapi.blFontReset(self)
        return bResult == C.BL_SUCCESS or bResult;
    end;

    __new = function(ct, ...)
        local obj = ffi.new(ct)
        local bResult = blapi.blFontInit(obj)
        if bResult ~= C.BL_SUCCESS then
            return false, "error initializing font"
        end

        return obj
    end;

    __index = {
        getTextMetrics = function(self, glyphBuff, metrics)
            metrics = metrics or BLTextMetrics();
            local bResult = blapi.blFontGetTextMetrics(self, glyphBuff, metrics) ;
            if bResult ~= C.BL_SUCCESS then
              return false, bResult;
            end

            return metrics;
        end;

        shape = function(self, gbuff)
            local bResult = blapi.blFontShape(self, gbuff) ;
            if bResult ~= C.BL_SUCCESS then
                return false, bResult
            end

            return true;
        end;

        measureText = function(self, txt)
            local gbuff = BLGlyphBuffer()
            --local metrics = BLTextMetrics()

            gbuff:setText(txt)
            self:shape(gbuff)

            local metrics, err = self:getTextMetrics(gbuff)

            if not metrics then
              return false, err;
            end

            local cx = metrics.boundingBox.x1 - metrics.boundingBox.x0;
            local cy = self.impl.metrics.size;

            return cx, cy
        end;


    }
--[[

BLResult __cdecl blFontAssignMove(BLFontCore* self, BLFontCore* other) ;
BLResult __cdecl blFontAssignWeak(BLFontCore* self, const BLFontCore* other) ;
bool     __cdecl blFontEquals(const BLFontCore* a, const BLFontCore* b) ;
BLResult __cdecl blFontCreateFromFace(BLFontCore* self, const BLFontFaceCore* face, float size) ;
BLResult __cdecl blFontMapTextToGlyphs(const BLFontCore* self, BLGlyphBufferCore* buf, BLGlyphMappingState* stateOut) ;
BLResult __cdecl blFontPositionGlyphs(const BLFontCore* self, BLGlyphBufferCore* buf, uint32_t positioningFlags) ;
BLResult __cdecl blFontApplyKerning(const BLFontCore* self, BLGlyphBufferCore* buf) ;
BLResult __cdecl blFontApplyGSub(const BLFontCore* self, BLGlyphBufferCore* buf, size_t index, BLBitWord lookups) ;
BLResult __cdecl blFontApplyGPos(const BLFontCore* self, BLGlyphBufferCore* buf, size_t index, BLBitWord lookups) ;
BLResult __cdecl blFontGetMatrix(const BLFontCore* self, BLFontMatrix* out) ;
BLResult __cdecl blFontGetMetrics(const BLFontCore* self, BLFontMetrics* out) ;
BLResult __cdecl blFontGetDesignMetrics(const BLFontCore* self, BLFontDesignMetrics* out) ;
BLResult __cdecl blFontGetTextMetrics(const BLFontCore* self, BLGlyphBufferCore* buf, BLTextMetrics* out) ;
BLResult __cdecl blFontGetGlyphBounds(const BLFontCore* self, const void* glyphIdData, intptr_t glyphIdAdvance, BLBoxI* out, size_t count) ;
BLResult __cdecl blFontGetGlyphAdvances(const BLFontCore* self, const void* glyphIdData, intptr_t glyphIdAdvance, BLGlyphPlacement* out, size_t count) ;
BLResult __cdecl blFontGetGlyphOutlines(const BLFontCore* self, uint32_t glyphId, const BLMatrix2D* userMatrix, BLPathCore* out, BLPathSinkFunc sink, void* closure) ;
BLResult __cdecl blFontGetGlyphRunOutlines(const BLFontCore* self, const BLGlyphRun* glyphRun, const BLMatrix2D* userMatrix, BLPathCore* out, BLPathSinkFunc sink, void* closure) ;

]]
}
ffi.metatype(BLFont, BLFont_mt)

BLTextMetrics = ffi.typeof("struct BLTextMetrics")




--[[
    GlyphBuffer
]]
BLGlyphBuffer = ffi.typeof("struct BLGlyphBufferCore")
local BLGlyphBuffer_mt = {
    __gc = function(self)
        blapi.blGlyphBufferReset(self)
    end;

    __new = function(ct, ...)
        local obj = ffi.new(ct)
        local bResult = blapi.blGlyphBufferInit(obj)
        if bResult ~= C.BL_SUCCESS then
          return false, bResult;
        end

        return obj;
    end;

    __index = {
        clear = function(self)
            local bResult = blapi.blGlyphBufferClear(self);
            if bResult ~= C.BL_SUCCESS then 
                return false, bResult;
            end

            return true;
        end;

        setText = function(self, txt, encoding)
            encoding = encoding or C.BL_TEXT_ENCODING_UTF8
            local bResult = blapi.blGlyphBufferSetText(self, ffi.cast("const void*",txt), #txt, encoding)
        end;



        glyphPlacements = function(self)
            local function iter()
                for i=0, self.data.size do
                    coroutine.yield(self.data.placementData[i])
                end
            end

            return coroutine.wrap(iter)
        end;

        textAdvance = function(self)
            local cx = 0;
            for placement in self:glyphPlacements() do
              cx = cx + (placement.advance.x/64);
            end

            return cx
        end;
    };
}
ffi.metatype(BLGlyphBuffer, BLGlyphBuffer_mt)

--[[
    BLGradient
]]
BLGradientStop = ffi.typeof("BLGradientStop")
BLLinearGradientValues = ffi.typeof("struct BLLinearGradientValues")
BLRadialGradientValues = ffi.typeof("struct BLRadialGradientValues")
BLConicalGradientValues = ffi.typeof("struct BLConicalGradientValues")

BLGradient = ffi.typeof("struct BLGradientCore")
BLGradientCore = BLGradient
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

        getType = function(self)
          local bResult = blapi.blGradientGetType(self)
          if bResult ~= C.BL_SUCCESS then
            return false, bResult;
          end

          return bResult;
        end;

        setValues = function(self, values)
          -- depends on the type as to which kind of values we're setting
          -- we'll just assume the type has not changed
          local index = 0;
          local n = ffi.sizeof(values)/ffi.sizeof("double")
          local bResult = blapi.blGradientSetValues(self, index, ffi.cast("const double *", values), n) ;

          if bResult ~= C.BL_SUCCESS then
            return false, bResult;
          end

          return self
        end;
    };
}
ffi.metatype(BLGradient, BLGradient_mt )

--[[
    BLImage
]]
BLImage = ffi.typeof("struct BLImageCore")
BLImageCore = BLImage
BLImage_mt = {
  __gc = function(self)
      blapi.blImageReset(self)
  end;

  __eq = function(self, other)
    local bResult = blapi.blImageEquals(self, other)
    return bResult
  end;


--[[
BLResult __cdecl blImageAssignMove(BLImageCore* self, BLImageCore* other) ;
BLResult __cdecl blImageAssignWeak(BLImageCore* self, const BLImageCore* other) ;
BLResult __cdecl blImageAssignDeep(BLImageCore* self, const BLImageCore* other) ;
BLResult __cdecl blImageCreate(BLImageCore* self, int w, int h, uint32_t format) ;
BLResult __cdecl blImageCreateFromData(BLImageCore* self, int w, int h, uint32_t format, void* pixelData, intptr_t stride, BLDestroyImplFunc destroyFunc, void* destroyData) ;
BLResult __cdecl blImageGetData(const BLImageCore* self, BLImageData* dataOut) ;
BLResult __cdecl blImageMakeMutable(BLImageCore* self, BLImageData* dataOut) ;
bool     __cdecl blImageEquals(const BLImageCore* a, const BLImageCore* b) ;
BLResult __cdecl blImageScale(BLImageCore* dst, const BLImageCore* src, const BLSizeI* size, uint32_t filter, const BLImageScaleOptions* options) ;
BLResult __cdecl blImageReadFromData(BLImageCore* self, const void* data, size_t size, const BLArrayCore* codecs) ;
BLResult __cdecl blImageWriteToData(const BLImageCore* self, BLArrayCore* dst, const BLImageCodecCore* codec) ;

--]]
    __new = function(ct, ...)
      --print("BLImageCore.__new: ",...)
      local nargs = select('#', ...)
      local obj = ffi.new(ct)
      local bResult = -1;

      if nargs == 0 then
        -- default constructor
        bResult = blapi.blImageInit(obj)
      elseif nargs == 2 then
        -- width, height
        local width = select(1,...)
        local height = select(2,...)
        bResult = blapi.blImageInitAs(obj, width, height, C.BL_FORMAT_PRGB32)
        --print("BLImage.__new: ", bResult, width, height)
      elseif nargs == 3 then
        -- width, height, format
        bResult = blapi.blImageInitAs(obj, select(1,...), select(2,...), select(3,...))
      elseif nargs == 7 then
        -- w, h, format, pixelData, stride, destroyFunc, destroyData
        bResult = blapi.blImageInitAsFromData(obj, select(1,...), select(2,...), select(3,...), select(4,...), select(5,...), select(6,...), select(7,...))
      end

      if bResult ~= C.BL_SUCCESS then
          return false, bResult;
      end

      --print("BLImageCore.__new, constructor: ", nargs, bResult)
      return obj
    end;


    __index = {
        size = function(self)
          return self.impl.size;
        end;
        
        -- int w, int h, uint32_t format, void* pixelData, intptr_t stride, BLDestroyImplFunc destroyFunc, void* destroyData
        fromData = function(ct, w, h, format, pixelData, stride, destroyFunc, destroyData)

            local obj = ffi.new(ct)

            local bResult = blapi.blImageInitAsFromData(obj, w, h, format, pixelData, stride, destroyFunc, destroyData) 

            if bResult ~= 0 then
                return false, bResult
            end

            return obj
        end;

        -- reading and writing with codec is done in codec
        -- instead of in here
--[[
        writeToFile = function(self, fileName, codec) 
          local bResult = blapi.blImageWriteToFile(self, fileName, codec)
          return bResult == 0 or bResult
        end;

        readFromFile = function(self, fileName, codecs)
            codecs = codecs or blapi.blImageCodecBuiltInCodecs()
            local bResult = blapi.blImageReadFromFile(self, fileName, codecs) ;

            if bResult == C.BL_SUCCESS then
                return true
            end

            return false, bResult
        end;
--]]
    };

    __tostring = function(self)
      return string.format("BLImage(%d,%d)", self.impl.size.w, self.impl.size.h)
    end;
}
ffi.metatype(BLImage, BLImage_mt)


--[[
    BLImageCodec
]]
BLImageCodec = ffi.typeof("BLImageCodecCore")
BLImageCodecCore = BLImageCodec
local BLImageCodec_mt = {
  __gc = function(self)
    blapi.blImageCodecReset(self)
  end;

  __new = function (ct, moniker, codecs)
    --print("BLImageCodec.__new: ", ct, moniker, codecs)
    local obj = ffi.new(ct)
    local bResult = blapi.blImageCodecInit(obj);
    if bResult ~= C.BL_SUCCESS then
        return false, bResult;
    end

    if moniker then
      local bResult = blapi.blImageCodecFindByName(obj, moniker, #moniker, nil)
      if bResult ~= C.BL_SUCCESS then
        return false, bResult;
      end
    end

    return obj;
  end;

  __index = {
      findByName = function(self, name, codecs)
          local obj = BLImageCodec();
          local bResult = blapi.blImageCodecFindByName(obj, name, #name, codecs) ;

          if bResult ~= C.BL_SUCCESS then
              return false, bResult;
          end

          return obj;
      end;

      writeImageToFile = function(self, img, fileName)
        local bResult = blapi.blImageWriteToFile(img, fileName, self)
        return bResult == 0 or bResult
      end;

      readImageFromFile = function(ct, fileName, codecs)
        --print("readImageFromFile: ", tc, fileName, codecs)

          local img = BLImage();
          --codecs = codecs or blapi.blImageCodecBuiltInCodecs()
          local bResult = blapi.blImageReadFromFile(img, fileName, codecs);
          if bResult ~= C.BL_SUCCESS then
              return false, bResult
          end

          return img
      end;
  };
}
ffi.metatype(BLImageCodec, BLImageCodec_mt)

--[[
--BLResult __cdecl blMatrix2DSetIdentity(BLMatrix2D* self) ;
--BLResult __cdecl blMatrix2DSetTranslation(BLMatrix2D* self, double x, double y) ;
--BLResult __cdecl blMatrix2DSetSkewing(BLMatrix2D* self, double x, double y) ;
--BLResult __cdecl blMatrix2DSetRotation(BLMatrix2D* self, double angle, double cx, double cy) ;
BLResult __cdecl blMatrix2DApplyOp(BLMatrix2D* self, uint32_t opType, const void* opData) ;
--BLResult __cdecl blMatrix2DInvert(BLMatrix2D* dst, const BLMatrix2D* src) ;
--uint32_t __cdecl blMatrix2DGetType(const BLMatrix2D* self) ;
--BLResult __cdecl blMatrix2DMapPointDArray(const BLMatrix2D* self, BLPoint* dst, const BLPoint* src, size_t count) ;
--]]

BLMatrix2D = ffi.typeof("struct BLMatrix2D")
local BLMatrix2D_mt = {
    __tostring = function(self)
        local tbl = {}
        table.insert(tbl, string.format("%3.2f  %3.2f", self.m00, self.m01))
        table.insert(tbl, string.format("%3.2f  %3.2f", self.m10, self.m11))
        table.insert(tbl, string.format("%3.2f  %3.2f", self.m20, self.m21))
        return table.concat(tbl, "\n")
    end;

    __index = {
        -- Constructors
        createIdentity = function(self)
          local m1 = BLMatrix2D();
          blapi.blMatrix2DSetIdentity(m1)
          return m1
        end;

        createScaling = function(self, sx, sy)
          local m1 = BLMatrix2D()
          blapi.blMatrix2DSetScaling(m1, sx, sy)
          return m1
        end;

        createSkewing = function(self, skx, sky)
          local m1 = BLMatrix2D()
          blapi.blMatrix2DSetSkewing(m1, skx, sky) ;
          return m1;
        end;

        createTranslation = function(self, x, y)
          local m1 = BLMatrix2D();
          blapi.blMatrix2DSetTranslation(m1, x, y)
          return m1;
        end;

        createRotation = function(self, angle, cx, cy)
          local m1 = BLMatrix2D()
          blapi.blMatrix2DSetRotation(m1, angle, cx, cy)     -- 45 degrees
          return m1
        end;

        createInverse = function(self)
          local dst = ffi.new("struct BLMatrix2D")
          blapi.blMatrix2DInvert(dst, self) ;
          return dst
        end;

        -- Matrix operations
        applyOperation = function(self, opType, opData)
          local bResult = blapi.blMatrix2DApplyOp(self, opType, opData) ;
        end;

        getType = function(self)
          return blapi.blMatrix2DGetType(self) ;
        end;

        -- apply the current transformation to an array of points
        -- should accept a lua table as a matter of convenience
        transformPoints = function(self, dstPts, srcPts, count)
          local bResult = blapi.blMatrix2DMapPointDArray(self, dstPts, srcPts, count) ;
          if bResult ~= C.BL_SUCCESS then
            return false, bResult;
          end

          return self;
        end;

        -- transform a single point
        transformSinglePoint = function(self, srcPt)
          local dstPoint = ffi.new("BLPoint")
          local bResult = blapi.blMatrix2DMapPointDArray(self, dstPoint, srcPt, 1)
          if bResult ~= C.BL_SUCCESS then
            return false, bResult;
          end
          return dstPoint
        end;
    };
}
ffi.metatype("struct BLMatrix2D", BLMatrix2D_mt)


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

strokePath = blapi.blPathAddStrokedPath ;
}
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

--[[
    BLPattern
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
    BLRandom
]]

BLRandom = ffi.typeof("struct BLRandom")
ffi.metatype(BLRandom, {
    __index = {
        __new = function(ct, ...)
            local obj = ffi.new(ct)
            blapi.blRandomReset(obj, math.random(1, 65535))

            return obj;
        end;

        reset = function(self, seed)
            return blapi.blRandomReset(self, seed)
        end;
      
        nextUInt32 = function(self)
            return blapi.blRandomNextUInt32(self);
        end;

        nextUInt64 = function(self)
            return blapi.blRandomNextUInt64(self);
        end;

        nextDouble = function(self)
            return blapi.blRandomNextDouble(self);
        end;

    }
})

--[[
    BLRgba
]]
BLRgba32 = ffi.typeof("struct BLRgba32")
BLRgba64 = ffi.typeof("struct BLRgba64")


--[[
    BLString
]]

BLString = ffi.typeof("struct BLStringCore")
ffi.metatype(BLString, {
  -- make easy conversion using tostring()
  __tostring = function(self)
    return ffi.string(self.impl.data, self.impl.size)
  end;
})

return blapi
