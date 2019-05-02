
local function app(params)
    print("STOP_circle")
    local win1 = WMCreateWindow(params.x, params.y, params.width, params.height)

    function win1.drawBody(self, ctxt)
        --print("win1:drawBody(): ", self, ctxt)
        ctxt:noStroke()
        ctxt:fill(255,0,0)
        ctxt:circle(150, 100, 75)
    end

    win1:show()

    while true do
        win1:draw()
        yield();
    end
end

return app