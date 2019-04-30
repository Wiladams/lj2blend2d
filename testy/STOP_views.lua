
local GStructureRecursion = require("GStructureRecursion")

local function app(params)
    local win1 = WMCreateWindow(params.x,params.y, params.width, params.height)

    local gr1 = GStructureRecursion:new({width = 320, height=240})

    win1:add(gr1)
    win1:show()

    while true do
        win1:draw()
        yield();
    end
end

return app