package.path = "../?.lua;"..package.path;

require("p5")

function setup()
    print("touchOn: ", touchOn())
end

function draw()
    background(0xff, 0x20, 0x20, 126)
end


function touchEvent(events)
    print("touchEvent: ", #events)
    
    -- for each event
    -- place a dark gray ellipse for the touch down
    -- place a light gray ellipse for the touch up
    -- place medium grapy for move

    ellipseMode(CENTER)
    for _, event in ipairs(events) do
        fill(30, 127)
        ellipse(event.x, event.y, event.width, event.height)
        --print(string.format("  id: %d  position: %d %d  Size: %d %d",
        --    event.ID, event.x, event.y, event.width, event.height))

    end
end

function keyTyped()
    if keyCode == 32 then
        if touchIsOn then
            touchOff();
        else
            touchOn();
        end
    end
end

go({width = 1200, height = 1200, frameRate=10})
