package.path = "../?.lua;"..package.path;

require("p5")

local path = BLPath();

function setup()
    path:moveTo(10, 10)
    path:lineTo(200, 10)
    path:lineTo(200, 200)
    path:lineTo(10, 200)
    --path:close();

    fill(0x00)
    stroke(0xff, 0,0)
    
    background(0xCC)
end

function draw()
    appContext:fillPath(path)
    appContext:strokePathD(path)
end

go()
