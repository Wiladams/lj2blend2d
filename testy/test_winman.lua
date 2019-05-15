package.path = "../?.lua;"..package.path;

local winman = require("WinMan")


local function startup()
    --print("startup")
    local win1 = WMCreateWindow({frame={x=100,y=100, width=320, height=240}})

    function win1.drawForeground(self, ctx)
        ctx:fill(255,0,0)
        ctx:fillEllipse(150, 100, 75,75)
    end

    win1:show()
    --win1:draw()
end

winman {width = 1200, height=1024, startup = startup}