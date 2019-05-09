package.path = "../?.lua;"..package.path;

--[[
    Generate computer keyboard layouts from some structured information
    You would want to do this to play with generating new graphics that 
    represent a keyboard.
    
    Usage: luajit vkeyboardgen.lua  outfilename.lua
--]]
local vkeys = require("vkeys")


local ansikeyLayout = {
    {
        {pos = 1, x=0, row = 0, scale={x=1, y=1}, caption = "Esc", vkey=vkeys.VK_ESCAPE};
        {pos = 2, x=1, row = 0, scale={x=1, y=1}, caption = "F1", vkey=vkeys.VK_F1};
        {pos = 3, x=0, row = 0, scale={x=1, y=1}, caption = "F2", vkey=vkeys.VK_F2};
        {pos = 4, x=0, row = 0, scale={x=1, y=1}, caption = "F3", vkey=vkeys.VK_F3};
        {pos = 5, x=0, row = 0, scale={x=1, y=1}, caption = "F4", vkey=vkeys.VK_F4};
        {pos = 6, x=0.5, row = 0, scale={x=1, y=1}, caption = "F5", vkey=vkeys.VK_F5};
        {pos = 7, x=0, row = 0, scale={x=1, y=1}, caption = "F6", vkey=vkeys.VK_F6};
        {pos = 8, x=0, row = 0, scale={x=1, y=1}, caption = "F7", vkey=vkeys.VK_F7};
        {pos = 9, x=0, row = 0, scale={x=1, y=1}, caption = "F8", vkey=vkeys.VK_F8};
        {pos = 10, x=0.5, row = 0, scale={x=1, y=1}, caption = "F9", vkey=vkeys.VK_F9};
        {pos = 11, x=0, row = 0, scale={x=1, y=1}, caption = "F10", vkey=vkeys.VK_F10};
        {pos = 12, x=0, row = 0, scale={x=1, y=1}, caption = "F11", vkey=vkeys.VK_F11};
        {pos = 13, x=0, row = 0, scale={x=1, y=1}, caption = "F12", vkey=vkeys.VK_F12};
    };

    {
        {pos = 1, x=0, row = 1, scale={x=1, y=1}, caption = "`", vkey=0};
        {pos = 2, x=0, row = 1, scale={x=1, y=1}, caption = "1",vkey=vkeys.VK_1};
        {pos = 3, x=0, row = 1, scale={x=1, y=1}, caption = "2",vkey=vkeys.VK_2};
        {pos = 4, x=0, row = 1, scale={x=1, y=1}, caption = "3",vkey=vkeys.VK_3};
        {pos = 5, x=0, row = 1, scale={x=1, y=1}, caption = "4",vkey=vkeys.VK_4};
        {pos = 6, x=0, row = 1, scale={x=1, y=1}, caption = "5",vkey=vkeys.VK_5};
        {pos = 7, x=0, row = 1, scale={x=1, y=1}, caption = "6",vkey=vkeys.VK_6};
        {pos = 8, x=0, row = 1, scale={x=1, y=1}, caption = "7",vkey=vkeys.VK_7};
        {pos = 9, x=0, row = 1, scale={x=1, y=1}, caption = "8",vkey=vkeys.VK_8};
        {pos = 10, x=0, row = 1, scale={x=1, y=1}, caption = "9",vkey=vkeys.VK_9};
        {pos = 11, x=0, row = 1, scale={x=1, y=1}, caption = "0",vkey=vkeys.VK_0};
        {pos = 12, x=0, row = 1, scale={x=1, y=1}, caption = "-",vkey=0};
        {pos = 13, x=0, row = 1, scale={x=1, y=1}, caption = "=",vkey=0};
        {pos = 14, x=0, row = 1, scale={x=2, y=1}, caption = "Backspace",vkey=vkeys.VK_BACK};
    };

    {
        {pos = 1, x=0, row = 2, scale={x=1.5, y=1}, caption ="Tab", vkey=vkeys.VK_TAB};
        {pos = 2, x=0, row = 2, scale={x=1, y=1}, caption = "Q", vkey=vkeys.VK_Q};
        {pos = 3, x=0, row = 2, scale={x=1, y=1}, caption ="W", vkey=vkeys.VK_W};
        {pos = 4, x=0, row = 2, scale={x=1, y=1}, caption = "E", vkey=vkeys.VK_E};
        {pos = 5, x=0, row = 2, scale={x=1, y=1}, caption = "R", vkey=vkeys.VK_R};
        {pos = 6, x=0, row = 2, scale={x=1, y=1}, caption = "T", vkey=vkeys.VK_T};
        {pos = 7, x=0, row = 2, scale={x=1, y=1}, caption = "Y", vkey=vkeys.VK_Y};
        {pos = 8, x=0, row = 2, scale={x=1, y=1}, caption = "U", vkey=vkeys.VK_U};
        {pos = 9, x=0, row = 2, scale={x=1, y=1}, caption = "I", vkey=vkeys.VK_I};
        {pos = 10, x=0, row = 2, scale={x=1, y=1}, caption = "O", vkey=vkeys.VK_O};
        {pos = 11, x=0, row = 2, scale={x=1, y=1}, caption = "P", vkey=vkeys.VK_P};
        {pos = 12, x=0, row = 2, scale={x=1, y=1}, caption = "[", vkey=vkeys.VK_OEM_4};
        {pos = 13, x=0, row = 2, scale={x=1, y=1}, caption = "]", vkey=vkeys.VK_OEM_6};
        {pos = 14, x=0, row = 2, scale={x=1.5, y=1}, caption = "\\", vkey=vkeys.VK_OEM_5};
    };

    {
        {pos = 1, x=0, row = 3, scale={x=1.75, y=1}, caption = "Caps", vkey=vkeys.VK_CAPITAL};
        {pos = 2, x=0, row = 3, scale={x=1, y=1}, caption = "A", vkey=vkeys.VK_A};
        {pos = 3, x=0, row = 3, scale={x=1, y=1}, caption = "S", vkey=vkeys.VK_S};
        {pos = 4, x=0, row = 3, scale={x=1, y=1}, caption = "D", vkey=vkeys.VK_D};
        {pos = 5, x=0, row = 3, scale={x=1, y=1}, caption = "F", vkey=vkeys.VK_F};
        {pos = 6, x=0, row = 3, scale={x=1, y=1}, caption = "G", vkey=vkeys.VK_G};
        {pos = 7, x=0, row = 3, scale={x=1, y=1}, caption = "H", vkey=vkeys.VK_H};
        {pos = 8, x=0, row = 3, scale={x=1, y=1}, caption = "J", vkey=vkeys.VK_J};
        {pos = 9, x=0, row = 3, scale={x=1, y=1}, caption = "K", vkey=vkeys.VK_K};
        {pos = 10, x=0, row = 3, scale={x=1, y=1}, caption = "L", vkey=vkeys.VK_L};
        {pos = 11, x=0, row = 3, scale={x=1, y=1}, caption = ";", vkey=vkeys.VK_OEM_1};
        {pos = 12, x=0, row = 3, scale={x=1, y=1}, caption = "'", vkey=vkeys.VK_OEM_7};
        {pos = 13, x=0, row = 3, scale={x=2.25, y=1}, caption = "Enter", vkey=vkeys.VK_RETURN};
    };

    {
        {pos = 1, x=0, row = 4, scale={x=2.25, y=1}, caption = "Shift", vkey=vkeys.VK_LSHIFT};
        {pos = 2, x=0, row = 4, scale={x=1, y=1}, caption = 'Z', vkey=vkeys.VK_Z};
        {pos = 3, x=0, row = 4, scale={x=1, y=1}, caption = 'X', vkey=vkeys.VK_X};
        {pos = 4, x=0, row = 4, scale={x=1, y=1}, caption = 'C', vkey=vkeys.VK_C};
        {pos = 5, x=0, row = 4, scale={x=1, y=1}, caption = 'V', vkey=vkeys.VK_V};
        {pos = 6, x=0, row = 4, scale={x=1, y=1}, caption = 'B', vkey=vkeys.VK_B};
        {pos = 7, x=0, row = 4, scale={x=1, y=1}, caption = 'N', vkey=vkeys.VK_N};
        {pos = 8, x=0, row = 4, scale={x=1, y=1}, caption = 'M', vkey=vkeys.VK_M};
        {pos = 9, x=0, row = 4, scale={x=1, y=1}, caption = ",", vkey=vkeys.VK_OEM_COMMA};
        {pos = 10, x=0, row = 4, scale={x=1, y=1}, caption = ".", vkey=vkeys.VK_OEM_PERIOD};
        {pos = 11, x=0, row = 4, scale={x=1, y=1}, caption = "/", vkey=vkeys.VK_OEM_2};
        {pos = 12, x=0, row = 4, scale={x=2.75, y=1}, caption = "Shift", vkey=vkeys.VK_RSHIFT};
    };

    {
        {pos = 1, x=0, y=0, row = 5, scale={x=1.25, y=1}, caption = "Ctrl", vkey=vkeys.VK_LCONTROL};
        {pos = 2, x=0, y=0, row = 5, scale={x=1.25, y=1}, caption = "Win", vkey=vkeys.VK_LWIN};
        {pos = 3, x=0, y=0, row = 5, scale={x=1.25, y=1}, caption = "Alt", vkey=vkeys.VK_MENU};
        {pos = 4, x=0, y=0, row = 5, scale={x=6.25, y=1}, caption = "Space", vkey=vkeys.VK_SPACE};
        {pos = 5, x=0, y=0, row = 5, scale={x=1.25, y=1}, caption = "Alt", vkey=vkeys.VK_MENU};
        {pos = 6, x=0, y=0, row = 5, scale={x=1.25, y=1}, caption = "Win", vkey=vkeys.VK_RWIN};
        {pos = 7, x=0, y=0, row = 5, scale={x=1.25, y=1}, caption = "Menu", vkey=vkeys.VK_RMENU};
        {pos = 8, x=0, y=0, row = 5, scale={x=1.25, y=1}, caption = "Ctrl", vkey=vkeys.VK_RCONTROL};
    }
}

local outputfilename = arg[1]
print("OUT: ", outputfilename)

if not outputfilename then return false end
local of = io.open(outputfilename, "w+")


local function generateFrames(keyLayout, unit, obj)
    unit = unit or 40
    obj = obj or {}

    local xmargin = 4
    local xgap = 0
    local rowoffset = 4
    local ygap = 2

    for rowidx, row in ipairs(keyLayout) do
        local x = xmargin;
        if rowidx == 2 then
            rowoffset = unit
        end

        for _, key in ipairs(row) do
            x = x + key.x*unit + xgap
            local y = rowoffset + key.row*unit + ygap
            local cx = unit*key.scale.x
            local cy = unit*key.scale.y

            local keyloc = {vkey = key.vkey, frame={x=x, y=y, width=cx, height=cy}, caption=key.caption or ""}
                
            table.insert(obj, keyloc)

            local caption = key.caption or ''
            if caption == '\\' or caption == '"' then
                caption = '\\'..caption
            end

            of:write(string.format('{vkey = 0x%02x, frame = {x=%3.2f, y=%3.2f, width=%3.2f, height=%3.2f}, caption="%s"};\n',
                key.vkey, x, y, cx, cy, caption))

            x = x + cx
        end
    end

    return obj
end

generateFrames(ansikeyLayout)

io.close(of)