-- A graphic image
-- Basically has a size and image
require("blend2d.blend2d")

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
    obj.width = obj.width or obj.image:size().w
    obj.height = obj.height or obj.image:size().h
    obj.imageArea = obj.imageArea or BLRectI({obj.x,obj.y,obj.width, obj.height})
    obj.frame = obj.frame or BLRect({0,0,obj.width, obj.height})

    setmetatable(obj, GImage_mt)

    return obj;
end

function GImage.createFromFile(self, filename)
    local img, err = BLImageCodec:readImageFromFile(filename)
    if not img then
        return nil, err
    end

    return GImage:new({image = img, frame = BLRect({0,0,img:size().w, img:size().h})})
end

--[[
    Sets where the image will be displayed within the context
    of the graphics context
]]
function GImage.setFrame(self, x,y,width,height)
    self.frame = BLRect({x,y,width, height})
    
    return self;
end

function GImage.moveTo(self, x, y)
    self.frame.x = x;
    self.frame.y = y;
end

function GImage.draw(self, ctx)
    --print("Gimage.draw")
    ctx:stretchBlt(self.frame, self.image, self.imageArea)
end

function GImage.moveTo(self, x, y)
    self.frame.x = x;
    self.frame.y = y;
end

function GImage.subImage(self, x,y,w,h)
    local imageArea = BLRectI(x,y,w,h)
    GImage:new({image = self.image, width = w, height = h, imageArea = imageArea})
end

return GImage
