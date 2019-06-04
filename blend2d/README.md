Herein lies a LuaJIT binding to the blend2d vector graphics library.
The first assumption is that the library already exists somewhere in the system where libraries
can be found.  

The binding strives to be both OS and endian agnostic.  Admittedly, neither at the moment.
The current binding is Windows, 32-bit little-endian specific.  This will change soon enough as the 
basic blend2d api and data structures stabilize.

blend2d_ffi.lua - contains the easiest straight up interface to using Blend2D.  This exposes all the 
basic types, functions, and constants.  A program can be created by using this alone, and it will be
faithful to the raw 'C' interface that blend2d presents.

The file returns a loaded blend2d library so that calls can be made against the returned value
without much effort.

Access to all the enums and constants must come through usage of the ffi interface:

local blapi = require("blend2d.blend2d_ffi")
blapi.blCallBlendFunction();

blend2d.lua - contains refinements to the binding, building upon what's already in the blend2d_ffi
base binding.  In particular, you find data types with fleshed out metatypes attached to them.
This makes programming about as convenient as it looks in the C++ binding.


INSTALLATION
------------

The easiest way to install this package is to simply copy the blend2d directory into the 
'lua' directory of the LuaJIT installation.