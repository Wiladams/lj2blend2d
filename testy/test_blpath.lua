package.path = "../?.lua;"..package.path;

local b2d = require("blend2d.blend2d")

local path, err = BLPath();
print(path, err)
path:moveTo(26, 31);
path:cubicTo(642, 132, 587, -136, 25, 464);
path:cubicTo(882, 404, 144, 267, 27, 31);
