package.path = "../?.lua;"..package.path;

require("p5")


local linear


local function drawBody(x,y,w,h)
    appContext:setFillStyle(linear);
    appContext:fillAll();
    
    fill(255,0,255,60)
    --noStroke();
    blendMode(BLEND)
    --appContext:setCompOp(C.BL_COMP_OP_EXCLUSION)
    --appContext:setFillStyle(BLRgba32(0xFF00FFFF))
    ellipse(width/2, width/2, width/3);
end

function setup()
    noLoop();

    linear = BLGradientCore(BLLinearGradientValues({ 0, 0, width, height }));

    linear:addStop(0.0, 0x70FFFFFF)
    linear:addStop(0.5, 0x70FFAF00)
    linear:addStop(1.0, 0x70FF0000)
end

function draw()
    drawBody(0,0,width, height)

--[[
    for i=1,3 do
        push()
        rotate(radians(45*i), width/2, height/2)
        scale(1/i, 1/i)
        drawBody(0,0,width, height)
        pop()
    end
--]]
---[[
    local dx = 0
    local dy = 0
    local dWidth = width/2
    local dHeight = height/2
    image(appImage, dx, dy, dWidth, dHeight, sx, sy, sWidth, sHeight)

    dx = width/2
    dy = 0
    dWidth = dWidth/2
    dHeight = dHeight/2
    image(appImage, dx, dy, dWidth, dHeight, sx, sy, sWidth, sHeight)

    dx = dx
    dy = dHeight
    dWidth = dWidth/2
    dHeight = dHeight/2
    image(appImage, dx, dy, dWidth, dHeight, sx, sy, sWidth, sHeight)
--]]
end

go({width = 800, height = 800})