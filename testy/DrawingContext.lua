--[[
    DrawingContext

    This object represents a convenient drawing API that connects Lua to 
    Blend2D.  As such, it encapsulates a BLContext, but is NOT a BLContext.

    This allows the context to take on Lua semantics, such as attaching more
    state to the context if desired.

    The intention is to not use the metatype connected to the BLContext itself
    and just rely on this simplified interface instead.

    in most cases it provides straight pass-throughs to the underlying BLContext,
    but it also provides convenient APIs such as found in P5.
    
    Some features:
    Will construct a backing store if necessary
    Enums are encapsulated in DrawingContext
    Where there are multiple forms of interfaces (int and double) double will be favored

--]]

local ffi = require("ffi")
local C = ffi.C 


local blapi = require("blend2d.blend2d")

local enum = require("enum")
local maths = require("maths")
local FontMonger = require("FontMonger")


local DrawingContext = {
    constants = {
        -- colorMode
        RGB = 1;
        HSB = 2;

        -- rectMode, ellipseMode
        CORNER = 1;
        CORNERS = 2;
        RADIUS = 3;
        CENTER = 4;

        -- kind of close (for polygon)
        STROKE = 0;
        CLOSE = 1;

        -- text alignment
        MIDDLE      = 0x00;
        LEFT        = 0x01;
        RIGHT       = 0x04;
        TOP         = 0x10;
        BOTTOM      = 0x40;
        BASELINE    = 0x80;

        MODEL = 1;
        SCREEN = 2;
        SHAPE = 3;

        -- GEOMETRY
        POINTS          = 0;
        LINES           = 1;
        LINE_STRIP      = 2;
        LINE_LOOP       = 3;
        POLYGON         = 4;
        QUADS           = 5;
        QUAD_STRIP      = 6;
        TRIANGLES       = 7;
        TRIANGLE_STRIP  = 8;
        TRIANGLE_FAN    = 9;
    };

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
        [0] = "BL_CONTEXT_HINT_RENDERING_QUALITY",
        [1] = "BL_CONTEXT_HINT_GRADIENT_QUALITY",
        [2] = "BL_CONTEXT_HINT_PATTERN_QUALITY",

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
        "BL_CLIP_MODE_UNALIGNED_RECT";
        "BL_CLIP_MODE_MASK";

        --"BL_CLIP_MODE_COUNT"
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


    -- Path Enums
    BLStrokeCap = enum {
        [0] = "BL_STROKE_CAP_BUTT",
        "BL_STROKE_CAP_SQUARE",
        "BL_STROKE_CAP_ROUND",
        "BL_STROKE_CAP_ROUND_REV",
        "BL_STROKE_CAP_TRIANGLE",
        "BL_STROKE_CAP_TRIANGLE_REV",
        "BL_STROKE_CAP_COUNT"
    };
}



setmetatable(DrawingContext, {
    __call = function(self, ...)
        return self:new(...)
    end
})
local DrawingContext_mt = {
    __index = DrawingContext
}


function DrawingContext.new(self, obj)
    print("DrawingContext.new")
    obj = obj or {}

    obj.fontMonger = obj.fontMonger or FontMonger:new()
    obj.fontMonger:setDpi(192)
    obj.BackingBuffer = obj.BackingBuffer or BLImage(obj.width, obj.height)
    obj.DC = obj.DC or ffi.new("struct BLContextCore")
    local bResult = blapi.blContextInitAs(obj.DC, obj.BackingBuffer, nil)
    if bResult ~= C.BL_SUCCESS then
      return nil, bResult;
    end

    -- Initial State information
    obj.StrokeWeight = 1;

    -- Typography
    obj.fontSize = 18;
    obj.TextHAlignment = DrawingContext.constants.LEFT;
    obj.TextVAlignment = DrawingContext.constants.BASELINE;
    obj.TextLeading = 0;
    obj.TextMode = DrawingContext.constants.SCREEN;

    obj.AngleMode = DrawingContext.constants.RADIANS;
    obj.ColorMode = DrawingContext.constants.RGB;
    obj.RectMode = DrawingContext.constants.CORNER;
    obj.EllipseMode = DrawingContext.constants.RADIUS;
    obj.ShapeMode = DrawingContext.constants.POLYGON;

    obj.DC:clearAll()
    setmetatable(obj, DrawingContext_mt)

    obj:textFont("consolas", 'regular')

    return obj;
end

-- maybe use a local namespace to export
-- all the constants
function DrawingContext.exportConstants(self)
    local enums = {
        self.BLContextHint,
        self.BLContextOpType,
        self.BLContextFlushFlags,
        self.BLContextCreateFlags,
        self.BLClipOp,
        self.BLClipMode,
        self.BLCompOp,
        self.BLGradientQuality,
        self.BLPatternQuality,
        self.BLRenderingQuality,
        self.BLStrokeCap,
    }


    local function globalizeTable(tbl)
        for k,v in pairs(tbl) do
            _G[v] = k;
        end
    end

    for _, tbl in ipairs(enums) do
        globalizeTable(tbl)
    end

    for k,v in pairs(self.constants) do
        _G[k] = v;
    end
end

-- Whole canvas drawing functions
function DrawingContext.clear (self)
    return self.DC:clearAll()
end

function DrawingContext.setDpi(self, dpi)
    self.fontMonger:setDpi(dpi)
    self.dpi = dpi
end


function DrawingContext.background(self, ...)
	local c = select(1,...)
	if type(c) ~= "cdata" then
		c = self:color(...)
	end

    BackgroundColor = c;

    self:save()
    self.DC:setFillStyle(BackgroundColor)
    self.DC:fillAll();
    self:restore()
end

function DrawingContext.getReadyBuffer(self)
    return self.BackingBuffer;
end

function DrawingContext.clip(self, x, y, w, h)
    return self.DC:clipRectI(BLRectI(x,y,w,h))
end

function DrawingContext.noClip(self)
    return self.DC:removeClip()
end


function DrawingContext.finish (self)
    return self.DC:finish();
end

function DrawingContext.flush (self, flags)
    return self.DC:flush(flags)
end

function DrawingContext.save (self, cookie)
    return self.DC:save(cookie)
end
DrawingContext.push = DrawingContext.save

function DrawingContext.restore (self, cookie)
    return self.DC:restore(cookie)
end

DrawingContext.pop = DrawingContext.restore

function DrawingContext.ellipseMode(self, newMode)
    self.EllipseMode = newMode;
end

function DrawingContext.rectMode(self, newMode)
    self.RectMode = newMode;
end


-- Matrix operations
function DrawingContext.resetTransform(self)
    return self.DC:resetTransform();
end

function DrawingContext.userToMeta(self)
    return self.DC:userToMeta()
end


-- overloaded rotate
-- 1 value - an angle (in radians)
-- 3 values - an angle, and a point to rotate around
function DrawingContext.rotateAroundPoint(self, rads, x, y)
    return self.DC:rotateAroundPoint(rads, x, y)
end

function DrawingContext.rotate (self, rads)
    return self.DC:rotate(rads)
end

function DrawingContext.translate (self, x, y)
    return self.DC:translate(x, y)
end

function DrawingContext.scale(self, x, y)
    x = x or 1
    y = y or x

    return self.DC:scale(x, y)
end

function DrawingContext.skew(self, x, y)
    return self.DC:skew(x, y)
end

--[[
    Setting Drawing Attributes
]]
function DrawingContext.setCompOp (self, compOp)
    return self.DC:setCompOp(compOp)
end
    
function DrawingContext.setFillStyle (self, obj)
    if type(obj) == "number" then
        return self.DC:setFillStyleRgba32(obj)
    end

    if ffi.typeof(obj) == BLRgba32 then
        return self.DC:setFillStyleRgba32(obj.value)
    end

    local bResult = blapi.blContextSetFillStyle(self.DC, obj);
    
    if bResult ~= C.BL_SUCCESS then
        return false, bResult;
    end

    return self
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
--[[
    Setting Stroke Attributes
]]
function DrawingContext.setTransformBeforeStroke(self)
    local blResult = blapi.blContextSetStrokeTransformOrder(self.DC, C.BL_STROKE_TRANSFORM_ORDER_BEFORE);

    if bResult ~= C.BL_SUCCESS then
        return false, blResult;
    end

    return self;
end

function DrawingContext.setTransformAfterStroke(self)
    local blResult = blapi.blContextSetStrokeTransformOrder(self.DC, C.BL_STROKE_TRANSFORM_ORDER_AFTER);

    if bResult ~= C.BL_SUCCESS then
        return false, blResult;
    end

    return self;
end

--[[
function DrawingContext.setStrokeStartCap (self, strokeCap)
        local bResult = blapi.blContextSetStrokeCap(self.DC, C.BL_STROKE_CAP_POSITION_START, strokeCap) ;

    if bResult == C.BL_SUCCESS then
        return self;
    end
    
    return false, bResult
end
--]]
--[[
function DrawingContext.setStrokeEndCap (self, strokeCap)
    local bResult = blapi.blContextSetStrokeCap(self.DC, C.BL_STROKE_CAP_POSITION_END, strokeCap) ;
    
    if bResult == C.BL_SUCCESS then
        return self;
    end

    return false, bResult
end
--]]
--[[
-- joinKind == BLStrokeJoin
function DrawingContext.setStrokeJoin (self, joinKind)
    local bResult = blapi.blContextSetStrokeJoin(self.DC, joinKind) ;
    
    if bResult == C.BL_SUCCESS then
        return self;
    end

    return false, bResult
end
--]]

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

--[[
function DrawingContext.setStrokeWidth (self, width)
    local bResult = blapi.blContextSetStrokeWidth(self.DC, width) ;
    
    if bResult == C.BL_SUCCESS then
        return self;
    end

    return false, bResult
end
--]]

--[[
    FILLING
]]

function DrawingContext.fillAll (self)
    return self.DC:fillAll();
end

-- Geometry drawing functions

function DrawingContext.fillCircle (self, ...)
    local nargs = select('#', ...)
    if nargs == 1 then
        local circle = select(1,...)
        return self.DC:fillCircle(circle)
    elseif nargs == 3 then
        local cx = select(1,...)
        local cy = select(2,...)
        local r = select(3,...)
        local circle = BLCircle(cx, cy, r)
        return self.DC:fillCircle(circle)
    end
end


function DrawingContext.fillEllipse (self, ...)
    -- need to deal with ellipse mode
    local nargs = select("#",...)
    if nargs == 4 then
        local geo = BLEllipse(...)
            --print("fillEllipse: ", geo.cx, geo.cy, geo.rx, geo.ry)
        return self.DC:fillEllipse(geo)
    end
end

function DrawingContext.fillPath (self, path)
    return self.DC:fillPathD(path)
end

function DrawingContext.fillPolygon (self, pts)
    --print("fillPolygon: ", pts)
    if type(pts) == "table" then
        local npts = #pts
        local polypts = ffi.new("struct BLPoint[?]", npts,pts)
        local arrview = BLArrayView(polypts, npts)

        return self.DC:fillGeometry(C.BL_GEOMETRY_TYPE_POLYGOND, arrview)
    end
end

function DrawingContext.fillRect(self, x, y, w, h)
    return self.DC:fillRectD(BLRect({x,y,w,h}))
end

function DrawingContext.fillRoundRect(self, rect)
    return self.DC:fillGeometry(C.BL_GEOMETRY_TYPE_ROUND_RECT, rect)
end

--[[
function DrawingContext.fillRoundRect (self, ...)
    local nargs = select('#', ...)
        
    if nargs < 1 then return false end

    local rect = select(1,...)

    if nargs == 1 then
          return self.DC:fillGeometry(C.BL_GEOMETRY_TYPE_ROUND_RECT, rect)
    elseif nargs == 2 then
          local rrect = BLRoundRect(rect.x, rect.y, rect.w, rect.h, select(2,...), select(2,...))
          return self.DC:fillGeometry(C.BL_GEOMETRY_TYPE_ROUND_RECT, rrect)
    elseif nargs == 3 then
          local rrect = BLRoundRect(rect.x, rect.y, rect.w, rect.h, select(2,...), select(3,...))
          return self.DC:fillGeometry(C.BL_GEOMETRY_TYPE_ROUND_RECT, rrect)
    elseif nargs == 5 then
          local rrect = BLRoundRect(select(1,...), select(2,...), select(3,...), select(4,...), select(5,...), select(5,...))
          return self.DC:fillGeometry(C.BL_GEOMETRY_TYPE_ROUND_RECT, rrect)
    end
end
--]]

function DrawingContext.fillTriangle (self, ...)
    local nargs = select("#",...)
    if nargs == 6 then
        local tri = BLTriangle(...)
        return self.DC:fillGeometry(C.BL_GEOMETRY_TYPE_TRIANGLE, tri)
    end

    return false, "wrong number of parameters"
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

DrawingContext.strokeGlyphRun = DrawingContext.strokeGlyphRunD;

function DrawingContext.strokeEllipse (self, ...)
    local nargs = select("#",...)
    if nargs == 4 then
        local geo = BLEllipse(...)
        return self.DC:strokeEllipse(geo)
    end

    return false, "wrong number of arguments"
end

function DrawingContext.strokePolygon (self, pts)
    if type(pts) == "table" then
        local npts = #pts
        local polypts = ffi.new("struct BLPoint[?]", npts,pts)
        local arrview = BLArrayView(polypts, npts)

        return self.DC:strokeGeometry(C.BL_GEOMETRY_TYPE_POLYGOND, arrview)
    end

    return false, "wrong number of arguments"
end

function DrawingContext.strokeRect(self, x, y, w, h)
    return self.DC:strokeRectD(BLRect(x,y,w,h))
end

function DrawingContext.strokeRoundRect (self, ...)
    local nargs = select('#', ...)
        
    if nargs < 1 then return false end

    local rect = select(1,...)

    if nargs == 1 then
        -- BLRoundRect
          return self.DC:strokeGeometry(C.BL_GEOMETRY_TYPE_ROUND_RECT, rect)
    elseif nargs == 2 then
        -- 1 - rect
        -- 2 - radius
          local rrect = BLRoundRect(rect.x, rect.y, rect.w, rect.h, select(2,...), select(2,...))
          return self.DC:strokeRoundRect(rrect)
    elseif nargs == 3 then
        -- 1 - rect
        -- 2 radius
        -- 3 radius
          local rrect = BLRoundRect(rect.x, rect.y, rect.w, rect.h, select(2,...), select(3,...))
          return self.DC:strokeRoundRect(rrect)
    elseif nargs == 5 then
        -- x
        -- y 
        -- w
        -- h
        -- radius
          local rrect = BLRoundRect(select(1,...), select(2,...), select(3,...), select(4,...), select(5,...), select(5,...))
          return self.DC:strokeRoundRect(rrect)
    end
end

function DrawingContext.strokePath(self, path)
    return self.DC:strokePathD(path)
end

function DrawingContext.strokeLine (self, x1, y1, x2, y2)
    local aLine = BLLine(x1,y1,x2,y2)
    return self.DC:strokeGeometry(C.BL_GEOMETRY_TYPE_LINE, aLine);
end

function DrawingContext.strokeText (self, x,y, font, text, size, encoding)
    size = size or #text
    encoding = encoding or C.BL_TEXT_ENCODING_UTF8
    return self.DC:strokeTextD(BLPoint({x,y}), font, text, size, encoding)
end


function DrawingContext.strokeTriangle (self, ...)
    local nargs = select("#",...)

    if nargs == 6 then
        local tri = BLTriangle(...)
        return self.DC:strokeGeometry(C.BL_GEOMETRY_TYPE_TRIANGLE, tri)
    end
end

--[[
    Simple primitives UI
]]

function color(...)
--function DrawingContext.color(self, ...)
	local nargs = select('#', ...)

	-- There can be 1, 2, 3, or 4, arguments
	--	print("Color.new - ", nargs)
	
	local r = 0
	local g = 0
	local b = 0
	local a = 255
	
	if (nargs == 1) then
			r = select(1,...)
			g = r
			b = r
			a = 255;
	elseif nargs == 2 then
			r = select(1,...)
			g = r
			b = r
			a = select(2,...)
	elseif nargs == 3 then
			r = select(1,...)
			g = select(2,...)
			b = select(3,...)
			a = 255
	elseif nargs == 4 then
		r = select(1,...)
		g = select(2,...)
		b = select(3,...)
		a = select(4,...)
    end
    
    local pix = BLRgba32()
--print("r,g,b: ", r,g,b)
    pix.r = r
    pix.g = g
    pix.b = b 
    pix.a = a

	return pix;
end

function DrawingContext.color(self, ...)
    return color(...)
end

function DrawingContext.lerpColor(self, from, to, f)
	local r = maths.lerp(from.r, to.r, f)
	local g = maths.lerp(from.g, to.g, f)
	local b = maths.lerp(from.b, to.b, f)
	local a = maths.lerp(from.a, to.a, f)
	
	return color(r,g,b,a)
end

function DrawingContext.fill(self, ...)
	local c = select(1,...)

	if type(c) ~= "cdata" then
		c = self:color(...)
	end

	self.FillColor = c;
    self.DC:setFillStyle(c)
	self.useFill = true;

	return self;
end

function DrawingContext.noFill(self)
	self.useFill = false;

	return self;
end

function DrawingContext.stroke(self, ...)
	local c = select(1, ...)

	if type(c) ~= "cdata" then
		c = self:color(...)
	end

	self.StrokeColor = c;
    self.DC:setStrokeStyle(c)
	self.useStroke = true;

	return true;
end

function DrawingContext.noStroke(self)
	self.useStroke = false;

	return true;
end


function DrawingContext.strokeCaps(self, strokeCap)
	self.DC:setStrokeCaps(strokeCap) ;
end

function DrawingContext.strokeStartCap(self, cap)
    self.DC:setStrokeStartCap(cap)
    return self;
end

function DrawingContext.strokeEndCap(self, cap)
    self.DC:setStrokeEndCap(cap)
    return self;
end

function DrawingContext.strokeJoin(self, join)
    self.DC:setStrokeJoin(join)
end

function DrawingContext.strokeWidth(self, weight)
    self.StrokeWeight = weight;
    self.DC:setStrokeWidth(weight);
end

--[[
-- loadFont does NOT imply it becomes the current font
function DrawingContext.loadFont(self, faceFilename)
    self.fontMonger:loadFont(facefilename)
	aFace, err = BLFontFace:createFromFile(fontfile)
	if not aFace then
		return false, err
	end

    self.FontFace = aFace;
    -- select font of current font size

    self:textSize(self.fontSize)
end
--]]

function DrawingContext.textFont(self, family, subfamily)
    subfamily = subfamily or 'regular'

    local face, err = self.fontMonger:getFace(family, subfamily)
    if not face then
        return false, err
    end

    self.fontFamily = family;
    self.fontSubFamily = subfamily;
    self.FontFace = face;

    self:textSize(self.fontSize)
end

function DrawingContext.textSize(self, size)
    local afont, err = self.fontMonger:getFont(self.fontFamily, self.fontSubFamily, size)

    if not afont then
        return false, err
    end

	self.Font = afont
	self.fontSize = size

	return true;
end

function DrawingContext.textWidth(self, txt)
	return self.Font:measureText(txt)
end

function DrawingContext.textAlign(self, halign, valign)
	self.TextHAlignment = halign or DrawingContext.constants.LEFT
	self.TextVAlignment = valign or DrawingContext.constants.BASELINE
end

function DrawingContext.textLeading(self, leading)
	self.TextLeading = leading
end

function DrawingContext.textMode(self, mode)
	self.TextMode = mode
end

function DrawingContext.calcTextPosition(self, txt, x, y)
    local cx, cy = self.Font:measureText(txt)

	if self.TextHAlignment == LEFT then
		x = x
	elseif self.TextHAlignment == MIDDLE then
		x = x - (cx/2)
	elseif self.TextHAlignment == RIGHT then
		x = x - cx;
	end

	if self.TextVAlignment == TOP then
		y = y + cy;
	elseif self.TextVAlignment == MIDDLE then 
		y = y + cy / 2
	elseif self.TextVAlignment == BASELINE then
		y = y;
	elseif self.TextVAlignment == BOTTOM then
		y = y;	end
	return x, y
end

function DrawingContext.text(self, txt, x, y)
	local x, y = self:calcTextPosition(txt, x, y)
	self.DC:fillTextUtf8(BLPoint(x,y), self.Font, txt, #txt)
end

function DrawingContext.textOutline(self, txt, x, y)
    local x, y = self:calcTextPosition(txt, x, y)
    --print("textOutline: ", x, y)
    self.DC:strokeTextUtf8(BLPoint(x,y), self.Font, txt, #txt)
end







--[[
    Rectangles
]]
local function calcModeRect(mode, a,b,c,d)

	local x1 = 0;
	local y1 = 0;
	local rwidth = 0;
	local rheight = 0;

	if mode == CORNER then
		x1 = a;
		y1 = b;
		rwidth = c;
		rheight = d;

	elseif mode == CORNERS then
		x1 = a;
		y1 = b;
		rwidth = c - a + 1;
		rheight = d - b + 1;

	elseif mode == CENTER then
		x1 = a - c / 2;
		y1 = b - d / 2;
		rwidth = c;
		rheight = d;

	elseif mode == RADIUS then
		x1 = a - c;
		y1 = b - d;
		rwidth = c * 2;
		rheight = d * 2;
	end

	return x1, y1, rwidth, rheight;
end

function DrawingContext.rect(self, a,b,c,d)

	local x1, y1, rwidth, rheight = calcModeRect(self.RectMode, a,b,c,d)

	if self.useFill then
	    self:fillRect(x1, y1, rwidth, rheight)
	end

	if self.useStroke then
        self:strokeRect(x1, y1, rwidth, rheight)
	end

	return true;
end

local function calcEllipseParams(mode, a,b,c,d)

	if not d then 
		d = c;
	end
	
	local cx = 0;
	local cy = 0;
	local rx = 0;
	local ry = 0;

	if mode == CORNER then
		rx = c / 2;
		ry = d / 2;
		cx = a + rx;
		cy = b + ry;
	elseif mode == CORNERS then
		rx = (c-a)/2;
		ry = (d-b)/2;
		cx = a + rx;
		cy = b + ry;
	elseif mode == CENTER then
		cx = a;
        cy = b;
        rx = c/2;
		ry = d/2;
	elseif mode == RADIUS then
		cx = a;
		cy = b;
		rx = c;
		ry = d or rx;
	end
--print("calc ellipse: ", cx, cy, rx, ry)
	return cx, cy, rx, ry;
end

function DrawingContext.line(self, x1, y1, x2, y2)
    self:strokeLine(x1,y1,x2,y2)

	return self;
end

function DrawingContext.ellipse(self, cx, cy, rx, ry)

	--print("ellipse: ", cx, cy, rx, ry)
	local cx, cy, rx, ry = calcEllipseParams(self.EllipseMode, cx, cy, rx, ry)
    local geo = BLEllipse(cx, cy, rx, ry)

	if self.useFill then
		self.DC:fillEllipse(geo)
	end
	
    if self.useStroke then
		local bResult, err = self.DC:strokeEllipse(geo)
	end

	return self
end

function DrawingContext.circle(self, cx, cy, r)
    return self:ellipse(cx, cy, r, r)
end


--[[
    Images
]]
function DrawingContext.blit (self, img, x, y)
    return self.DC:blitImage(BLPoint(x,y), img)
--[[
    local imgArea = BLRectI(0,0,img:size().w, img:size().h)
    local bResult = blapi.blContextBlitImageD(self.DC, BLPoint(x,y), img, imgArea) ;
    
    if bResult == C.BL_SUCCESS then
        return self;
    end

    return false, bResult
--]]
end

function DrawingContext.stretchBlt (self, dstRect, img, imgArea)
    return self.DC:blitScaledImage(dstRect, img, imgArea)
--[[
    local bResult = blapi.blContextBlitScaledImageD(self.DC, dstRect, img, imgArea) ;

    if bResult == C.BL_SUCCESS then
        return self;
    end

    return false, bResult
--]]
end

return DrawingContext
