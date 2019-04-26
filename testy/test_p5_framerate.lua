package.path = "../?.lua;"..package.path;

require("p5")
local stats = require("p5ui.P5Status")()

function setup()
    background(0xff, 0x20, 0x20)
    clear();
end

function draw()
    stats:draw()
end

go({frameRate=100})
