package.path = "../?.lua;"..package.path;

--[[
    This is a generic file to try out various things ad-hoc
    meant to try and throw away
]]
local winman = require("WinMan")

local maths = require("maths")
local radians = maths.radians
local degrees = maths.degrees
local map = maths.map
local cos = math.cos
local sin = math.sin

local CheckerGraphic = require("CheckerGraphic")
local Gradient = require("Gradient")
local LinearGradient, RadialGradient = Gradient.LinearGradient, Gradient.RadialGradient
local guistyle = require("guistyle")


local desktopWidth = 1200
local desktopHeight = 1080


    --[[
    void draw(SkCanvas* canvas) {
        SkColor colors[] = { SK_ColorRED, SK_ColorBLUE };
        SkPoint horz[] = { { 0, 0 }, { 256, 0 } };
        SkPaint paint;
        paint.setShader(SkGradientShader::MakeLinear(horz, colors, nullptr, SK_ARRAY_COUNT(colors),
                SkShader::kClamp_TileMode));
        canvas->drawPaint(paint);
        paint.setBlendMode(SkBlendMode::kDstIn);
        SkColor alphas[] = { SK_ColorBLACK, SK_ColorTRANSPARENT };
        SkPoint vert[] = { { 0, 0 }, { 0, 256 } };
        paint.setShader(SkGradientShader::MakeLinear(vert, alphas, nullptr, SK_ARRAY_COUNT(alphas),
                SkShader::kClamp_TileMode));
        canvas->drawPaint(paint);
        canvas->clipRect( { 30, 30, 226, 226 } );
        canvas->drawColor(SkColorSetA(SK_ColorGREEN, 128), SkBlendMode::kSrcOver);
    }
    --]]


local function app(params)
    local win1 = WMCreateWindow(params)

    local chk = CheckerGraphic:new({
        frame = {x=0,y=0,width=256,height=256};
        columns = 32;
        rows = 32;
        color1 = 192;
        color2 = 80;
    })

    local horz = LinearGradient({
        values = {0, 0, 256, 0};
        extendMode = BL_EXTEND_MODE_REPEAT;
        stops = {
            {offset = 0.0, uint32 = 0xffff0000},
            {offset = 1.0, uint32 = 0xff0000ff}
        };
    })

    local vert = LinearGradient({
        values = {0, 0, 0, 256};
        extendMode = BL_EXTEND_MODE_REPEAT;
        stops = {
            {offset = 0.0, uint32 = 0xff000000},
            {offset = 1.0, uint32 = 0x00000000}
        };
    })


    function win1.draw(self, ctx)
        ctx = ctx or self:getDrawingContext()
        ctx:clear()
    
        -- draw checkboard pattern
        chk:draw(ctx)

        ctx:setFillStyle(horz);
        ctx:fillAll();

        -- inset
        ctx:setFillStyle(vert)
        ctx:fillAll();

        ctx:setCompOp(BL_COMP_OP_DST_IN)
        ctx:clip(30,30,256-60,256-60)
        ctx:setFillStyle(0xff00ff00)
        ctx:fillAll();
    end



    win1:show()

    local function drawproc()
        win1:draw()
    end

    periodic(1000/10, drawproc)
--[[
    while true do 
        win1:draw()
        yield()
    end
--]]
end


local function startup()
    spawn(app, {frame = {x=40, y=40, width=256, height=256}})
end

winman {width = desktopWidth, height=desktopHeight, startup = startup, frameRate=30}
