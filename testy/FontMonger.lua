local ffi = require("ffi")
local C = ffi.C 

local blapi = require("blend2d.blend2d")
local errors = require("blerror")


local fsys = require("filesystem")
local FileSystem = fsys.FileSystem;
local FileSystemItem = fsys.FileSystemItem;

-- Some fontface enums 
local fontStyle = {
    [0] = "NORMAL",
    "OBLIQUE",
    "ITALIC",
}

local fontStretch = {
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

local fontWeight = {
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



-- simple predicate to determine whether a file is
-- truetype or not
local function passTTF(item)
    local name = item.Name:lower()
    
	return name:find(".ttf", 1, true);
end

local function getFaceInfo(face, fileName)
    if not face then return nil end

    local dmetrics = face:designMetrics()

    local info = {
        fileName = fileName;
        family = face:familyName();
        subFamilyName = face:subfamilyName();
        fullName = face:fullName();
        postscriptName = face:postScriptName();
        style = fontStyle[face:style()];
        stretch =  fontStretch[face:stretch()];
        weight = fontWeight[face:weight()];
    }

    return info
end

-- create a database of font face information
local function loadFontFaces(dir, predicate)
    local facedb = {}
    
    local startat = FileSystemItem({Name=dir})


	for item in startat:itemsRecursive() do
		if predicate then
            if predicate(item) then
                -- load the fontface
                local fullPath = item:getFullPath()
                local face, err = BLFontFace:createFromFile(fullPath)
                local familyname = face:familyName():lower()

                local familyslot = facedb[familyname]
                if not familyslot then
                    familyslot = {}
                    facedb[familyname] = familyslot
                end

                local faceinfo = getFaceInfo(face, item.Name)
                familyslot[face:subfamilyName():lower()] = {face = face, sizes = {}, info = faceinfo};
 			end
		else
			print(item.Name);
		end
    end

    return facedb
end


local FontMonger = {
    systemFontDirectory = "c:\\windows\\fonts\\"
}
local FontMonger_mt = {
    __index = FontMonger
}



function FontMonger.new(self, obj)
    obj = obj or loadFontFaces(FontMonger.systemFontDirectory, passTTF)

    setmetatable(obj, FontMonger_mt)

    return obj;
end

function FontMonger.faces(self)
    local function visitor()
        for family,v in pairs(self) do
            for subfamily, facedata in pairs(v) do
                coroutine.yield(family, subfamily, facedata)
            end
        end
    end

    return coroutine.wrap(visitor)
end

function FontMonger.getFace(self, family, subfamily, nearest)
    local famslot = self[family]
    if not famslot then
        return nil, "unknown family: "..family
    end

    local subslot = famslot[subfamily]
    if not subslot then
        return nil, "unknown subfamily: "..subfamily
    end

    return subslot
end

return FontMonger