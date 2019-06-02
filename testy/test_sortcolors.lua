--[[
    Consume svg colors, generate a list of colors sorted by luminance

    Change the order of l1 > l2 in the orderByBrightness function 
    to change from white/black to black/whate
]]
local spairs = require("spairs")
local svgcolors = require("svgcolors")
local coloring = require("coloring")
local luma = coloring.luma

local function orderByBrightness(t, a, b)
    local l1 = luma(t[a])
    local l2 = luma(t[b])

    return l1 > l2
end

print("return {")
for k,v in spairs(svgcolors, orderByBrightness) do
    print (string.format("{name = '%s', value = {%d, %d, %d}};", k,v[1], v[2],v[3]))
end
print("};")