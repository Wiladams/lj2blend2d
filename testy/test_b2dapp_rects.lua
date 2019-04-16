package.path = "../?.lua;"..package.path;

require("b2dapp")

function setup()
    background(0x80)
end

function draw()
    local c = random(255)
    --print(c)
    fill(c)
    rect(10,10, 200,200)
end

go()
