package.path = "../?.lua;"..package.path;

local winman = require("WinMan")

local function startup()
    print("startup")
    local win1 = createWindow(10,10, 300, 200)

    win1:show()
    win1:background(BLRgba32(0xff00ff00))
    win1:draw()
end

winman {width = 1200, height=1024, startup = startup}