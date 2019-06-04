--[[
    This must be required by p5.lua, do not use it directly
	as it utilizes globals found in there.
	
	--transparency and GDI
	https://parnassus.co/transparent-graphics-with-pure-gdi-part-2-and-introducing-the-ttransparentcanvas-class/

]]

local ffi = require("ffi")
local C = ffi.C

local b2d = require("blend2d.blend2d")

local useStroke = true;
local useFill = true;

-- Stroke Attributes
-- Joint styles
JOIN_MITER_CLIP = 0;
JOIN_MITER_BEVEL = 1;
JOIN_MITER_ROUND = 2;
JOIN_BEVEL = 3;
JOIN_ROUND = 4;

-- Endcap style
CAP_BUTT = 0;
CAP_SQUARE = 1;
CAP_ROUND = 2;
CAP_ROUND_REV = 3;
CAP_TRIANGLE = 4;
CAP_TRIANGLE_REV = 5;


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




--local solidBrushes = {}
--local solidPens = {}
local fontCache ={}			-- cache of fonts

local GlobalPath = nil

local FillColor = BLRgba32({255,255,255,255})
local StrokeColor = BLRgba32({0,0,0,255})

--[==================================================[
		LANGUAGE COMMANDS
--]==================================================]
function push()
    appContext:save()
end

function pop()
    appContext:restore();
end

-- ATTRIBUTES
function blendMode(mode)
	-- set compositing operator
	appContext:setCompOp(mode)
end

-- Modes to be honored by various drawing APIs
function angleMode(newMode)
    if newMode ~= DEGREES and newMode ~= RADIANS then 
        return false 
    end

    AngleMode = newMode;

    return true;
end

function ellipseMode(newMode)
    EllipseMode = newMode;
end

function rectMode(newMode)
    RectMode = newMode;
end

function smooth()
end

function noSmooth()
end

function pointSize(ptSize)
	PointSize = ptSize;
end

function strokeCaps(strokeCap)
	appContext:setStrokeCaps(strokeCap) ;
end

function strokeJoin(join)
    appContext:setStrokeJoin(join)
end

function strokeWeight(weight)
    appContext:setStrokeWidth(weight);
end

function colorMode(amode)
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

function color(...)
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


function blue(c)
	return c.b
end

function green(c)
	return c.g
end

function red(c)
	return c.r
end

function alpha(c)
	return c.a
end

function lerpColor(from, to, f)
	local r = lerp(from.r, to.r, f)
	local g = lerp(from.g, to.g, f)
	local b = lerp(from.b, to.b, f)
	local a = lerp(from.a, to.a, f)
	
	return color(r,g,b,a)
end

function fill(...)
	local c = select(1,...)

	if type(c) ~= "cdata" then
		c = color(...)
	end

	FillColor = c;
    appContext:setFillStyle(FillColor)
	useFill = true;

	return true;
end

function noFill()
	useFill = false;

	return true;
end



function stroke(...)
	local c = select(1, ...)

	if type(c) ~= "cdata" then
		c = color(...)
	end

	StrokeColor = c;
    appContext:setStrokeStyle(StrokeColor)
	useStroke = true;

	return true;
end

function noStroke()
	useStroke = false;

	return true;
end

function clear()
    appContext:save()
    appContext:setFillStyle(BackgroundColor)
    appContext:fillAll();
    appContext:restore();
end

function clip(x, y, w, h)
	appContext:clip(x, y, w, h)
end

function noClip()
	appContext:removeClip()
end

--[[
	Actual drawing
]]


-- The background could be either 
-- a solid color, or an image
-- or even a pattern or gradient
-- Figure out which one it is and display
function background(...)
	local n = select('#', ...)
	local c = select(1,...)
	if type(c) ~= "cdata" then
		c = color(...)
	end

	BackgroundColor = c;

    appContext:setFillStyle(BackgroundColor)
	appContext:fillRectD(BLRect(0,0,width,height))
end

function point(x,y,z)
    -- depending on the stroke width
    -- draw the piont as a circle
	
	return true;
end

function line(...)
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

    appContext:strokeLine(x1,y1,x2,y2)

	return true;
end

function angleArc(x,y,r,startAt, endAt)
end

function triangle(...)
	if FillColor then
		appContext:fillTriangle(...)
	end

	if StrokeColor then
		appContext:strokeTriangle(...)
	end
end

function polygon(pts)
	if useFill then
		appContext:fillPolygon(pts)
	end

	if useStroke then
		appContext:strokePolygon(pts)
	end

end

function polyline(pts)
	local npts = #pts
	local apts = ffi.new("BLPoint[?]", npts,pts)
	--local res = surface.DC:Polyline(apts, npts)
end

function quad(x1, y1, x2, y2, x3, y3, x4, y4)
	polygon({{x1,y1},{x2,y2},{x3,y3},{x4,y4}})
end

local function calcModeRect(mode, ...)
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

function rect(...)
	local nargs = select('#',...)
	if nargs < 4 then return false end

	local x1, y1, rwidth, rheight = calcModeRect(RectMode, ...)

	if nargs == 4 then
		if useFill then
		appContext:fillRectD(BLRect(x1, y1, rwidth, rheight))
		end

		if useStroke then
			appContext:strokeRectD(BLRect(x1, y1, rwidth, rheight))
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

function ellipse(...)
	local nargs = select('#',...)
	if nargs < 3 then return false; end

	
	local cx, cy, rx, ry = calcEllipseParams(EllipseMode, ...)

	if useFill then
		appContext:fillEllipse(cx, cy, rx, ry)
	end
	
	if useStroke then
		local bResult, err = appContext:strokeEllipse(cx, cy, rx, ry)
	end

	return true
end

--[====================================[
--	Curves
--]====================================]

function bezier(x1, y1,  x2, y2,  x3, y3,  x4, y4)
	local path = BLPath()
	path:moveTo(x1, y1)
	path:cubicTo(x2,y2,x3,y3, x4,y4)
	appContext:strokePathD(path)
end

function bezierDetail(...)
end

function bezierPoint(...)
end

-- Catmull - Rom curve
function curve(x1, y1,  x2, y2,  x3, y3,  x4, y4)

end

function curveDetail(...)
end

function curvePoint(...)
end

function curveTangent(...)

end

function curveTightness(...)
end




-- VERTEX
function beginShape(sMode)
	ShapeMode = sMode or POLYGON
	
	-- Start a new array of vertices
	ShapeVertices = {}
end

function endShape(endKind)
	endKind = endKind or STROKE 
	local npts = #ShapeVertices
	local apts = ffi.new("BLPoint[?]", npts,ShapeVertices)

	if ShapeMode == POLYGON then
		path = BLPath()
		if endKind == CLOSE then
			path:polyTo(apts, npts)

			appContext:fillPath(path)
		elseif endKind == STROKE then
			appContext:strokePath(path)
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

function vertex(...)
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


function bezierVertex()
end

function curveVertex()
end



function texture()
end

function textureMode()
end



--[==============================[
	TRANSFORM
--]==============================]

-- Matrix Stack
function popMatrix()
	
end

function pushMatrix()
	
end

function applyMatrix()
end

function resetMatrix()
end

function printMatrix()
end


-- Simple transforms
function translate(x, y, z)
	return appContext:translate(x, y);
end

function rotate(rads, x, y)
	return appContext:rotate(rads, x, y)
end

function rotateX(rad)
end

function rotateY(rad)
end

function rotateZ(rad)
end

function scale(sx, sy)
	if not sy then
		if not sx then
			return false, "no scale specified"
		end
		sy = sx
	end

	appContext:scale(sx, sy)
end

function shearX()
end

function shearY()
end



--[==============================[
	TYPOGRAPHY
--]==============================]

local function getFont(name, size)
end

function createFont()
end

function loadFont(faceFilename)
	local fontDir = "c:\\windows\\fonts\\"
	local fontfile = fontDir..faceFilename;

	aFace, err = BLFontFace:createFromFile(fontfile)
	if not aFace then
		return false, err
	end

	appFontFace = aFace;
end

function textSize(asize)
	aFont, err = appFontFace:createFont(asize)
	if not aFont then 
		return false;
	end

	appFont = aFont
	TextSize = asize

	return true;
end

local function calcTextPosition(txt, x, y)
	local cx, cy = textWidth(txt)

	if TextHAlignment == LEFT then
		x = x
	elseif TextHAlignment == CENTER then
		x = x - (cx/2)
	elseif TextHAlignment == RIGHT then
		x = x - cx;
	end

	if TextVAlignment == TOP then
		y = y + cy;
	elseif TextVAlignment == CENTER then 
		y = y + cy / 2
	elseif TextVAlignment == BASELINE then
		y = y;
	elseif TextVAlignment == BOTTOM then
		y = y;	end
	return x, y
end

function text(txt, x, y)
	local x, y = calcTextPosition(txt, x, y)
	appContext:fillTextUtf8(BLPoint(x,y), appFont, txt, #txt)
end

-- Attributes
function textAlign(halign, valign)
	TextHAlignment = halign or LEFT
	TextVAlignment = valign or BASELINE
end

function textLeading(leading)
	TextLeading = leading
end

function textMode(mode)
	TextMode = mode
end



-- measure how wide a piece of text is
function textWidth(txt)
	return appFont:measureText(txt)
end

function textFont(fontname)
end

-- Metrics

function textAscent()
    return false;
end

function textDescent()
    return false;
end


--[==============================[
	ENVIRONMENT
--]==============================]

function cursor()
end

function noCursor()
end

function frameRate(rate)
	FrameRate = rate
end




--[==============================[
	IMAGE
--]==============================]
function createImage(awidth, aheight)
	local pm = PixelBuffer(awidth, aheight)

	return pm
end

function loadImage(filename)
    local img, err = BLImageCodec:readImageFromFile(filename)

    local img, err = targa.readFromFile(filename)
    if not img then 
        return false, err
    end
    
    return img
end

--[[
    copy one pixel buffer to another
	Using the first method (x,y,width,heigh) will essentially be a
	blt, without any scaling.

	Using the second method, with all parameters allows you to do 
	scaling and choose a subsection of the source.

	image(img, x, y, [width], [height])
	image(img, dx, dy, dWidth, dHeight, sx, sy, [sWidth], [sHeight])
]]
function image(img, dx, dy, dWidth, dHeight, sx, sy, sWidth, sHeight)
	if not img then
		return false, 'no image specified'
	end

	local imgSize = img:size()
	sx = sx or 0
	sy = sy or 0
	sWidth = sWidth or imgSize.w;
	sHeight = sHeight or imgSize.h;

	dWidth = dWidth or sWidth;
	dHeight = dHeight or sHeight;
	dx = dx or 0;
	dy = dy or 0;

	local dstRect = BLRect(dx, dy, dWidth, dHeight)
	local imgArea = BLRectI(sx, sy, sWidth, sHeight)
	appContext:stretchBlt(dstRect, img, imgArea)

	return true;
end

function imageMode()
end


function requestImage()
end

function tint()
end

function noTint()
end

-- Pixels


function blend()
end

function copy()
end

function filter()
end

function get(x, y)
end

function set(x,y,c)
end

function loadPixels()
-- lock get a pointer to the pixels in appImage
end

function pixels()
end

function updatePixels()
-- unlock the pixel pointer
end
