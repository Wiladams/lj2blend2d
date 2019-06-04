
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
local exports = {
    HALF_PI = math.pi / 2;
    PI = math.pi;
    QUARTER_PI = math.pi/4;
    TWO_PI = math.pi * 2;
    TAU = math.pi * 2;

    -- angleMode
    DEGREES = 1;
    RADIANS = 2;
}

function exports.lerp(low, high, x)
    return low + x*(high-low)
end

function exports.mag(x, y)
    return math.sqrt(x*x +y*y)
end

function exports.map(x, olow, ohigh, rlow, rhigh, withinBounds)
    rlow = rlow or olow
    rhigh = rhigh or ohigh
    local value = rlow + (x-olow)*((rhigh-rlow)/(ohigh-olow))

    if withinBounds then
        value = constrain(value, rlow, rhigh)
    end

    return value;
end

function exports.sq(x)
    return x*x
end

exports.abs = math.abs
exports.asin = math.asin
exports.acos = math.acos
exports.atan = math.atan

function exports.atan2(y,x)
    return math.atan(y/x)
end

exports.ceil = math.ceil

function exports.constrain(x, low, high)
    return math.min(math.max(x, low), high)
end
exports.clamp = exports.constrain
exports.cos = math.cos

exports.degrees = math.deg

function exports.dist(x1, y1, x2, y2)
    return math.sqrt(exports.sq(x2-x1) + exports.sq(y2-y1))
end

exports.exp = math.exp
exports.floor = math.floor
exports.log = math.log
exports.max = math.max
exports.min = math.min

function exports.norm(val, low, high)
    return exports.map(value, low, high, 0, 1)
end

function exports.pow(x,y)
    return x^y;
end

exports.radians = math.rad
exports.random = math.random

function exports.round(n)
	if n >= 0 then
		return floor(n+0.5)
	end

	return ceil(n-0.5)
end

exports.sin = math.sin
exports.sqrt = math.sqrt

setmetatable(exports, {
    -- globalize
    __call = function(self, tbl)
        tbl = tbl or _G

        for k,value in pairs(self) do
            tbl[k] = value
            --table.rawinsert(tbl, k, v)
        end
    end
})

return exports