package.path = "../?.lua;"..package.path;


require("p5")

function setup()
    background(0xcc)

    -- setup clipping rect for half of area
    clip(width/2, 0, width/2, height)
    
    -- Draw Some text
    fill(0xff,0,0)
    textAlign(CENTER)
    text("This text straddles the middle", width/2, 100)
    
    -- remove clipping and do it again
    noClip()
    fill(0)
    textAlign(CENTER)
    text("This text straddles the middle", width/2, 200)

    --noLoop()
end


go({width = 640, height = 320})
