package.path = "../?.lua;"..package.path;

--[[
    A program to iterate the Windows/fonts directory, looking
    for .ttf files, and putting them into a table.
]]
local ffi = require("ffi")
local C = ffi.C 

local blapi = require("blend2d.blend2d")
local errors = require("blerror")
local fsys = require("filesystem")
local FileSystem = fsys.FileSystem;
local FileSystemItem = fsys.FileSystemItem;


local fontDir = "c:\\windows\\fonts\\"


-- simple predicate to determine whether a file is
-- truetype or not
local function passTTF(item)
    local name = item.Name:lower()
    
	return name:find(".ttf", 1, true);
end

local fontStyle = {
    [0] = "NORMAL",
    "OBLIQUE",
    "ITALIC",
}

fontStretch = {
    [1] = "ULTRA_CONDENSED";
    "EXTRA_CONDENSED";
    "CONDENSED";
    "SEMI_CONDENSED";
    "NORMAL";
    "SEMI_EXPANDED";
    "EXPANDED";
    "EXTRA_EXPANDED";
    "ULTRA_EXPANDED";
  };

  fontWeight = {
    [100] = "THIN",
    [200] = "EXTRA_LIGHT",
    [300] = "LIGHT",
    [350] = "SEMI_LIGHT",
    [400] = "NORMAL",
    [500] = "MEDIUM",
    [600] = "SEMI_BOLD",
    [700] = "BOLD",
    [800] = "EXTRA_BOLD",
    [900] = "BLACK",
    [950] = "EXTRA_BLACK"
  };

local function printFontFaceInfo(face, fileName, filePath)
    if not face then return false end

    local dmetrics = face:designMetrics()

    io.write("{")
    io.write(string.format("%s = '%s'; ", "fileName", fileName))
    io.write(string.format("%s = '%s'; ", "family", face:familyName()))
    io.write(string.format("%s = '%s'; ", "subFamilyName", face:subfamilyName()))

    io.write(string.format("%s = '%s'; ", "fullName", face:fullName()))
    io.write(string.format("%s = '%s'; ", "postscriptName", face:postScriptName()))
    io.write(string.format("%s = '%s'; ", "style", fontStyle[face:style()]))
    --io.write(string.format("%s = '%s'; ", "filePath", filePath))
    io.write(string.format("%s = '%s'; ", "stretch", fontStretch[face:stretch()]))
    io.write(string.format("%s = '%s'; ", "weight", fontWeight[face:weight()]))

--[[
    print("stretch: ", face:stretch());
    print("weight: ", face:weight());

    print("== dmetrics ==")
    print("unitsPerEm: ", dmetrics.unitsPerEm);
    print("   lineGap: ", dmetrics.lineGap);
    print("   xHeight: ", dmetrics.xHeight);
    print(" capHeight: ", dmetrics.capHeight);
    print("    ascent: ", dmetrics.ascent);
    print("   descent: ", dmetrics.descent);
--]]

    print("};")
end


local function printFileItems(startat, filterfunc)
    print("{")
	for item in startat:itemsRecursive() do
		if filterfunc then
            if filterfunc(item) then
                local fullPath = item:getFullPath()
                local face, err = BLFontFace:createFromFile(fullPath)
                printFontFaceInfo(face, item.Name, fullPath)
			end
		else
			print(item.Name);
		end
    end
    print("};")
end

printFileItems(FileSystemItem({Name=fontDir}), passTTF)

