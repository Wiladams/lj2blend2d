--[[]
    Drawable 
    Base class for anything that does drawing in the P5 environment

    A 'subclass' can be constructed with:

    MySubClass = Drawable:new()

    From there, you can create instances of the subclass by simply doing:

    myInstance = MySubClass:new()

    myInstance:draw(renderContext)
--]]
local Drawable = {}

function Drawable.new(self, obj)
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self;
    
    return obj;
end

function Drawable.drawBegin(self, ctxt)
end

function Drawable.drawBody(self, ctxt)
end

function Drawable.drawEnd(self, ctxt)
end

function Drawable.draw(self, ctxt)
    self:drawBegin(ctxt)
    self:drawBody(ctxt)
    self:drawEnd(ctxt)
end


return Drawable
