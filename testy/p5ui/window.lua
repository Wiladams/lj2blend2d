local Drawable = require("p5ui.Drawable")

local Window = Drawable:new()

function Winodw.new(self, obj)
    obj = obj or {}

    obj.isShown = false;
    
    setmetatable(obj, self)
    self.__index = self;

    return obj;
end

function Window.Show()
    isShown = true;
end



