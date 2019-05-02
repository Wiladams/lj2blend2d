blend2d_ffi.lua - contains the easiest straight up interface to using Blend2D.  This exposes all the 
basic types, functions, and constants.  A program can be created by using this alone, and it will be
faithful to the raw 'C' interface that blend2d presents.

The file returns a loaded blend2d library so that calls can be made against the returned value
without much effort.

Access to all the enums and constants must come through usage of the ffi interface:

local blapi = require("blend2d.blend2d_ffi")
blapi.blCallBlendFunction();
