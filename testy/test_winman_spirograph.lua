package.path = "../?.lua;"..package.path;

local winman = require("WinMan")
local SpiroGraphic = require("SpiroGraphic")

local function startup()

    local win1 = WMCreateWindow(100,100, 640, 480)
    -- a spirograph graphic
    local spg = SpiroGraphic:new({width = 640, height=480})

    win1:add(spg)

    win1:show()

    while true do
        win1:draw()
        yield();
    end
end

winman {width = 1200, height=1024, startup = startup}