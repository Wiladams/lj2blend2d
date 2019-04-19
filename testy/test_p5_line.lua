package.path = "../?.lua;"..package.path;

require("p5")

function setup()
    background(0x80)
end

function draw()
    line(10,10, 200,200)
end

go()
