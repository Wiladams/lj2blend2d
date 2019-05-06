
GPianoKeyboard = {}
GPianoKeyboard.__index = GPianoKeyboard

local yoffset = 0;
local xoffset = 0;

-- scale width, height
local whiteKeyWidth = 0.143
local whiteKeyHeight = 1

-- scale 2,2
--local whiteKeyWidth = 45;
--local whiteKeyHeight = 140;

-- scale 1:1
--local whiteKeyWidth = 90;
--local whiteKeyHeight = 280;

-- scale 0.5, 0.5
--local whiteKeyWidth = 180;
--local whiteKeyHeight = 560;



local whiteKeyGap = 0;

local octaveLoc = {
    {name = "C", kind = "white", frame = {x=xoffset + 0*whiteKeyWidth+whiteKeyGap, y=yoffset, width=whiteKeyWidth, height=whiteKeyHeight}};
    {name = "D", kind = "white", frame = {x=xoffset + 1*whiteKeyWidth+whiteKeyGap, y=yoffset, width=whiteKeyWidth, height=whiteKeyHeight}};
    {name = "E", kind = "white", frame = {x=xoffset + 2*whiteKeyWidth+whiteKeyGap, y=yoffset, width=whiteKeyWidth, height=whiteKeyHeight}};
    {name = "F", kind = "white", frame = {x=xoffset + 3*whiteKeyWidth+whiteKeyGap, y=yoffset, width=whiteKeyWidth, height=whiteKeyHeight}};
    {name = "G", kind = "white", frame = {x=xoffset + 4*whiteKeyWidth+whiteKeyGap, y=yoffset, width=whiteKeyWidth, height=whiteKeyHeight}};
    {name = "A", kind = "white", frame = {x=xoffset + 5*whiteKeyWidth+whiteKeyGap, y=yoffset, width=whiteKeyWidth, height=whiteKeyHeight}};
    {name = "B", kind = "white", frame = {x=xoffset + 6*whiteKeyWidth+whiteKeyGap, y=yoffset, width=whiteKeyWidth, height=whiteKeyHeight}};

}

function GPianoKeyboard.new(self, obj)
    local obj = obj or {}
    obj.scale = obj.scale or {x=1, y=1}

    setmetatable(obj, GPianoKeyboard)

    return obj;
end

function GPianoKeyboard.draw(self, ctx)
    ctx:push()
    ctx:scale(self.scale.x, self.scale.y)
    ctx:setTransformBeforeStroke();

    ctx:strokeWidth(1)
    --print("GPianoKeyboard.draw")
    for _, key in ipairs(octaveLoc) do
        --print(key, key.frame.x, key.frame.y, key.frame.width, key.frame.height)

        if key.kind == "white" then
            ctx:fill(220)
        else
            ctx:fill(30)
        end

        ctx:rect(key.frame.x, key.frame.y, key.frame.width, key.frame.height)
        --ctx:fillRectD(key.frame.x, key.frame.y, key.frame.width, key.frame.height)
        --ctx:strokeRectD(key.frame.x, key.frame.y, key.frame.width, key.frame.height)
    end

    ctx:pop()
end


return GPianoKeyboard