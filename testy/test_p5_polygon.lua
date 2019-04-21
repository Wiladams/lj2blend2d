package.path = "../?.lua;"..package.path;

require("p5")

local pts = {
    {200; 320};
    {80; 160};
    {220; 200};
    {300; 40};
    {380; 200};
    {520; 160};
    {400; 320};
}

function setup()
    background(222, 217, 177)
    fill(131, 209, 119)
    strokeWeight(3)
    strokeJoin(JOIN_ROUND)
    smooth();
    polygon(pts)
end



go({width =600, height=400})