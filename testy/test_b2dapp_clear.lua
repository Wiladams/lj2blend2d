package.path = "../?.lua;"..package.path;

require("b2dapp")

function setup()
    background(0xff, 0x20, 0x20)
    clear();
end

go()
