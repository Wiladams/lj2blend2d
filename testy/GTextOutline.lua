local GTextOutline = {}
local GTextOutline_mt = {
    __index = GTextOutline;
}

function GTextOutline.new(self, obj)
    obj = obj or {
        frame = {x=0,y=0,width=400,height=400};
    }

    setmetatable(obj, GTextOutline_mt)

    return obj;
end

function GTextOutline.draw(self, ctx)
    ctx:save()

    local text = "quick BROQ jumped fox"

    ctx:textSize(96);
    ctx:textAlign(LEFT, BASELINE)
    
    
    -- fill text
    ctx:fill(0)
    ctx:text(text, 4, 100)

    -- then stroke it
    ctx:stroke(255,0,0)
    ctx:strokeWidth(1)

    ctx:textOutline(text, 4, 100)
    
    ctx:restore()
end

return GTextOutline
