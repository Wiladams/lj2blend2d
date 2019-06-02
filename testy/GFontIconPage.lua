local GraphicGroup = require("GraphicGroup")
local GFontFaceIcon = require("GFontFaceIcon")
local FontMonger = require("FontMonger")

local GFontIconPage = {}
setmetatable( GFontIconPage, 
    { __index = GraphicGroup } 
)
local GFontIconPage_mt = {
    __index = GFontIconPage;
}

function GFontIconPage.getPreferredSize()
    -- unbounded in y direction
    return {width = 160 * 8}
end

function GFontIconPage.new(self, obj)
    obj = GraphicGroup:new(obj)
--print("GFontIconPage.new: ", obj, obj.frame.width, obj.frame.height)

    obj.fontMonger = obj.fontMonger or FontMonger:new();

    setmetatable(obj, GFontIconPage_mt)

    obj:setup()

    return obj
end


function GFontIconPage.setup(self)


    local column = 1;
    local maxColumn = 10;
    local columnGap = 20;

    local row = 1;
    local maxRow = 8;

    local size = GFontFaceIcon:getPreferredSize()

    -- enumerate the fonts, creating icons for each
    for familyName, family in self.fontMonger:families() do
        -- create an icon
        local icon, err = GFontFaceIcon:new({familyName = familyName, fontMonger = self.fontMonger})

        --icon.frame.x = (column-1) * (size.width+columnGap);
        --icon.frame.y = (row-1) * size.height;
        icon:moveTo((column-1) * (size.width+columnGap), (row-1) * size.height)

        --print("create icon: ", familyName, icon, icon.frame.x, icon.frame.y, icon.frame.width, icon.frame.height)

        -- add it to list of children
        self:add(icon)

        -- adjust row and column coordinates
        column = column + 1;
        if column > maxColumn then
            column = 1;
            row = row + 1;
        end

        if row > maxRow then
            break;
        end
    end
end


return GFontIconPage
