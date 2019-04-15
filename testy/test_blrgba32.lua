package.path = "../?.lua;"..package.path;

local b2d = require("blend2d.blend2d")

local val = BLRgba32(0xFFFFFFFF)

print(string.format("0x%x",val.value))