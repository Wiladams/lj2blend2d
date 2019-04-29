package.path = "../?.lua;"..package.path;

local winman = require("WinMan")


local function startup()
    print("startup")
    local win1 = WMCreateWindow(0,0, 300, 200)

    function win1.drawBegin(self, ctxt)
        print("win1:drawBegin(): ", self, ctxt)
        self.DC:setFillStyle(WMColor(0x255,0,0))
        self.DC:fillCircle(150, 100, 75)
    end

    --win1:show()
    --win1:background(BLRgba32(0xff00ff00))
    win1:draw()
end

winman {width = 1200, height=1024, startup = startup}