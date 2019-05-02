local ffi = require("ffi")
local C = ffi.C 

local blapi = require("blend2d.blend2d_ffi")

-- blcontext types
BLContextCreateOptions = ffi.new("struct BLContextCreateOptions")
BLContextCookie = ffi.typeof("struct BLContextCookie")
BLContextHints = ffi.typeof("struct BLContextHints")
BLContextState = ffi.typeof("struct BLContextState")

--[=[
BLContextCore_mt.__index = function(self, key)
    print("BLContextCore_mt:__index: ", key)

    -- first look in the implemenation for a field
    local success, info = pcall(function() return self.impl[key] end)
    if success then
        return info 
    end

--[[
      -- finally look for something in the virtual table
      -- then look in the virtual table for a function
      success, info = pcall(function() return self.impl.virt[key] end)
      if success then
          return info 
      end
--]]
    -- look for a private implementation
    local info rawget(BLContextCore_mt, key)
    print("Info: ", key, info)
    for k,v in pairs(BLContextCore_mt) do 
      print(k,v)
    end

    return info
end
--]=]
BLContext = ffi.typeof("struct BLContextCore")
ffi.metatype(BLContext, {
    __gc = function(self)
      local bResult = blapi.blContextReset(self) ;
      return bResult == 0 or bResult;
    end;

    __new = function(ct, ...)
        local nargs = select("#", ...)
        local obj = ffi.new(ct);

        --BLResult __cdecl blContextInitAs(BLContextCore* self, BLImageCore* image, const BLContextCreateOptions* options) ;

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

    __index = {
      
      -- end
      finish = function(self)
          local bResult = blapi.blContextEnd(self);
          return bResult == 0 or bResult;
      end;

      flush = function(self, flags)
        flags = flags or C.BL_CONTEXT_FLUSH_SYNC;

        local bResult = self.impl.virt.flush(self.impl, flags);
        return bResult == 0 or bResult;
      end;

      save = function(self, cookie)
        local bResult = self.impl.virt.save(self.impl, cookie);
        return bResult == 0 or bResult;
      end;
      
      restore = function(self, cookie)
        local bResult = self.impl.virt.restore(self.impl, cookie);
        return bResult == 0 or bResult;
      end;

      clip = function(self, x, y, w, h)
        local bResult = self.impl.virt.clipToRectI(self.impl, BLRectI(x,y,w,h));
        if bResult ~= C.BL_SUCCESS then
          return false, bResult;
        end
        return true;      
      end;

      removeClip = function(self)
        local bResult = self.impl.virt.restoreClipping(self.impl) ;
        if bResult ~= C.BL_SUCCESS then
          return false, bResult;
        end
        return true; 
      end;

      -- Applies a matrix operation to the current transformation matrix (internal).
      _applyMatrixOp = function(self, opType, opData)
        return self.impl.virt.matrixOp(self.impl, opType, opData);
      end;
      
      _applyMatrixOpV = function(self, opType, ...)
        local opData = ffi.new("double[?]",select('#',...), {...});
        return self.impl.virt.matrixOp(self.impl, opType, opData);
      end;

      -- overloaded rotate
      -- 1 value - an angle (in radians)
      -- 3 values - an angle, and a point to rotate around
      rotate = function(self, rads, x, y)
          if not y then
              if not x then
                  if not rads then
                    return false, 'invalid arguments'
                  end
                  -- single argument specified
                  return self:_applyMatrixOp(C.BL_MATRIX2D_OP_ROTATE, ffi.new("double[1]",rads));
              end
              -- there are two parameters
              -- radians, and hopefully a BLPoint struct
              error("BLContext.rotate(angle, Point), NYI")
          end

          if rads and x and y then
              return self:_applyMatrixOpV(C.BL_MATRIX2D_OP_ROTATE_PT,rads, x, y);
          end
      end;

      translate = function(self, x, y)
          return self:_applyMatrixOpV(C.BL_MATRIX2D_OP_TRANSLATE, x, y);
      end;

      scale = function(self, ...)
          local nargs = select('#',...)
          --print("nargs: ", nargs)
          local x, y = 1, 1;
          if nargs == 1 then
              if typeof(select(1,...) == "number") then
                  x = select(1,...)
                  y = x;
                  --print("blcontext.scale: ", x, y)
                  return self:_applyMatrixOpV(C.BL_MATRIX2D_OP_SCALE, x, y)
              end
          elseif nargs == 2 then
              x = select(1,...)
              y = select(2,...)

              if x and y then
                  return self:_applyMatrixOpV(C.BL_MATRIX2D_OP_SCALE, x, y)
              end
          end 
          
          return false, "invalid arguments"
      end;

      
      setCompOp = function(self, compOp)
        --print("setCompOp: ", self, compOp)
        local bResult = blapi.blContextSetCompOp(self, compOp);
        return bResult == 0 or bResult;
      end;
    
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

      setStrokeStartCap = function(self, strokeCap)
        local bResult = blapi.blContextSetStrokeCap(self, C.BL_STROKE_CAP_POSITION_START, strokeCap) ;
      end;

      setStrokeEndCap = function(self, strokeCap)
        local bResult = blapi.blContextSetStrokeCap(self, C.BL_STROKE_CAP_POSITION_END, strokeCap) ;
      end;

      -- joinKind == BLStrokeJoin
      setStrokeJoin = function(self, joinKind)
        local bResult = blapi.blContextSetStrokeJoin(self, joinKind) ;
      end;

      setStrokeStyleRgba32 = function(self, rgba32)
        local bResult = blapi.blContextSetStrokeStyleRgba32(self, rgba32);
        return bResult == 0 or bResult;
      end;

      setStrokeStyle = function(self, obj)
          if ffi.typeof(obj) == BLRgba32 then
              return self:setStrokeStyleRgba32(obj.value)
          end

          local bResult = blapi.blContextSetStrokeStyle(self, obj) ;
          return bResult == 0 or bResult;
      end;

      setStrokeWidth = function(self, width)
        local bResult = blapi.blContextSetStrokeWidth(self, width) ;
        return bResult == C.BL_SUCCESS or bResult;
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
      end;

      stretchBlt = function(self, dstRect, img, imgArea)
          local bResult = blapi.blContextBlitScaledImageD(self, dstRect, img, imgArea) ;
      end;


      -- Whole canvas drawing functions
      clear = function(self)
          self.impl.virt.clearAll(self.impl)
      end;

      fillAll = function(self)
          local bResult = self.impl.virt.fillAll(self.impl);
          return bResult == 0 or bResult;
      end;

      -- Geometry drawing functions
      fillGeometry = function(self, geometryType, geometryData)
        local bResult = self.impl.virt.fillGeometry(self.impl, geometryType, geometryData);
        return bResult == 0 or bResult;
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

      fillPath = function(self, path)
          local bReasult = blapi.blContextFillPathD(self, path) ;
          return bResult == 0 or bResult;
      end;

      fillPolygon = function(self, pts)
          --print("fillPolygon: ", pts)
          if type(pts) == "table" then
            local npts = #pts
            local polypts = ffi.new("struct BLPoint[?]", npts,pts)
            local arrview = BLPointView(polypts, npts)

            self:fillGeometry(C.BL_GEOMETRY_TYPE_POLYGOND, arrview)
            --print(polypts, arrview.data, arrview.size)
          end
      end;

      fillRectI = function(self, rect)
        local bResult = self.impl.virt.fillRectI(self.impl, rect);
        if bResult ~= C.BL_SUCCESS then
          return false, bResult 
        end

        return self
      end;

      fillRectD = function(self, x, y, w, h)
        local rect = BLRect(x,y,w,h)
        local bResult = self.impl.virt.fillRectD(self.impl, rect);
        return bResult == 0 or bResult;
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
              self:fillGeometry(C.BL_GEOMETRY_TYPE_TRIANGLE, tri)
          end
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
      -- Fills the passed UTF-8 text by using the given `font`.
      -- the 'size' is the number of characters in the text.
      -- This is vague, as for utf8 and latin, it's a one to one with 
      -- the bytes.  With unicode, it's the number of code points.
      fillUtf8Text = function(self, dst, font, text, size)
          size = size or math.huge
          return self.impl.virt.fillTextD(self.impl, dst, font, text, size, C.BL_TEXT_ENCODING_UTF8);
      end;


      --[[
        BLResult __cdecl 
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
        return bResult == 0 or bResult;
      end;
      
      strokeGlyphRunI = function(self, pt, font, glyphRun)
        local bResult = self.impl.virt.strokeGlyphRunI(self.impl,  pt, font, glyphRun);
        return bResult == 0 or bResult;
      end;

      strokeGlyphRunD = function(self, pt, font, glyphRun)
        local bResult = self.impl.virt.strokeGlyphRunD(self.impl, pt, font, glyphRun);
        return bResult == 0 or bResult;
      end;
      
      strokeEllipse = function(self, ...)
        local nargs = select("#",...)
        if nargs == 4 then
            local geo = BLEllipse(...)
            self:strokeGeometry(C.BL_GEOMETRY_TYPE_ELLIPSE, geo)
        end
      end;

      strokePolygon = function(self, pts)
        if type(pts) == "table" then
          local npts = #pts
          local polypts = ffi.new("struct BLPoint[?]", npts,pts)
          local arrview = BLPointView(polypts, npts)

          self:strokeGeometry(C.BL_GEOMETRY_TYPE_POLYGOND, arrview)
        end
      end;

      strokeRectI = function(self, rect)
        local bResult = self.impl.virt.strokeRectI(self.impl, rect);
        return bResult == 0 or bResult;
      end;

      strokeRectD = function(self, rect)
        local bResult = self.impl.virt.strokeRectD(self.impl, rect);
        return bResult == 0 or bResult;
      end;

      strokePath = function(self, path)
        local bResult = self.impl.virt.strokePathD(self.impl, path);
        return bResult == 0 or bResult;
      end;



      strokeLine = function(self, x1, y1, x2, y2)
          local aLine = BLLine(x1,y1,x2,y2)
          self:strokeGeometry(C.BL_GEOMETRY_TYPE_LINE, aLine);
      end;

      strokeTextI = function(self, pt, font, text, size, encoding)
        local bResult = self.impl.virt.strokeTextI(self.impl, pt, font, text, size, encoding);
        return bResult == 0 or bResult;
      end;

      strokeTextD = function(self, pt, font, text, size, encoding)
        local bResult = self.impl.virt.strokeTextD(self.impl, pt, font, text, size, encoding);
        return bResult == 0 or bResult;
      end;

      strokeTriangle = function(self, ...)
        local nargs = select("#",...)
        if nargs == 6 then
            local tri = BLTriangle(...)
            self:strokeGeometry(C.BL_GEOMETRY_TYPE_TRIANGLE, tri)
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

      bResult = blapi.blFontLoaderCreateFromFile(obj, filename)
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
        print("BLFontFace.__new")
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

            local bResult = blapi.blFontFaceCreateFromFile(obj, fileName) ;
            --print("blFontFaceCreateFromFile: ", bResult)

            if bResult ~= C.BL_SUCCESS then
              return nil, bResult 
            end

            return obj;
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
BLResult __cdecl blFontShape(const BLFontCore* self, BLGlyphBufferCore* buf) ;
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
      return string.format("BLRect(%d, %d, %d, %d)", self.x, self.y, self.w, self.h)
    end
})
BLRect = ffi.typeof("struct BLRect")

BLLine = ffi.typeof("struct BLLine")

BLTriangle = ffi.typeof("struct BLTriangle")

BLRoundRect = ffi.typeof("struct BLRoundRect")

BLCircle = ffi.typeof("struct BLCircle")

BLEllipse = ffi.typeof("struct BLEllipse")

BLArc = ffi.typeof("struct BLArc")

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



return blapi
