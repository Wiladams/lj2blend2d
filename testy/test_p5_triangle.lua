package.path = "../?.lua;"..package.path;

require("p5")

function setup()
    background(0x80)
    fill(0,0,255)
    stroke(255,255,255)

    noLoop()
end

function draw()
    triangle(10,10, 200,200, 100,200)
end

go()