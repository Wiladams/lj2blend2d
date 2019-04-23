--[[]
    Drawable 
    Base class for anything that does drawing in the P5 environment

    A 'subclass' can be constructed with:

    MySubClass = Drawable:new()

    From there, you can create instances of the subclass by simply doing:

    myInstance = MySubClass:new()

    myInstance:draw(renderContext)
--]]
local Drawable = {
    -- a bounding box expressed in the coordinates of
    -- an enclosing graphic if exists
    Frame = {x = 0; y = 0; width = 1; height = 1;};
}

function Drawable.new(self, obj)
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self;
    return obj;
end

function Drawable:drawBegin()
end

function Drawable:drawBody()
end

function Drawable:drawEnd()
end

function Drawable:draw(renderContext)
    self:drawBegin(renderContext)
    self:drawBody(renderContext)
    self:drawEnd(renderContext)
end


return Drawable
