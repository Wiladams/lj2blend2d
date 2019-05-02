Although this is just the test environment for the blend2d luajit binding, there are several concepts
being exercised and implemented as well.

C classic interface
Lua Objects
STOP
P5





STOP - Simple Type Of Program

A STOPlet is an 'application'.  It will typically put up a window, and have a continuous execution loop.
This will run as a task in the scheduler environment executed with a 'spawn()' call.  A typical STOPlet looks like:

```lua
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
```