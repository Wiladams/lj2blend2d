
local function app(params)
    local win1 = WMCreateWindow(params)

    function win1.drawForeground(self, ctxt)
        --print("win1:drawForeground(): ", self, ctxt)
        ctxt:noStroke()
        ctxt:fill(255,0,0)
        ctxt:circle(self.frame.width/2, self.frame.height/2, self.frame.height/2)
    end

    win1:show()

    while true do
        win1:draw()
        yield();
    end
end

return app