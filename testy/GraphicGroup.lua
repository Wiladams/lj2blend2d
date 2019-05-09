local Drawable = require("Drawable")

local GraphicGroup = Drawable:new()


function GraphicGroup.new(self, obj)
    obj = obj or {}

    obj.frame = obj.frame or {x=0,y=0,width=0,height=0};
    obj.children = {};

    setmetatable(obj, self)
    self.__index = self;

    return obj;
end

function GraphicGroup.add(self, child, after)
    table.insert(self.children, child)
end

function GraphicGroup.drawChildren(self, ctxt)
    -- draw all the children
    for _, child in ipairs(self.children) do 

        -- set clip area to child
        -- translate the context to the child's frame
        child:draw(ctxt)

        -- untranslate
        -- unclip
    end
end


function GraphicGroup.draw(self, dc)
    self:drawBegin(dc)
    self:drawChildren(dc)
    self:drawBody(dc)
    self:drawEnd(dc)
end

return GraphicGroup

