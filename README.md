# lj2blend2d
LuaJIT binding to blend2d graphics library

https://blend2d.com

Blend2d is a relatively new kid on the block in terms of 2D graphics libraries.
The authors claim a number of innovations which make it at least as competitive
as skia, cairo, Anti Grain, Freetype, and the like.  One of the key novelties is a
JIT compiled rasterization pipeline.

The library has a 'C' and 'C++' interfaces.  It's fairly straightforward in that regard.
One you get used to it, very similar to something like GDI of old, where you have a 
drawing context with state, and you perform various drawing operations after setting
state.

The code in this repository provides access to the library leveraging the 'C' interface
and providing a number of Lua conveniences.  If you look at the bl_getting_started_x.lua
files, these are fairly faithful recreations of the same found in the blend2d samples
repository:

https://github.com/blend2d/bl-samples

This is a significant achievement as the C++ interface is really nice and convenient, whereas
the C interface is a bit verbose.  The LuaJIT interface is very similar to the C++ interface,
only better of course, because Lua.

This is a very early binding though.  The object interface is mixed in with the header files
that provide the basic 'ffi' interface to the library.  This is very inconvenient as the core
library makes changes.  This will need to be separated for subsequent releases, but for now
there it is.

The 'testy' directory contains plenty of code to show how to use things, so not a lot of documentation.
If you learn the docs from the blend2d project itself, you should be able to leverage this binding
fairly easily, either with straight C calls, or using the more object oriented interface.

