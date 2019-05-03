-- References
-- https://blog.wooting.nl/the-ultimate-guide-to-keyboard-layouts-and-form-factors/
-- https://www.google.com/search?q=windows-keyboard-60-keys&source=lnms&tbm=isch&sa=X&ved=0ahUKEwj-6569vP3hAhUCSX0KHT-sBzYQ_AUIDigB&biw=1174&bih=687#imgdii=OjnWmMVZmV6xpM:&imgrc=TCvZ-CdnC1S44M:
-- to building keyboard layout graphics

-- ANSI Standard full key layout
local keyLayout = {
    {
        {pos = 1, x=0, row = 0, scale={x=1, y=1}, caption = "Esc", vkey='one'};
        {pos = 2, x=1, row = 0, scale={x=1, y=1}, caption = "F1", vkey='two'};
        {pos = 3, x=0, row = 0, scale={x=1, y=1}, caption = "F2", vkey='three'};
        {pos = 4, x=0, row = 0, scale={x=1, y=1}, caption = "F3", vkey='four'};
        {pos = 5, x=0, row = 0, scale={x=1, y=1}, caption = "F4", vkey='five'};
        {pos = 6, x=0.5, row = 0, scale={x=1, y=1}, caption = "F5", vkey='six'};
        {pos = 7, x=0, row = 0, scale={x=1, y=1}, caption = "F6", vkey='seven'};
        {pos = 8, x=0, row = 0, scale={x=1, y=1}, caption = "F7", vkey='eight'};
        {pos = 9, x=0, row = 0, scale={x=1, y=1}, caption = "F8", vkey='one'};
        {pos = 10, x=0.5, row = 0, scale={x=1, y=1}, caption = "F9", vkey='two'};
        {pos = 11, x=0, row = 0, scale={x=1, y=1}, caption = "F10", vkey='three'};
        {pos = 12, x=0, row = 0, scale={x=1, y=1}, caption = "F11", vkey='three'};
        {pos = 13, x=0, row = 0, scale={x=1, y=1}, caption = "F12", vkey='three'};
    };

    {
        {pos = 1, x=0, row = 1, scale={x=1, y=1}, caption = "`", vkey='one'};
        {pos = 2, x=0, row = 1, scale={x=1, y=1}, caption = "1",vkey='two'};
        {pos = 3, x=0, row = 1, scale={x=1, y=1}, caption = "2",vkey='three'};
        {pos = 4, x=0, row = 1, scale={x=1, y=1}, caption = "3",vkey='four'};
        {pos = 5, x=0, row = 1, scale={x=1, y=1}, caption = "4",vkey='five'};
        {pos = 6, x=0, row = 1, scale={x=1, y=1}, caption = "5",vkey='six'};
        {pos = 7, x=0, row = 1, scale={x=1, y=1}, caption = "6",vkey='seven'};
        {pos = 8, x=0, row = 1, scale={x=1, y=1}, caption = "7",vkey='eight'};
        {pos = 9, x=0, row = 1, scale={x=1, y=1}, caption = "8",vkey='one'};
        {pos = 10, x=0, row = 1, scale={x=1, y=1}, caption = "9",vkey='two'};
        {pos = 11, x=0, row = 1, scale={x=1, y=1}, caption = "0",vkey='three'};
        {pos = 12, x=0, row = 1, scale={x=1, y=1}, caption = "-",vkey='three'};
        {pos = 13, x=0, row = 1, scale={x=1, y=1}, caption = "=",vkey='three'};
        {pos = 14, x=0, row = 1, scale={x=2, y=1}, caption = "Backspace",vkey='four'};
    };

    {
        {pos = 1, x=0, row = 2, scale={x=1.5, y=1}, caption ="Tab", vkey='one'};
        {pos = 2, x=0, row = 2, scale={x=1, y=1}, caption = "Q", vkey='two'};
        {pos = 3, x=0, row = 2, scale={x=1, y=1}, caption ="W", vkey='three'};
        {pos = 4, x=0, row = 2, scale={x=1, y=1}, caption = "E", vkey='four'};
        {pos = 5, x=0, row = 2, scale={x=1, y=1}, caption = "R", vkey='five'};
        {pos = 6, x=0, row = 2, scale={x=1, y=1}, caption = "T", vkey='six'};
        {pos = 7, x=0, row = 2, scale={x=1, y=1}, caption = "Y", vkey='seven'};
        {pos = 8, x=0, row = 2, scale={x=1, y=1}, caption = "U", vkey='eight'};
        {pos = 9, x=0, row = 2, scale={x=1, y=1}, caption = "I", vkey='one'};
        {pos = 10, x=0, row = 2, scale={x=1, y=1}, caption = "O", vkey='two'};
        {pos = 11, x=0, row = 2, scale={x=1, y=1}, caption = "P", vkey='three'};
        {pos = 12, x=0, row = 2, scale={x=1, y=1}, caption = "[", vkey='three'};
        {pos = 13, x=0, row = 2, scale={x=1, y=1}, caption = "]", vkey='three'};
        {pos = 14, x=0, row = 2, scale={x=1.5, y=1}, caption = "\\", vkey='four'};
    };

    {
        {pos = 1, x=0, row = 3, scale={x=1.75, y=1}, caption = "Caps", vkey='Caps'};
        {pos = 2, x=0, row = 3, scale={x=1, y=1}, caption = "A", vkey=''};
        {pos = 3, x=0, row = 3, scale={x=1, y=1}, caption = "S", vkey='three'};
        {pos = 4, x=0, row = 3, scale={x=1, y=1}, caption = "D", vkey='four'};
        {pos = 5, x=0, row = 3, scale={x=1, y=1}, caption = "F", vkey='five'};
        {pos = 6, x=0, row = 3, scale={x=1, y=1}, caption = "G", vkey='six'};
        {pos = 7, x=0, row = 3, scale={x=1, y=1}, caption = "H", vkey='seven'};
        {pos = 8, x=0, row = 3, scale={x=1, y=1}, caption = "J", vkey='eight'};
        {pos = 9, x=0, row = 3, scale={x=1, y=1}, caption = "K", vkey='one'};
        {pos = 10, x=0, row = 3, scale={x=1, y=1}, caption = "L", vkey='two'};
        {pos = 11, x=0, row = 3, scale={x=1, y=1}, caption = ";", vkey='three'};
        {pos = 12, x=0, row = 3, scale={x=1, y=1}, caption = ",", vkey='three'};
        {pos = 13, x=0, row = 3, scale={x=2.25, y=1}, caption = "Enter", vkey='four'};
    };

    {
        {pos = 1, x=0, row = 4, scale={x=2.25, y=1}, caption = "Shift", vkey='one'};
        {pos = 2, x=0, row = 4, scale={x=1, y=1}, caption = 'Z', vkey='two'};
        {pos = 3, x=0, row = 4, scale={x=1, y=1}, caption = 'X', vkey='three'};
        {pos = 4, x=0, row = 4, scale={x=1, y=1}, caption = 'C', vkey='four'};
        {pos = 5, x=0, row = 4, scale={x=1, y=1}, caption = 'V', vkey='five'};
        {pos = 6, x=0, row = 4, scale={x=1, y=1}, caption = 'B', vkey='six'};
        {pos = 7, x=0, row = 4, scale={x=1, y=1}, caption = 'N', vkey='seven'};
        {pos = 8, x=0, row = 4, scale={x=1, y=1}, caption = 'M', vkey='eight'};
        {pos = 9, x=0, row = 4, scale={x=1, y=1}, caption = ",", vkey='one'};
        {pos = 10, x=0, row = 4, scale={x=1, y=1}, caption = ".", vkey='two'};
        {pos = 11, x=0, row = 4, scale={x=1, y=1}, caption = "/", vkey='three'};
        {pos = 12, x=0, row = 4, scale={x=2.75, y=1}, caption = "Shift", vkey='four'};
    };

    {
        {pos = 1, x=0, y=0, row = 5, scale={x=1.25, y=1}, caption = "Ctrl", vkey='one'};
        {pos = 2, x=0, y=0, row = 5, scale={x=1.25, y=1}, caption = "Win", vkey='two'};
        {pos = 3, x=0, y=0, row = 5, scale={x=1.25, y=1}, caption = "Alt", vkey='three'};
        {pos = 4, x=0, y=0, row = 5, scale={x=6.25, y=1}, caption = "Space", vkey='four'};
        {pos = 5, x=0, y=0, row = 5, scale={x=1.25, y=1}, caption = "Alt", vkey='five'};
        {pos = 6, x=0, y=0, row = 5, scale={x=1.25, y=1}, caption = "Win", vkey='six'};
        {pos = 7, x=0, y=0, row = 5, scale={x=1.25, y=1}, caption = "Menu", vkey='seven'};
        {pos = 8, x=0, y=0, row = 5, scale={x=1.25, y=1}, caption = "Ctrl", vkey='eight'};
    }
}

local GKeyboard = {}
GKeyboard.__index = GKeyboard

function GKeyboard.new(self, obj)
    local obj = obj or {}
    obj.unit = obj.unit or 40

    setmetatable(obj, GKeyboard)

    return obj;
end

--local BLRoundRect = ffi.typeof("struct BLRoundRect")
local function insetRect(rrect, cx, cy)
    local dx = cx/2
    local dy = cy/2

    return BLRoundRect(rrect.x+dx,rrect.y+dy,rrect.w-cx, rrect.h-cy, rrect.rx, rrect.ry)
end

function GKeyboard.draw(self, ctx)
    -- draw a standard bottom row
    ctx:fill(127)
    ctx:stroke(10)
    ctx:strokeWidth(1)

    local xmargin = 4
    local xgap = 2
    local rowoffset = 4
    local ygap = 2

    ctx:textAlign(MIDDLE, MIDDLE)
    ctx:textSize(12);

    for rowidx, row in ipairs(keyLayout) do
        local x = xmargin;
        if rowidx == 2 then
            rowoffset = self.unit
        end


        for _, key in ipairs(row) do
            x = x + key.x*self.unit + xgap
            local y = rowoffset + key.row*self.unit + ygap
            local cx = self.unit*key.scale.x
            local cy = self.unit*key.scale.y

            local rrect = BLRoundRect(x,y,cx, cy, 3, 3)
            local crect = insetRect(rrect,self.unit*0.30,self.unit*0.30)

            ctx:fill(127)
            ctx:fillRoundRect(rrect)    
            ctx:strokeRoundRect(rrect)

            ctx:fill(255, 126)
            ctx:fillRoundRect(crect)

            -- put text caption in middle of key
            -- if it exists
            ctx:fill(0)
            if key.caption then
                ctx:text(key.caption, x+cx/2, y+cy/2)
            end

            x = x + cx
        end
    end
end

return GKeyboard
