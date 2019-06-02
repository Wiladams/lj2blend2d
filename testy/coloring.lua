--[[
	Convert to luminance using ITU-R Recommendation BT.709 (CCIR Rec. 709)
	This is the one that matches modern HDTV and LCD monitors
    This is a simple 'grayscale' conversion
    c[1] = red
    c[2] = green
    c[3] = blue
--]]
local function lumaBT709(r,g,b)

    if type(r) == "table" then
        local lum = (0.2125 * r[1]) + (0.7154 * r[2]) + (0.0721 * r[3])
        return lum
    end

    lum = (0.2125 * r) + (0.7154 * g) + (0.0721 * b)

	return lum;
end

return {
    luma = lumaBT709
}