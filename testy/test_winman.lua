package.path = "../?.lua;"..package.path;

local winman = require("WinMan")


local function startup()
    print("startup")
    local win1 = WMCreateWindow(100,100, 320, 240)

    function win1.drawBody(self, ctxt)
        print("win1:drawBody(): ", self, ctxt)

        self.DC:fill(255,0,0)
        self.DC:fillEllipse(150, 100, 75,75)
    end

    win1:show()
    --win1:background(BLRgba32(0xff00ff00))
    win1:draw()
end

winman {width = 1200, height=1024, startup = startup}