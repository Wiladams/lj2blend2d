
local GImage = require("GIMage")


local function app(params)
    print("STOP_mag")
    local img, err = GImage:createFromFile("resources/heic1501b.jpg")
print("STOP_mag, createFromFile: ", img, err)

    local win1 = WMCreateWindow(params)
   
    function win1.mouseMove(self, event)
        --print("win1, mouse: ", event.activity, event.x, event.y)
        -- BUGBUG - need to account for the fact that the image itself could be scaled
        self.subArea = BLRectI(event.x, event.y, 32,32)
        self.subDst = BLRect(event.x, event.y, 128, 128)
    end

    function win1.drawForeground(self, ctxt)
        local dstRect = BLRect(0,0,self.frame.width, self.frame.height)
        local imgArea = BLRectI(0,0,img.Frame.w, img.Frame.h)

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