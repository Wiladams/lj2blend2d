--[[
    Graphic

    A drawable with a boundary and a frame.  Whereas a Drawable does not
    impose any constraints, a graphic has a distinct boundary/size.

    This allows graphics to be utilized in layout schemese whereas a simple
    Drawable cannot.

    The difference between frame and bounds is, the frame determines the space
    the graphic takes up within the context of it's parent.  The bounds are the 
    internal size of the graphic.  In most cases these will likely be the same,
    with the exception that the bounds will likely have an x,y origin of 0,0
    whereas the x,y of the frame are a position within the parent.


]]
local Drawable = require("Drawable")

local Graphic = {}
setmetatable( Graphic, 
    { __index = Drawable } 
)

local Graphic_mt = {
    __index = Graphic
}

function Graphic.new(self, obj)
    obj = Drawable:new(obj)
    setmetatable(obj, Graphic_mt)
    return obj;
end


return Graphic