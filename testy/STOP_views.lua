--[[
    This STOPlet takes the blend2d 'getting started' graphics and displays
    them as individual graphics, with some scaling and positioning
]]
local GS = require("GGettingStarted")

local graphics = {
    GS.GS1:new();
    GS.GS2:new();
    GS.GS3:new();
    GS.GS4:new();
    GS.GS5:new();
    GS.GS6:new({width =480, height=480});
    GS.GS7:new();
}

local function app(params)
    local win1 = WMCreateWindow(params)
    

    function win1:drawForeground(dc)
        for i, g in ipairs(graphics) do
            --print(i,g)
            dc:push()
            dc:translate(16,100*(i-1))
            dc:scale(0.2, 0.2)
            g:draw(dc)
            dc:pop()
        end
    end

    win1:show()

    while true do
        win1:draw()
        yield();
    end
end

return app