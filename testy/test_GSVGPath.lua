package.path = "../?.lua;"..package.path;

local blapi = require("blend2d.blend2d")

local GSVGPath = require ("GSVGPath")


local Brazzaville ="M342.47,725.69L338.49,729.8L334.85,734.55L334.85,734.55L332.6,734.94L330.03,733.17L329.04,729.63L329.24,726.09L331.21,722.94L334.77,722.55L339.51,722.74z"

local gpath = GSVGPath:new()
gpath:parseSVG(Brazzaville)

