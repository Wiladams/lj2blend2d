--[[
    GraphPort

    A 2D graphics API which gives a feel like Processing, or P5.
    A graphport is meant to have a rendering context, which adheres
    to the rendering context API, which has less convenience, and is
    more raw like the blend2d api.

    This rendering context must be passed in to the constructor of
    a graphport.

    The GraphPort is stateful.  It may choose to maintain state within 
    the object itself, or within the rendering context, depending on what
    the context is capable of.

    A graphport can be sub-classed for additional functionality.
]]

local ffi = require("ffi")
local C = ffi.C




local GraphPort = {


    -- Blend Kinds
    BLEND 		= C.BL_COMP_OP_SRC_OVER;
    REPLACE		= C.BL_COMP_OP_SRC_COPY;
--= C.BL_COMP_OP_SRC_IN = 2;
--= C.BL_COMP_OP_SRC_OUT = 3;
--= C.BL_COMP_OP_SRC_ATOP = 4;
--= C.BL_COMP_OP_DST_OVER = 5;
--= C.BL_COMP_OP_DST_COPY = 6;
--= C.BL_COMP_OP_DST_IN = 7;
--= C.BL_COMP_OP_DST_OUT = 8;
--= C.BL_COMP_OP_DST_ATOP = 9;
--= C.BL_COMP_OP_XOR = 10;
--= C.BL_COMP_OP_CLEAR = 11;
ADD 			= C.BL_COMP_OP_PLUS;
DIFFERENCE 	= C.BL_COMP_OP_MINUS;
MULTIPLY		= C.BL_COMP_OP_MULTIPLY;
SCREEN 		= C.BL_COMP_OP_SCREEN;
OVERLAY 		= C.BL_COMP_OP_OVERLAY;
--= C.BL_COMP_OP_DARKEN = 17;
--= C.BL_COMP_OP_LIGHTEN = 18;
DODGE			= C.BL_COMP_OP_COLOR_DODGE;
BURN 			= C.BL_COMP_OP_COLOR_BURN;
--= C.BL_COMP_OP_LINEAR_BURN = 21;
--= C.BL_COMP_OP_LINEAR_LIGHT = 22;
--= C.BL_COMP_OP_PIN_LIGHT = 23;
HARD_LIGHT 	= C.BL_COMP_OP_HARD_LIGHT;
SOFT_LIGHT 	= C.BL_COMP_OP_SOFT_LIGHT;
SUBTRACT 		= C.BL_COMP_OP_DIFFERENCE;
--= C.BL_COMP_OP_EXCLUSION = 27;

-- Stroke Attributes
-- Joint styles
JOIN_MITER_CLIP = C.BL_STROKE_JOIN_MITER_CLIP;
JOIN_MITER_BEVEL = C.BL_STROKE_JOIN_MITER_BEVEL;
JOIN_MITER_ROUND = C.BL_STROKE_JOIN_MITER_ROUND;
JOIN_BEVEL = C.BL_STROKE_JOIN_BEVEL;
JOIN_ROUND = C.BL_STROKE_JOIN_ROUND;

    -- Endcap style
    CAP_BUTT = 0;
    CAP_SQUARE = 1;
    CAP_ROUND = 2;
    CAP_ROUND_REV = 3;
    CAP_TRIANGLE = 4;
    CAP_TRIANGLE_REV = 5;


}

--[[
    Expecting obj to have a ctxt object which implements a drawing
    API represented by the BLContext object

    GraphPort:new{renderer = BLContext()}
]]

local GraphPort.new(self, obj)
    obj = obj or {}

    -- State information
    obj.FillColor = 255;
    obj.StrokeColor = 0;
    obj.useFilll = true;
	obj.useStroke = true;
	obj.PointSize = 1.0;

	setmetatable(obj, self)
    self.__index = self;
    
    return obj;
end

--[==================================================[
		LANGUAGE COMMANDS
--]==================================================]
function GraphPort.push(self)
    self.DC:save()
end

function GraphPort.pop(self)
    renderer:restore();
end

local function GraphPort.getFont(self, name, size)
end



-- ATTRIBUTES
function GraphPort.blendMode(self, mode)
	-- set compositing operator
	self.DC:setCompOp(mode)
end

function GraphPort.smooth(self)

end

function GraphPort.noSmooth(self)

end

function GraphPort.pointSize(self, ptSize)
	PointSize = ptSize;
end

function GraphPort.strokeCaps(self, strokeCap)
	renderer:setStrokeCaps(strokeCap) ;
end

function GraphPort.strokeJoin(self, join)
    renderer:setStrokeJoin(join)
end

function GraphPort.strokeWeight(self, weight)
    renderer:setStrokeWidth(weight);
end

function GraphPort.colorMode(self, amode)
	-- if it's not valid input, just return
	if amode ~= RGB and amode ~= HSB then 
		return 
	end
	ColorMode = amode;

	return true;
end



--[[
    COLOR
]]

function GraphPort.color(self, ...)
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


function GraphPort.blue(self, c)
	return c.b
end

function GraphPort.green(self, c)
	return c.g
end

function GraphPort.red(self, c)
	return c.r
end

function GraphPort.alpha(self, c)
	return c.a
end

function GraphPort.lerpColor(self, from, to, f)
	local r = lerp(from.r, to.r, f)
	local g = lerp(from.g, to.g, f)
	local b = lerp(from.b, to.b, f)
	local a = lerp(from.a, to.a, f)
	
	return color(r,g,b,a)
end

function GraphPort.fill(self, ...)
	local c = select(1,...)

	if type(c) ~= "cdata" then
		c = color(...)
	end

	FillColor = c;
    renderer:setFillStyle(FillColor)
	self.useFill = true;

	return true;
end

function GraphPort.noFill(self)
	self.useFill = false;

	return true;
end



function GraphPort.stroke(self, ...)
	local c = select(1, ...)

	if type(c) ~= "cdata" then
		c = color(...)
	end

	StrokeColor = c;
    renderer:setStrokeStyle(StrokeColor)
	useStroke = true;

	return true;
end

function GraphPort.noStroke(self)
	useStroke = false;

	return true;
end


--[[
	Actual drawing
]]
function GraphPort.clear(self)
    renderer:save()
    renderer:setFillStyle(BackgroundColor)
    renderer:fillAll();
    renderer:restore();
end

function GraphPort.background(self, ...)
	local n = select('#', ...)
	local c = select(1,...)
	if type(c) ~= "cdata" then
		c = color(...)
	end

	BackgroundColor = c;

    clear();
end

function GraphPort.point(self, x,y,z)
    -- depending on the stroke width
    -- draw the piont as a circle
	
	return true;
end

function GraphPort.line(self, ...)
	-- We either have 4, or 6 parameters
	local nargs = select('#',...)
	local x1, y1, z1, x2, y2, z2

	if nargs == 4 then
		x1 = select(1, ...)
		y1 = select(2, ...)
		x2 = select(3, ...)
		y2 = select(4, ...)
	elseif arg.n == 6 then
		x1 = select(1, ...)
		y1 = select(2, ...)
		z1 = select(3, ...)
		x2 = select(4, ...)
		y2 = select(5, ...)
		z2 = select(6, ...)
	end

    renderer:strokeLine(x1,y1,x2,y2)

	return true;
end

function GraphPort.angleArc(self, x,y,r,startAt, endAt)
	
end

function GraphPort.triangle(self, ...)
	if FillColor then
		renderer:fillTriangle(...)
	end

	if StrokeColor then
		renderer:strokeTriangle(...)
	end
end

function GraphPort.polygon(self, pts)
	if self.useFill then
		renderer:fillPolygon(pts)
	end

	if self.useStroke then
		renderer:strokePolygon(pts)
	end

end

function GraphPort.polyline(self, pts)

end

function GraphPort.quad(self, x1, y1, x2, y2, x3, y3, x4, y4)
	polygon({{x1,y1},{x2,y2},{x3,y3},{x4,y4}})
end

local function GraphPort.calcModeRect(self, mode, ...)
	local nargs = select('#',...)
	if nargs < 4 then return false end

	local a = select(1, ...)
	local b = select(2, ...)
	local c = select(3,...)
	local d = select(4,...)

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

function GraphPort.rect(self, ...)
	local nargs = select('#',...)
	if nargs < 4 then return false end

	local x1, y1, rwidth, rheight = calcModeRect(RectMode, ...)

	if nargs == 4 then
		if self.useFill then
		renderer:fillRectD(x1, y1, rwidth, rheight)
		end

		if self.useStroke then
			renderer:strokeRectD(BLRect(x1, y1, rwidth, rheight))
		end
    elseif nargs == 5 then
        -- do rounded rect
	end

	return true;
end

local function calcEllipseParams(mode, ...)
	local nargs = select('#',...)
	--if nargs < 4 then return false end

	local a = select(1, ...)
	local b = select(2, ...)
	local c = select(3,...)
	local d = select(4,...)

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
		rx = c / 2;
		ry = d / 2;
		cx = a;
		cy = b;
	elseif mode == RADIUS then
		cx = a;
		cy = b;
		rx = c;
		ry = d;
	end

	return cx, cy, rx, ry;
end

function GraphPort.ellipse(self, ...)
	local nargs = select('#',...)
	if nargs < 3 then return false; end

	
	local cx, cy, rx, ry = calcEllipseParams(EllipseMode, ...)

	if self.useFill then
		renderer:fillEllipse(cx, cy, rx, ry)
	end
	
	if self.useStroke then
		local bResult, err = renderer:strokeEllipse(cx, cy, rx, ry)
	end

	return true
end

--[====================================[
--	Curves
--]====================================]

function GraphPort.bezier(self, x1, y1,  x2, y2,  x3, y3,  x4, y4)
	local path = BLPath()
	path:moveTo(x1, y1)
	path:cubicTo(x2,y2,x3,y3, x4,y4)
	renderer:strokePath(path)
end

function GraphPort.bezierDetail(self, ...)
end

function GraphPort.bezierPoint(self, ...)
end

-- Catmull - Rom curve
function GraphPort.curve(self, x1, y1,  x2, y2,  x3, y3,  x4, y4)

end

function GraphPort.curveDetail(self, ...)
end

function GraphPort.curvePoint(self, ...)
end

function GraphPort.curveTangent(self, ...)

end

function GraphPort.curveTightness(self, ...)
end




-- VERTEX
function GraphPort.beginShape(self, sMode)
	ShapeMode = sMode or POLYGON
	
	-- Start a new array of vertices
	ShapeVertices = {}
end

function GraphPort.endShape(self, endKind)
	endKind = endKind or STROKE 
	local npts = #ShapeVertices
	local apts = ffi.new("BLPoint[?]", npts,ShapeVertices)

	if ShapeMode == POLYGON then
		path = BLPath()
		if endKind == CLOSE then
			path:polyTo(apts, npts)

			renderer:fillPath(path)
		elseif endKind == STROKE then
			renderer:strokePath(path)
		end
	elseif ShapeMode == POINTS then
		for i, pt in ipairs(ShapeVertices) do
			point(pt[1], pt[2])
		end
	elseif ShapeMode == LINES then
		-- walk the array of points two at a time
		--[[
		for i=0, npts-2, 2 do
			print("endshape: ", apts[i].x, apts[i].y, apts[i+1].x, apts[i+1].y)
			surface.DC:MoveTo(apts[i].x, apts[i].y)
			surface.DC:LineTo(apts[i+1].x, apts[i+1].y)
		end
		--]]
	elseif ShapeMode == TRIANGLES then
		-- draw triangles
	end

end

function GraphPort.vertex(self, ...)
	local nargs = select('#',...)

	if not ShapeVertices or nargs < 2 then
		return false;
	end
	
	table.insert(ShapeVertices, {select(1,...),select(2,...)})

	return true;

--[[
	local x = nil
	local y = nil
	local z = nil
	local u = nil
	local v = nil

	if (nargs == 2) then
		x = select(1,...)
		y = select(2,...)
		z = 0
	elseif (nargs == 3) then
		x = select(1,...)
		y = select(2,...)
		z = select(3,...)
	elseif arg.n == 4 then
		x = arg[1]
		y = arg[2]
		u = arg[3]
		v = arg[4]
	elseif arg.n == 5 then
		x = arg[1]
		y = arg[2]
		z = arg[3]
		u = arg[4]
		v = arg[5]
	end


	if u and v then
		-- texture coordinate
	end

	if x and y and z then
		gl.vertex(x,y,z)
	end
--]]

end


function GraphPort.bezierVertex(self)
end

function GraphPort.curveVertex(self)
end



function GraphPort.texture(self)
end

function GraphPort.textureMode(self)
end



--[==============================[
	TRANSFORM
--]==============================]

-- Matrix Stack
function GraphPort.popMatrix(self)
	
end

function GraphPort.pushMatrix(self)
	
end

function GraphPort.applyMatrix(self)
end

function GraphPort.resetMatrix(self)
end

function GraphPort.printMatrix(self)
end


-- Simple transforms
function GraphPort.translate(self, x, y, z)
	return renderer:translate(x, y);
end

function GraphPort.rotate(self, rads)
	return renderer:rotate(rads)
end

function GraphPort.rotateX(self, rad)
end

function GraphPort.rotateY(self, rad)
end

function GraphPort.rotateZ(self, rad)
end

function GraphPort.scale(self, sx, sy, sz)
	
end

function GraphPort.shearX(self)
end

function GraphPort.shearY(self)
end



--[==============================[
	TYPOGRAPHY
--]==============================]

function GraphPort.createFont(self)
end



function GraphPort.textSize(self, asize)
	aFont, err = appFontFace:createFont(asize)
	if not aFont then 
		return false;
	end

	appFont = aFont
	TextSize = asize

	return true;
end

local function calcTextPosition(txt, x, y)
	if TextHAlignment == LEFT then
		x = x
	elseif TextHAlignment == CENTER then
		local cx = textWidth(txt)
		x = x - (cx/2)
	elseif TextHAlignment == RIGHT then
		local cx = textWidth(txt)
		x = x - cx;
	end

	return x, y
end

function GraphPort.text(self, txt, x, y)
	local x, y = calcTextPosition(txt, x, y)
	renderer:fillUtf8Text(BLPoint(x,y), appFont, txt, #txt)
end

-- Attributes

function GraphPort.textAlign(self, halign, valign)
	TextHAlignment = halign or LEFT
	TextVAlignment = valign or TOP
end

function GraphPort.textLeading(self, leading)
	TextLeading = leading
end

function GraphPort.textMode(self, mode)
	TextMode = mode
end



-- measure how wide a piece of text is
function GraphPort.textWidth(self, txt)
	return appFont:measureText(txt)
end

function GraphPort.textFont(self, fontname)
	return Processing.Renderer:SetFont(fontname);
	--return Processing.SetFontName(fontname)
end

-- Metrics

function GraphPort.textAscent(self)
    return false;
end

function GraphPort.textDescent(self)
    return false;
end


--[==============================[
	ENVIRONMENT
--]==============================]

function GraphPort.cursor(self)
end

function GraphPort.noCursor(self)
end

function GraphPort.frameRate(self, rate)
	FrameRate = rate
end




--[==============================[
	IMAGE
--]==============================]
function GraphPort.createImage(self, awidth, aheight)
    return BLImage(awidth, aheight)
end

-- Loading and Displaying

--[[
    copy one pixel buffer to another
    without any blending operation

    need to do clipping
]]
function GraphPort.image(self, img, dstX, dstY, awidth, aheight)
	if not img then
		return false, 'no image specified'
	end

end

function GraphPort.imageMode(self)
end


function GraphPort.requestImage(self)
end

function GraphPort.tint(self)
end

function GraphPort.noTint(self)
end

-- Pixels
function GraphPort.blend(self)
end

function GraphPort.copy(self)
end

function GraphPort.filter(self)
end

function GraphPort.get(self, x, y)
	return color(r,g,b)
end

function GraphPort.set(self, x,y,c)
end

function GraphPort.loadPixels(self)
end

function GraphPort.pixels(self)
end

function GraphPort.updatePixels(self)
end

return GraphPort