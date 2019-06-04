--[[
-- first do this
    copy the blend2d.h file into this directory

    copy c:\repos\blendwsp\blend2d\src\blend2d.h .

then
    mkdir blend2d

    copy c:\repos\blendwsp\blend2d\src\blend2d\blapi.h blend2d

    Copy the rest of the interesting header files into that directory
    blapi.h
    blarray.
    blbitarray.h
    blcontext.h
    blfilesystem.h
    blfont.h
    blfontdefs.h
    blformat.h
    blgeometry.h
    blglyphbuffer.h
    blgradient.h
    blimage.h
    blmatrix.h
    blpath.h
    blpattern.h
    blpixelconverter.h
    blrandom.h
    blregion.h
    blrgba.h
    blruntime.h
    blstring.h
    blvariant.h
    
-- cl /E blend2d.h > blend2d_ffi.txt

--Then run this file on the resulting blend2d_ffi.txt
-- luajit preproc.lua blend2d_ffi.txt > blend2d_ffi.lua
--
-- look for the line starting: typedef struct BLRange BLRange;
-- and delete everything before that

Of Note:
Endian things are not taken care of, meaning, they default to little-endian
blruntime
blfontdefs
blformat
blrgba
some union/structs are collapsed
--]]


for line in io.lines("blend2d_ffi.txt") do
    if line ~= "" and line ~= "  " then
        if string.sub(line, 1, 1) ~= '#' then
            if not string.find(line, "__pragma") then
                print(line)
            end
        end
    end
end
