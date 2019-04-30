
local function app(params)
    print("STOP_circle")
    local win1 = WMCreateWindow(params.x, params.y, params.width, params.height)

    function win1.drawBody(self, ctxt)
        --print("win1:drawBody(): ", self, ctxt)

        ctxt:fill(255,0,0)
        ctxt:fillEllipse(150, 100, 75,75)
    end

    win1:show()
    win1:draw()
    while true do
        win1:draw()
        yield();
    end
end

return app