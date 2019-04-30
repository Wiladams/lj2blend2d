--[[
    Graphic

    A drawable with a boundary and a frame.  Whereas a Drawable does not
    impose any constraints, a graphic has a distinct boundary/size.

    This allows graphics to be utilized in layout schemese whereas a simple
    Drawable cannot.
]]
local Drawable = require("Drawable")

local Graphic = Drawable:new()
Graphic.__index = Graphic


return Graphic