package.path = "../?.lua;"..package.path;

require("p5")
local stats = require("P5Status")()

function setup()
    --noLoop()


end

function draw()
    background(0x80)
    
    stroke(0xff, 0,0)
    
    line(width/2 - 20, height/2, width/2 + 20, height/2)
    line(width/2, height/2-20, width/2, height/2+20)
 
    local frameText = "Hello P5!!"
    local w, h = appFont:measureText(frameText) 
    print("text: ", w, h)

    -- draw the text
    stroke(0,0,0)
    text(frameText, width/2, height/2)

    stats:draw()
end

go({frameRate = 30})