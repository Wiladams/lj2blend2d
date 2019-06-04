local GLogLines = require("GLogLines")

local function app(params)
    local win1 = WMCreateWindow(params)
    local plane = GLogLines:new(params)


    function win1.drawBackground(self, ctx)
        ctx:setFillStyle(BLRgba32(0xFFF0F0A0))
        ctx:fillAll();
        
        ctx:fill(0xA0, 0xF0, 0xF0)    -- sky
        ctx:noStroke();
        ctx:rect(0,0,self.frame.width,(self.frame.height/2)-20)


    end

    win1:add(plane)
    win1:show()

    local function drawproc()
        win1:draw()
    end

    periodic(1000/30, drawproc)
end

return app