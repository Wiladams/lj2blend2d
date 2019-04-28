package.path = "../?.lua;"..package.path;

require("p5")

local gestureCommands = {
    [1] = "GID_BEGIN";                    
    [2] = "GID_END";                       
    [3] = "GID_ZOOM";
    [4] = "GID_PAN";
    [5] = "GID_ROTATE";                    
    [6] = "GID_TWOFINGERTAP";               
    [7] = "GID_PRESSANDTAP";               
    --"GID_ROLLOVER";
}

function setup()
    --print("touchOn: ", touchOn())
end

function draw()
    background(0xff, 0x20, 0x20, 126)
end


function gestureEvent(event)
    print("gestureEvent: ", event.ID, gestureCommands[event.ID])
end



go({width = 640, height = 480, frameRate=10})
