package.path = "../?.lua;"..package.path;

require("p5")

function setup()
    noLoop()
    background(0x70)
end

function draw()
    noFill();
    stroke(255, 102, 0);
    line(85, 20, 10, 10);
    line(90, 90, 15, 80);
    stroke(0, 0, 0);
    bezier(85, 20, 10, 10, 90, 90, 15, 80);
end

go()
