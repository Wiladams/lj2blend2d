--[[
    This STOPlet takes the blend2d 'getting started' graphics and displays
    them as individual graphics, with some scaling and positioning
]]
local GS = require("GGettingStarted")

local graphics = {
    GS.GS1:new();
    GS.GS6:new({width =480, height=480});
}

local function app(params)
    local win1 = WMCreateWindow(params.x,params.y, params.width, params.height)
    

    function win1:drawBody(dc)
        for i, g in ipairs(graphics) do
            --print(i,g)
            dc:push()
            dc:translate(16,100*(i-1))
            dc:scale(0.2, 0.2)
            g:draw(dc)
            dc:pop()
        end
    end


    --win1:add(gs1)
    --win1:add(gs6)

    win1:show()

    while true do
        win1:draw()
        yield();
    end
end

return app