package.path = "../?.lua;"..package.path;

require("p5")
--local stats = require("p5ui.P5Status")()

function setup()
    noLoop()
end

local frameText = "Hello P5!!"

function draw()
    background(0x80)
    
    stroke(0xff, 0,0)

    line(width/2 - 30, height/2, width/2 + 30, height/2)
    line(width/2, height/2-30, width/2, height/2+30)
 
    local w,h = appFont:measureText(frameText) 

    --print("text size: ", w, h)

    -- draw the text
    stroke(0)
    fill(0)
    textAlign(RIGHT, BOTTOM)
    text("RIGHT Aligned", width/2, height/2-12)

    textAlign(CENTER, BOTTOM)
    text("CENTER Aligned", width/2, height/2)
    
    textAlign(LEFT, BOTTOM)
    text("LEFT Aligned", width/2, height/2+12)


    stroke(255,0,0)
    line(10, 100, width-10, 100)

    textAlign(LEFT, BASELINE)
    text("BOTTOM Mertigal", 20, 100)

    textAlign(LEFT, CENTER)
    text("CENTER Mertigal", 220, 100)

    textAlign(LEFT, TOP)
    text("TOP Mertigal", 420, 100)
end

go({frameRate = 30})