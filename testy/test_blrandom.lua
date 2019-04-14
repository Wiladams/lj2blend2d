package.path = "../?.lua;"..package.path;

require("blend2d.blend2d")

local rnd = BLRandom();

rnd:reset(math.random(0,65535))

for i=1,10 do
    print(rnd:nextUInt32())
end
