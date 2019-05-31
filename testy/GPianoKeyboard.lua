
--[[
    A graphic of a piano keyboard.
    The graphic is drawn to a unit 1x1.  That is, the highest x or y value is 1.  This
    allows it to be scaled to any size when drawn, by simply scaling.  You can provide
    the scaling when constructing, or by transforming the drawing context.

    As the keys represent a single octave, multiple of them can be put together to form
    and entire piano keyboard as desired, by drawing them side by side.

    Eventually, it will become an active graphic, generating signals for each key pressed.

    It will be nice to include 'velocity' information if using a touch display.  A fatter
    finger would mean a harder press, whereas a smaller finger would mean a lighter touch.

    calibrate for size of hands.
    
    References
    https://hypertextbook.com/facts/2003/DanielleDaly.shtml
]]
GPianoKeyboard = {}
GPianoKeyboard.__index = GPianoKeyboard

local ymargin = 0;
local xmargin = 0;
local keyGap = 0;

-- scale width, height
local whiteKeyWidth = 0.143     -- 1/7 (there are 7 white keys in an octave)
local wkHalf = whiteKeyWidth/2
local whiteKeyHeight = 1

local blackKeyWidth = 0.083     -- whiteKeyWidth * .583 (black keyss are 1.4/2.4)
local blackKeyHeight = 0.666    -- .618
local bkHalf = blackKeyWidth/2

local octaveLoc = {
    -- white keys
    {name = "C", kind = "white", frame = {x=xmargin + 0*(whiteKeyWidth+keyGap), y = ymargin, width=whiteKeyWidth, height=whiteKeyHeight}};
    {name = "D", kind = "white", frame = {x=xmargin + 1*(whiteKeyWidth+keyGap), y = ymargin, width=whiteKeyWidth, height=whiteKeyHeight}};
    {name = "E", kind = "white", frame = {x=xmargin + 2*(whiteKeyWidth+keyGap), y = ymargin, width=whiteKeyWidth, height=whiteKeyHeight}};
    {name = "F", kind = "white", frame = {x=xmargin + 3*(whiteKeyWidth+keyGap), y = ymargin, width=whiteKeyWidth, height=whiteKeyHeight}};
    {name = "G", kind = "white", frame = {x=xmargin + 4*(whiteKeyWidth+keyGap), y = ymargin, width=whiteKeyWidth, height=whiteKeyHeight}};
    {name = "A", kind = "white", frame = {x=xmargin + 5*(whiteKeyWidth+keyGap), y = ymargin, width=whiteKeyWidth, height=whiteKeyHeight}};
    {name = "B", kind = "white", frame = {x=xmargin + 6*(whiteKeyWidth+keyGap), y = ymargin, width=whiteKeyWidth, height=whiteKeyHeight}};

    -- sharp keys
    {name = "C#", kind = "black", frame = {x=xmargin + (1*(1/7))-bkHalf, y = ymargin, width=blackKeyWidth, height=blackKeyHeight}};
    {name = "D#", kind = "black", frame = {x=xmargin + (2*(1/7))-bkHalf, y = ymargin, width=blackKeyWidth, height=blackKeyHeight}};
    {name = "F#", kind = "black", frame = {x=xmargin + (4*(1/7))-bkHalf, y = ymargin, width=blackKeyWidth, height=blackKeyHeight}};
    {name = "G#", kind = "black", frame = {x=xmargin + (5*(1/7))-bkHalf, y = ymargin, width=blackKeyWidth, height=blackKeyHeight}};
    {name = "A#", kind = "black", frame = {x=xmargin + (6*(1/7))-bkHalf, y = ymargin, width=blackKeyWidth, height=blackKeyHeight}};

}



function GPianoKeyboard.new(self, obj)
    local obj = obj or {}
    obj.scale = obj.scale or {x=obj.frame.width, y=obj.frame.height}

    setmetatable(obj, GPianoKeyboard)

    return obj;
end

function GPianoKeyboard.draw(self, ctx)
    ctx:push()
    ctx:scale(self.scale.x, self.scale.y)
    ctx:setTransformBeforeStroke();

    ctx:strokeWidth(1)
    ctx:stroke(0)

    --print("GPianoKeyboard.draw")
    for _, key in ipairs(octaveLoc) do
        --print(key, key.frame.x, key.frame.y, key.frame.width, key.frame.height)

        if key.kind == "white" then
            ctx:fill(220)
        else
            ctx:fill(30)
        end

        ctx:rect(key.frame.x, key.frame.y, key.frame.width, key.frame.height)
    end

    ctx:pop()
end


return GPianoKeyboard