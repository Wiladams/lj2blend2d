package.path = "../?.lua;"..package.path;

require("p5")

local usingStroke = false;
local usingFill = true;


local function randomColor()
    local r = random(30,255)
    local g = random(30,255)
    local b = random(30,255)
    return color(r,g,b,0x7f)
end


function setup()
    background(0x80)
end

function draw()
    if not usingStroke then
        noStroke()
    else
        stroke(randomColor())
    end

    if not usingFill then
        noFill()
    end

    for i=1,500 do
        local x = random(0,width-10)
        local y = random(0, height-10)
        local w = 20;
        local h = 20;

        if usingFill then
            local c = randomColor()
            fill(c)
        end

        rect(x,y, w,h)
    end
end

local T_S = string.byte("S")
local T_F = string.byte("F")

function keyTyped(event)
    --print("keyTyped: ", keyCode, T_S, T_F)
    if keyCode == T_S then
        usingStroke = not usingStroke
    end

    if keyCode == T_F then
        usingFill = not usingFill
    end
end

go()
