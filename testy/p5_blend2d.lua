--[[
    This must be required by p5.lua, do not use it directly
	as it utilizes globals found in there.
	
	--transparency and GDI
	https://parnassus.co/transparent-graphics-with-pure-gdi-part-2-and-introducing-the-ttransparentcanvas-class/

]]

local ffi = require("ffi")
local C = ffi.C

local b2d = require("blend2d.blend2d")


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


local solidBrushes = {}
local solidPens = {}
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

local function getFont(name, size)
--[=[
	local namecache = fontCache[name];
	if namecache then
		local afont = namecache[size]
		if afont then
			return afont
		end
	else
		namecache = {}
		fontCache[name] = namecache
	end

	-- create a new font of the specified size
	--[[
	local afont = ffi.C.CreateFontA(  int cHeight,  int cWidth,  int cEscapement,  int cOrientation,  int cWeight,  DWORD bItalic,
	DWORD bUnderline,  DWORD bStrikeOut,  DWORD iCharSet,  DWORD iOutPrecision,  DWORD iClipPrecision,
	DWORD iQuality,  DWORD iPitchAndFamily,  LPCSTR pszFaceName);
--]]
	local cHeight = size;
	local cWidth = 0;
	local cEscapement = 0;
	local cOrientation = 0;
	local cWeight = ffi.C.FW_BOLD;
	local bItalic = 0;
	local bUnderline = 0;
	local bStrikeOut = 0;
	local iCharSet = 0;
	local iOutPrecision = 0;
	local iClipPrecision = 0;
	local iQuality = 2;
	local iPitchAndFamily = 0;
	local pszFaceName = name
	local afont = ffi.C.CreateFontA(cHeight, cWidth, cEscapement, cOrientation,  cWeight,  bItalic,
	bUnderline,  bStrikeOut,  iCharSet,  iOutPrecision,  iClipPrecision,
	iQuality,  iPitchAndFamily,  pszFaceName);
	
	-- add it to the name cache
	namecache[size] = afont;

	return afont;
--]=]
end

local function solidBrush(c)
	local abrush = false;
	
	abrush = solidBrushes[tonumber(c.cref)]
	--print("solidBrush: ", c.cref, abrush)
	
	if abrush then
		return abrush, c;
	end

	abrush = ffi.C.CreateSolidBrush(c.cref);
	solidBrushes[tonumber(c.cref)] = abrush;

	return abrush, c;
end

local function solidPen(...)
	local c = select(1, ...)
	if type(c) ~= "cdata" then
		c = color(...)
	end
	
	local apen = solidPens[tonumber(c.cref)]

	if apen then
		return apen, c
	end


	apen = ffi.C.CreatePen(ffi.C.PS_SOLID, StrokeWidth, c.cref);
	if not apen then 
		return false, 'could not create solid pen'
	end

	solidPens[tonumber(c.cref)] = apen

	return apen, c
end


function colorMode(amode)
	-- if it's not valid input, just return
	if amode ~= RGB and amode ~= HSB then 
		return 
	end
	ColorMode = amode;

	return true;
end

function clear()
    appContext:save()
    appContext:setFillStyle(BackgroundColor)
    appContext:fillAll();
    appContext:restore();
end

function background(...)
	local n = select('#', ...)
	local c = select(1,...)
	if type(c) ~= "cdata" then
		c = color(...)
	end

	BackgroundColor = c;

    clear();
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


function fill(...)
	local c = select(1,...)

	if type(c) ~= "cdata" then
		c = color(...)
	end

	FillColor = c;
    appContext:setFillStyle(FillColor)

	return true;
end

function noFill()
    FillColor = BLRgba32({0,0,0,0})
    appContext:setFillStyle(FillColor)

	return true;
end



function stroke(...)
	local c = select(1, ...)

	if type(c) ~= "cdata" then
		c = color(...)
	end

	StrokeColor = c;
    appContext:setStrokeStyle(StrokeColor)

	return true;
end

function noStroke()
	StrokeColor = BLRgba32({0,0,0,0})
    appContext:setStrokeStyle(StrokeColor)

	return true;
end


--[[
	Actual drawing
]]
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
	local npts = #pts
	local apts = ffi.new("POINT[?]", npts,pts)
	--local res = surface.DC:Polygon(apts, npts)
end

function polyline(pts)
	local npts = #pts
	local apts = ffi.new("POINT[?]", npts,pts)
	--local res = surface.DC:Polyline(apts, npts)
end

function quad(x1, y1, x2, y2, x3, y3, x4, y4)
	local pts = ffi.new("POINT[4]", {{x1,y1},{x2,y2},{x3,y3},{x4,y4}})
	polygon(pts)
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
        appContext:fillRectD(x1, y1, rwidth, rheight)
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

	if FillColor then
		appContext:fillEllipse(cx, cy, rx, ry)
	end
	
	if StrokeColor then
		local bResult, err = appContext:strokeEllipse(cx, cy, rx, ry)
	end

	return true
end

--[====================================[
--	Curves
--]====================================]

function bezier(x1, y1,  x2, y2,  x3, y3,  x4, y4)

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

-- ATTRIBUTES
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

function rotate(rads)
	return appContext:rotate(rads)
end

function rotateX(rad)
end

function rotateY(rad)
end

function rotateZ(rad)
end

function scale(sx, sy, sz)
	
end

function shearX()
end

function shearY()
end



--[==============================[
	TYPOGRAPHY
--]==============================]

function createFont()
end

function loadFont()
end

function text(txt, x, y)
	surface.DC:Text(txt, x, y);
	--surface.DC:ExtTextOutA(  HDC hdc,  int x,  int y,  UINT options,  const RECT * lprect,  LPCSTR lpString,  UINT c,  const INT * lpDx)
end

-- Attributes

function textAlign(halign, valign)
	TextHAlignment = halign or LEFT
	TextVAlignment = valign or TOP

end

function textLeading(leading)
	TextLeading = leading
end

function textMode(mode)
	TextMode = mode
end

function textSize(asize)
	TextSize = asize
	FontName = "SYSTEM_FIXED_FONT"
	local afont = getFont(FontName, asize)
	if not afont then
		return false, 'could not find font'
	end

	surface.DC:SelectObject(afont);
end

function textWidth(txt)
	twidth, theight = Processing.Renderer:MeasureString(txt)
	return Processing.GetTextWidth(astring)
end

function textFont(fontname)
	return Processing.Renderer:SetFont(fontname);
	--return Processing.SetFontName(fontname)
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

-- Loading and Displaying

--[[
    copy one pixel buffer to another
    without any blending operation

    need to do clipping
]]
function image(img, dstX, dstY, awidth, aheight)
	if not img then
		return false, 'no image specified'
	end

	--print("image(), img.width, img.height: ", img.Width, img.Height)
	--print("  width, height: ", width, height)
--	surface.DC:StretchBlt(img, dstX, dstY,awidth,aheight)
---[=[
	-- need to do some clipping
	dstX = dstX or 0
	dstY = dstY or 0

	-- find intersection of two rectangles
	local r1 = Rectangle(dstX, dstY, img.Width, img.Height)
	local r2 = Rectangle(0,0, width, height)
	local visible = r2:intersection(r1)
	
	--print("image: ", src.Width, src.Height)
	local pixelPtr = ffi.cast("struct Pixel32 *", surface.pixelData.data)
    for y= 0, img.Height-1 do
		for x=0, img.Width-1 do
			if visible:contains(x,y) then
				local c = img:get(x,y)
            	--set(dstX+x, dstY+y, c)
				pixelPtr[y*width+x].cref = c.cref
			end
        end
	end

--]=]
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
	local cref = surface.DC:GetPixel(x,y)
	local r = wingdi.GetRValue(cref)
	local g = wingdi.GetGValue(cref)
	local b = wingdi.GetBValue(cref)
	return color(r,g,b)
end

function set(x,y,c)
	surface.DC:SetPixel(x, y, c.cref)
end

function loadPixels()
end

function pixels()
end

function updatePixels()
end
