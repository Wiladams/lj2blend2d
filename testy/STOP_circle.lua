
local function app(params)
    print("STOP_circle")
    local win1 = WMCreateWindow(params)

    function win1.drawForeground(self, ctxt)
        --print("win1:drawForeground(): ", self, ctxt)
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