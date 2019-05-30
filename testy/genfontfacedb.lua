local fontlist = require("fontlist")

local function createFaceDb(facelist)
    local facedb = {}

    for _, face in ipairs(facelist) do
        --print(face.family)
        local familyslot = facedb[face.family]
        if not familyslot then
            familyslot = {}
            facedb[face.family] = familyslot
        end

        familyslot[face.subFamilyName] = face;
    end

    return facedb
end

local function printFaceInfo(face)

io.write(string.format("%s = '%s'; ", "fileName", face.fileName))
io.write(string.format("%s = '%s'; ", "family", face.family))
io.write(string.format("%s = '%s'; ", "subFamilyName", face.subFamilyName))

io.write(string.format("%s = '%s'; ", "fullName", face.fullName))
io.write(string.format("%s = '%s'; ", "postscriptName", face.postScriptName))
io.write(string.format("%s = '%s'; ", "style", face.style))
io.write(string.format("%s = %d; ", "stretch", face.stretch))
io.write(string.format("%s = %d; ", "weight", face.weight))
end

local function printFamilyNames(db)
    for family,tab in pairs(db) do
        print(string.format("['%s'] = {", family))
        for k,v in pairs(tab) do
            io.write(string.format("  ['%s'] = {", k))
            printFaceInfo(v)
            print(string.format("  };"))
        end
        print("};")
    end
end

local db = createFaceDb(fontlist)

printFamilyNames(db)
