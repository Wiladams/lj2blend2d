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
    textAlign(RIGHT)
    text(frameText, width/2, height/2-12)

    textAlign(CENTER)
    text(frameText, width/2, height/2)
    
    textAlign(LEFT)
    text(frameText, width/2, height/2+12)


    --stats:draw()
end

go({frameRate = 30})