-- A graphic image
-- Basically has a size and image

local GImage = {}
local GImage_mt = {
    __index = GImage;
}


function GImage.new(self, obj)
    if not obj then return nil end

    -- must have width, height, and image
    if not obj.image then
        return nil, 'must specify at least image'
    end

    obj.x = obj.x or 0
    obj.y = obj.y or 0
    obj.imageArea = obj.imageArea or BLRectI({0,0,obj.image:size().w, obj.image:size().h})
    obj.Frame = obj.Frame or BLRect({0,0,obj.width, obj.height})

    setmetatable(obj, GImage_mt)

    return obj;
end

function GImage.draw(self, ctx)
    --print("Gimage.draw")
    ctx:stretchBlt(self.Frame, self.image, self.imageArea)
end

return GImage
