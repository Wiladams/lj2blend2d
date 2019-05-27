local FontCollection = {
    systemFontDirectory = "c:\\windows\\fonts\\"
}
local FontCollection_mt = {
    __index = FontCollection
}

function FontCollection.new(self, obj)
    obj = obj or {
        fontDirectory = FontCollection.systemFontDirectory
    }
    setmetatable(obj, FontCollection_mt)

    return obj;
end

function FonCollection.addSystemFonts(self)
end

function FontCollection.addFile(self, filename)
    -- assume the file is in local directory
    -- or it's in system font directory
end

--[[
BLFontFace face = fc.queryFace("Arial")
BLFont font;
font.createFromFace(face, someSize)
--]]

return FontCollection