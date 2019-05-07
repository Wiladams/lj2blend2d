
local GImage = require("GIMage")


local function app(params)
    print("STOP_circle")
    local win1 = WMCreateWindow(params.x, params.y, params.width, params.height)

    local img, err = GImage:createFromFile("resources/heic1501b.jpg")
    local subimg = img:subImage(0,0,16,16)
    
    function win1.drawBody(self, ctxt)
        local dstRect = BLRect(0,0,params.width, params.height)
        local imgArea = BLRectI(0,0,img.Frame.w, img.Frame.h)

        ctxt:stretchBlt(dstRect, img.image, imgArea)

        local subArea = BLRectI(mouseX, mouseY, 16,16)
        local subDst = BLRect(mouseX, mouseY, 128, 128)
        ctxt:stretchBlt(subDst, img.image, subArea)
    end

    win1:show()

    while true do
        win1:draw()
        yield();
    end
end

return app