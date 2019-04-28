
--[[
    These are functions that are globally available, so user code
    can use them.  These functions don't rely specifically on the 
    drawing interface, so they can remain here in case the drawing
    driver changes.
]]

--[[
    MATHS
]]

-- Global things
-- Constants
HALF_PI = math.pi / 2
PI = math.pi
QUARTER_PI = math.pi/4
TWO_PI = math.pi * 2
TAU = TWO_PI

-- angleMode
DEGREES = 1;
RADIANS = 2;

function lerp(low, high, x)
    return low + x*(high-low)
end

function mag(x, y)
    return sqrt(x*x +y*y)
end

function map(x, olow, ohigh, rlow, rhigh, withinBounds)
    rlow = rlow or olow
    rhigh = rhigh or ohigh
    local value = rlow + (x-olow)*((rhigh-rlow)/(ohigh-olow))

    if withinBounds then
        value = constrain(value, rlow, rhigh)
    end

    return value;
end

--[[
function noise(x,y,z)
    if z ~= nil then
        return simplex.Noise3(x,y,z)
    end

    if y and z ~= nil then
        return simplex.Noise2(x,y)
    end

    if x ~= 0 then 
        return simplex.Noise1(x)
    end

    return 0
end
--]]

function sq(x)
    return x*x
end

abs = math.abs
asin = math.asin
acos = math.acos
atan = math.atan

function atan2(y,x)
    return atan(y/x)
end

ceil = math.ceil

function constrain(x, low, high)
    return math.min(math.max(x, low), high)
end
clamp = constrain
cos = math.cos

degrees = math.deg

function dist(x1, y1, x2, y2)
    return math.sqrt(sq(x2-x1) + sq(y2-y1))
end

exp = math.exp
floor = math.floor
log = math.log
max = math.max
min = math.min

function norm(val, low, high)
    return map(value, low, high, 0, 1)
end

function pow(x,y)
    return x^y;
end

radians = math.rad
random = math.random

function round(n)
	if n >= 0 then
		return floor(n+0.5)
	end

	return ceil(n-0.5)
end

sin = math.sin
sqrt = math.sqrt
