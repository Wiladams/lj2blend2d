
local GImage = require("GIMage")
local maths = require("maths")
local map = maths.map

local function app(params)
    print("STOP_mag")
    local img, err = GImage:createFromFile("resources/heic1501b.jpg")
--print("STOP_mag, createFromFile: ", img, err)

    local win1 = WMCreateWindow(params)
   
    function win1.mouseMove(self, event)
        --print("win1, mouse: ", event.activity, event.x, event.y)
        -- BUGBUG - need to account for the fact that the image itself could be scaled
        local x = map(event.x, 0,self.frame.width, 0, img.width)
        local y = map(event.y, 0, self.frame.height, 0,img.height)
        self.subArea = BLRectI(x, y, 16,16)
        self.subDst = BLRect(event.x, event.y, 256, 256)
    end

    function win1.drawForeground(self, ctxt)
        local dstRect = BLRect(0,0,self.frame.width, self.frame.height)
        local imgArea = BLRectI(0,0,img.frame.w, img.frame.h)

        ctxt:stretchBlt(dstRect, img.image, imgArea)

        if self.subDst then
            ctxt:stretchBlt(self.subDst, img.image, self.subArea)
        end
    end

    win1:show()

    while true do
        win1:draw()
        yield();
    end
end

return app