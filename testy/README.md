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

    function win1.drawForeground(self, ctxt)
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

A STOPlet is run in an environment that includes a scheduler and window manager.  That environment typically looks like this:

```lua
package.path = "../?.lua;"..package.path;

local winman = require("WinMan")

local circleapp = require("STOP_circle")


local function startup()
    spawn(circleapp, {x=10, y=10, width=320, height=240})
end

winman {width = 640, height=480, startup = startup}
```

The "WinMan" file is the critical one in that it creates the "Windows", provides the UI events, and includes the scheduler which makes spawning and signaling trivial.

There is a convencient file: test_STOP
Which can be used to launch any STOPlet individually, and trivially.

c:\> luajit test_BEST BEST_circle

The idea behind WinMan is that it provides a 'desktop' environment.  Ideally, there would be a STOPlet which configured a basic desktop with the ability to launch other stoplets from within the desktop environment.  A simple search bar, or a file browser would probably be a good first addition to the desktop space.

References


https://skia.org/user/api/SkBlendMode_Reference
