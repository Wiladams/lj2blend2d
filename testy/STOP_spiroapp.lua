local SpiroGraphic = require("SpiroGraphic")

local function app(params)
    local win1 = WMCreateWindow(params)

    local spg = SpiroGraphic:new(params.frame)

    win1:add(spg)
    win1:show()

    while true do
        win1:draw()
        yield();
    end
end

return app