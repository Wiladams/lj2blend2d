package.path = "../?.lua;"..package.path;

local b2d = require("blend2d.b2d")

local val = BLRgba32(0xFEEDFACE)

print(string.format("0x%X",val.value))