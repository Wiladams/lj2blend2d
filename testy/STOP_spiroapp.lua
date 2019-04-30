local SpiroGraphic = require("SpiroGraphic")

local function spiroapp(params)
    local win1 = WMCreateWindow(params.x,params.y, params.width, params.height)

    local spg = SpiroGraphic:new({width = params.width, height=params.height})

    win1:add(spg)
    win1:show()

    while true do
        win1:draw()
        yield();
    end
end

return spiroapp