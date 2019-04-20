--[[
    This single file represents the guts of a processing/p5 skin
    The code will be very familiar to anyone who's used to doing processing,
    but done with a Lua flavor.
    

    Typical usage:

    -- This first line MUST come before any user code
    require("p5")

    function mouseMoved(event)
        print("MOVE: ", event.x, event.y)
    end

    -- This MUST be the last line of the user code
    go {width=700, height=400}

    Reources
    https://natureofcode.com/
]]
local ffi = require("ffi")
local C = ffi.C 

local bit = require("bit")
local band, bor = bit.band, bit.bor
local rshift, lshift = bit.rshift, bit.lshift;

local win32 = require("win32")
local sched = require("scheduler")
local BLDIBSection = require("BLDIBSection")
require("p5_blend2d")

local exports = {}
local lonMessage = false;
local SWatch = StopWatch();


-- Global things
-- Constants
HALF_PI = math.pi / 2
PI = math.pi
QUARTER_PI = math.pi/4
TWO_PI = math.pi * 2
TAU = TWO_PI

-- angleMode
DEGREES = 1;
RADIANS = 2;


-- Constants related to colors
-- colorMode
RGB = 1;
HSB = 2;

-- rectMode, ellipseMode
CORNER = 1;
CORNERS = 2;
RADIUS = 3;
CENTER = 4;

-- kind of close (for polygon)
STROKE = 0;
CLOSE = 1;

-- alignment
CENTER      = 0x00;
LEFT        = 0x01;
RIGHT       = 0x04;
TOP         = 0x10;
BOTTOM      = 0x40;
BASELINE    = 0x80;

MODEL = 1;
SCREEN = 2;
SHAPE = 3;

-- GEOMETRY
POINTS          = 0;
LINES           = 1;
LINE_STRIP      = 2;
LINE_LOOP       = 3;
POLYGON         = 4;
QUADS           = 5;
QUAD_STRIP      = 6;
TRIANGLES       = 7;
TRIANGLE_STRIP  = 8;
TRIANGLE_FAN    = 9;

-- Useful data types
ffi.cdef[[
struct PVector {
    double x;
    double y;
};
]]
PVector = ffi.typeof("struct PVector")
ffi.metatype(PVector, {
    __index = {
        add = function(self, other)
            self.x = self.x + other.x;
            self.y = self.y + other.y;
        end;

        sub = function(self, other)
            self.x = self.x - other.x;
            self.y = self.y - other.y;
        end;
    }
})



-- environment
frameCount = 0;
focused = false;
displayWidth = false;
displayHeight = false;
windowWidth = false;
windowHeight = false;
width = false;
height = false;

-- Mouse state changing live
mouseX = false;
mouseY = false;
pMouseX = false;
pMouseY = false;
winMouseX = false;
winMouseY = false;
pwinMouseX = false;
pwinMouseY = false;
mouseButton = false;
mouseIsPressed = false;
-- to be implemented by user code
-- mouseMoved()
-- mouseDragged()
-- mousePressed()
-- mouseReleased()
-- mouseClicked()
-- doubleClicked()
-- mouseWheel()

-- Keyboard state changing live
keyIsPressed = false;
key = false;
keyCode = false;
-- to be implemented by client code
-- keyPressed()
-- keyReleased()
-- keyTyped()


-- Touch events
touches = false;
-- touchStarted()
-- touchMoved()
-- touchEnded()

-- Initial State for modes
AngleMode = RADIANS;
ColorMode = RGB;
RectMode = CORNER;
EllipseMode = CENTER;
ShapeMode = POLYGON;

FrameRate = 15;
LoopActive = true;
EnvironmentReady = false;

-- Typography
TextSize = 12;
TextHAlignment = LEFT;
TextVAlignment = BASELINE;
TextLeading = 0;
TextMode = SCREEN;
TextSize = 12;


StrokeWidth = 0;
StrokeWeight = 1;

--[[
    These are functions that are globally available, so user code
    can use them.  These functions don't rely specifically on the 
    drawing interface, so that can remain here in case the drawing
    driver changes.
]]

--[[
    MATHS
]]


function lerp(low, high, x)
    return low + x*(high-low)
end

function mag(x, y)
    return sqrt(x*x +y*y)
end

function map(x, olow, ohigh, rlow, rhigh)
    rlow = rlow or olow
    rhigh = rhigh or ohigh
    return rlow + (x-olow)*((rhigh-rlow)/(ohigh-olow))
end

function noise(x,y,z)
    if z ~= nil then
        return simplex.Noise3(x,y,z)
    end

    if y and z ~= nil then
        return simplex.Noise2(x,y)
    end

    if x ~= 0 then 
        return simplex.Noise1(x)
    end

    return 0
end

function sq(x)
    return x*x
end

abs = math.abs
asin = math.asin
acos = math.acos
atan = math.atan

function atan2(y,x)
    return atan(y/x)
end

ceil = math.ceil

function constrain(x, low, high)
    return math.min(math.max(x, low), high)
end
clamp = constrain
cos = math.cos

degrees = math.deg

function dist(x1, y1, x2, y2)
    return math.sqrt(sq(x2-x1) + sq(y2-y1))
end

exp = math.exp
floor = math.floor
log = math.log
max = math.max
min = math.min

function norm(val, low, high)
    return map(value, low, high, 0, 1)
end

function pow(x,y)
    return x^y;
end

radians = math.rad
random = math.random

function round(n)
	if n >= 0 then
		return floor(n+0.5)
	end

	return ceil(n-0.5)
end

sin = math.sin
sqrt = math.sqrt





--[[
    COLOR
]]
function color(...)
	local nargs = select('#', ...)

	-- There can be 1, 2, 3, or 4, arguments
	--	print("Color.new - ", nargs)
	
	local r = 0
	local g = 0
	local b = 0
	local a = 255
	
	if (nargs == 1) then
			r = select(1,...)
			g = r
			b = r
			a = 255;
	elseif nargs == 2 then
			r = select(1,...)
			g = r
			b = r
			a = select(2,...)
	elseif nargs == 3 then
			r = select(1,...)
			g = select(2,...)
			b = select(3,...)
			a = 255
	elseif nargs == 4 then
		r = select(1,...)
		g = select(2,...)
		b = select(3,...)
		a = select(4,...)
    end
    
    local pix = BLRgba32()
--print("r,g,b: ", r,g,b)
    pix.r = r
    pix.g = g
    pix.b = b 
    pix.a = a

	return pix;
end


function blue(c)
	return c.b
end

function green(c)
	return c.g
end

function red(c)
	return c.r
end

function alpha(c)
	return c.a
end

-- Modes to be honored by various drawing APIs
function angleMode(newMode)
    if newMode ~= DEGREES and newMode ~= RADIANS then 
        return false 
    end

    AngleMode = newMode;

    return true;
end

function ellipseMode(newMode)
    EllipseMode = newMode;
end

function rectMode(newMode)
    RectMode = newMode;
end

-- Image handling
function loadImage(filename)
    local img, err = targa.readFromFile(filename)
    if not img then 
        return false, err
    end
    return img
end

-- timing
function seconds()
    return SWatch:seconds();
end

function millis()
    -- get millis from p5 stopwatch
    return SWatch:millis();
end

function frameRate(...)
    if select('#', ...) == 0 then
        return FrameRate;
    end

    if type(select(1,...)) ~= "number" then
        return false, 'must specify a numeric frame rate'
    end

    FrameRate = select(1,...);

    -- reset frame timer
end

function loop()
    LoopActive = true;
end

function noLoop()
    LoopActive = false;
end

-- Drawing and canvas management
-- BOOL InvalidateRect(HWND hWnd, const RECT *lpRect, BOOL bErase);
local function invalidateWindow(lpRect, bErase)
    local erase = 1
    if not bErase then
        erase = 0
    end

	local res = C.InvalidateRect(appWindowHandle, lpRect, erase)
end

function refreshWindow()
    --appWindow:redraw(bor(ffi.C.RDW_UPDATENOW, ffi.C.RDW_INTERNALPAINT))
    --appWindow:redraw(bor(ffi.C.RDW_INTERNALPAINT))
    invalidateWindow(lpRect, false);

    return true;
end

function redraw()
    if draw then
        draw();
        if surface then
            appContext:flush();
        end
    end

    refreshWindow();

    return true;
end








-- encapsulate a mouse event
local function wm_mouse_event(hwnd, msg, wparam, lparam)
    -- assign previous mouse position
    if mouseX then pmouseX = mouseX end
    if mouseY then pmouseY = mouseY end

    -- assign new mouse position
    mouseX = tonumber(band(lparam,0x0000ffff));
    mouseY = tonumber(rshift(band(lparam, 0xffff0000),16));

    local event = {
        x = mouseX;
        y = mouseY;
        control = band(wparam, C.MK_CONTROL) ~= 0;
        shift = band(wparam, C.MK_SHIFT) ~= 0;
        lbutton = band(wparam, C.MK_LBUTTON) ~= 0;
        rbutton = band(wparam, C.MK_RBUTTON) ~= 0;
        mbutton = band(wparam, C.MK_MBUTTON) ~= 0;
        xbutton1 = band(wparam, C.MK_XBUTTON1) ~= 0;
        xbutton2 = band(wparam, C.MK_XBUTTON2) ~= 0;
    }

    mousePressed = event.lbutton or event.rbutton or event.mbutton;

    return event;
end

function MouseActivity(hwnd, msg, wparam, lparam)
    local res = 1;

    local event = wm_mouse_event(hwnd, msg, wparam, lparam)


    if msg == ffi.C.WM_MOUSEMOVE  then
        event.activity = 'mousemove'
        if mousePressed then
            signalAll('gap_mousedrag')
        end
        signalAll('gap_mousemove', event)
    elseif msg == ffi.C.WM_LBUTTONDOWN or 
        msg == ffi.C.WM_RBUTTONDOWN or
        msg == ffi.C.WM_MBUTTONDOWN or
        msg == ffi.C.WM_XBUTTONDOWN then
        event.activity = 'mousedown';
        signalAll('gap_mousedown', event)
    elseif msg == ffi.C.WM_LBUTTONUP or
        msg == ffi.C.WM_RBUTTONUP or
        msg == ffi.C.WM_MBUTTONUP or
        msg == ffi.C.WM_XBUTTONUP then
        event.activity = 'mouseup'
        signalAll('gap_mouseup', event)
        signalAll('gap_mouseclick', event)
    elseif msg == ffi.C.WM_MOUSEWHEEL then
        event.activity = 'mousewheel';
        signalAll('gap_mousewheel', event)
    elseif msg == ffi.C.WM_MOUSELEAVE then
        --print("WM_MOUSELEAVE")
    else
        res = C.DefWindowProcA(hwnd, msg, wparam, lparam);
    end

    return res;
end


-- encapsulate a keyboard event
local function wm_keyboard_event(hwnd, msg, wparam, lparam)

    local event = {
        keyCode = wparam;
        repeatCount = band(lparam, 0xffff);  -- 0 - 15
        scanCode = rshift(band(lparam, 0xff0000),16);      -- 16 - 23
        isExtended = band(lparam, 0x1000000) ~= 0;    -- 24
        wasDown = band(lparam, 0x40000000) ~= 0; -- 30
    }

    return event;
end


function KeyboardActivity(hwnd, msg, wparam, lparam)
    --print("onKeyboardActivity")
    local res = 1;

    local event = wm_keyboard_event(hwnd, msg, wparam, lparam)

    if msg == C.WM_KEYDOWN or 
        msg == C.WM_SYSKEYDOWN then
        event.activity = "keydown"
        keyCode = event.keyCode
        signalAll('gap_keydown', event)
    elseif msg == C.WM_KEYUP or
        msg == C.WM_SYSKEYUP then
        event.activity = "keyup"
        keyCode = event.keyCode
        signalAll("gap_keyup", event)
    elseif msg == C.WM_CHAR or
        msg == C.WM_SYSCHAR then
        event.activity = "keytyped"
        keyChar = wparam
        signalAll("gap_keytyped", event) 
    else 
        res = C.DefWindowProcA(hwnd, msg, wparam, lparam);
    end

    return res;
end

--[=[
local function wm_joystick_event(hwnd, msg, wParam, lParam)
    local event = {
        Buttons = wParam;
        x = LOWORD(lParam);
        y = HIWORD(lParam);
    }

    if msg == C.MM_JOY1BUTTONDOWN or
    msg == C.MM_JOY2BUTTONDOWN then
        event.Buttons = wParam;
    elseif msg == C.MM_JOY1BUTTONUP or
    msg == C.MM_JOY2BUTTONUP then
        event.Buttons = wParam;
    elseif msg == C.MM_JOY1MOVE or 
        msg == C.MM_JOY2MOVE then
    elseif msg == C.MM_JOY1ZMOVE or
        msg == C.MM_JOY2ZMOVE then
    end


    return event
end

function JoystickActivity(hwnd, msg, wparam, lparam)
    --print("JoystickActivity: ", msg, wparam, lparam)
    local res = 1;

    local event = wm_joystick_event(hwnd, msg, wparam, lparam)

    if msg == C.MM_JOY1BUTTONDOWN or 
        msg == C.MM_JOY2BUTTONDOWN then
        signalAll("gap_joydown", event)
    elseif msg == C.MM_JOY1BUTTONUP or msg == C.MM_JOY2BUTTONUP then
        signalAll("gap_joyup", event)
    elseif msg == C.MM_JOY1MOVE or msg == C.MM_JOY2MOVE then
        signalAll("gap_joymove", event)
    elseif msg == C.MM_JOY1ZMOVE or msg == C.MM_JOY2ZMOVE then
        event.z = LOWORD(lparam)
        signalAll("gap_joyzmove", event)
    end

    return res;
end
--]=]
function CommandActivity(hwnd, msg, wparam, lparam)
    if onCommand then
        onCommand({source = tonumber(HIWORD(wparam)), id=tonumber(LOWORD(wparam))})
    end
end




local ps = ffi.new("PAINTSTRUCT");

local function WindowProc(hwnd, msg, wparam, lparam)
    --print(string.format("WindowProc: msg: 0x%x, %s", msg, wmmsgs[msg]), wparam, lparam)

    local res = 1;

    if msg == C.WM_DESTROY then
        C.PostQuitMessage(0);
        signalAllImmediate('gap_quitting');
        return 0;
    elseif msg >= C.WM_MOUSEFIRST and msg <= C.WM_MOUSELAST then
        res = MouseActivity(hwnd, msg, wparam, lparam)
    elseif msg >= C.WM_KEYFIRST and msg <= C.WM_KEYLAST then
        res = KeyboardActivity(hwnd, msg, wparam, lparam)
    elseif msg >= C.MM_JOY1MOVE and msg <= C.MM_JOY2BUTTONUP then
        res = JoystickActivity(hwnd, msg, wparam, lparam)
    --elseif msg == C.WM_COMMAND then
    --    res = CommandActivity(hwnd, msg, wparam, lparam)
---[[
    elseif msg == C.WM_ERASEBKGND then
        local hdc = ffi.cast("HDC", wparam); 
        --GetClientRect(hwnd, &rc); 
        --SetMapMode(hdc, MM_ANISOTROPIC); 
        --SetWindowExtEx(hdc, 100, 100, NULL); 
        --SetViewportExtEx(hdc, rc.right, rc.bottom, NULL); 
        --FillRect(hdc, &rc, hbrWhite); 
        --print("ERASE")
        res = 1; 
--]]
    elseif msg == C.WM_PAINT then
        -- bitblt backing store to client area
        --print("WindowProc.WM_PAINT:", wparam, lparam)

        local ps = ffi.new("PAINTSTRUCT");
		local hdc = C.BeginPaint(hwnd, ps);
        --print("PAINT: ", hdc, ps.rcPaint.left, ps.rcPaint.top,ps.rcPaint.right, ps.rcPaint.bottom)


        if surface then
            local imgSize = appImage:size()

            local bResult = C.StretchDIBits(appDC,
                0,0,
                imgSize.w,imgSize.h,
                0,0,
                imgSize.w, imgSize.h,
                surface.pixelData.data,surface.info,
                C.DIB_RGB_COLORS,C.SRCCOPY)
            -- the bResult is the number of scanlines drawn
            -- there's a failure, this will be 0
        end


        C.EndPaint(hwnd, ps);
        res = 0
    else
        res = C.DefWindowProcA(hwnd, msg, wparam, lparam);
    end

--[[

    elseif msg == ffi.C.WM_SETFOCUS then
        --print("WM_SETFOCUS")
        focused = true;
    elseif msg == ffi.C.WM_KILLFOCUS then
        --print("WM_KILLFOCUS")
        focused = false;
    end
--]]

	return res
end
jit.off(WindowProc)




local function msgLoop()
    --  create some a loop to process window messages
    --print("msgLoop - BEGIN")
    local msg = ffi.new("MSG")
    local res = 0;

    while (true) do
        --print("LOOP")
        -- we use peekmessage, so we don't stall on a GetMessage
        while (C.PeekMessageA(msg, nil, 0, 0, C.PM_REMOVE) ~= 0) do
            --print(string.format("Loop Message: 0x%x", msg.message), wmmsgs[msg.message])            
            if lonMessage then
                lonMessage(msg);
            end
            
            -- If we see a quit message, it's time to stop the program
            -- ideally we'd call an 'onQuit' and wait for that to return
            -- before actually halting.  That will give the app a chance
            -- to do some cleanup
            if msg.message == C.WM_QUIT then
                print("msgLoop - QUIT")
                halt();
            end

            res = C.TranslateMessage(msg)
            res = C.DispatchMessageA(msg)
        end

        yield();
    end

    --print("msgLoop - END")        
end


local function createWindow(params)
    params = params or {width=1024, height=768, title="GraphicApplication"}
    params.width = params.width or 1024;
    params.height = params.height or 768;
    params.title = params.title or "Blend2d App";

    -- set global variables
    width = params.width;
    height = params.height;

    -- You MUST register a window class before you can use it.
    local winclassname = "bs2appwindow"
    local winatom, err = win32.RegisterWindowClass(winclassname, WindowProc)

    if not winatom then
        print("Window class not registered: ", err);
        return false, err;
    end

    -- create an instance of a window
    winHandle, err = win32.CreateWindowHandle(winclassname, 
        params.title, 
        params.width, params.height, 
        winstyle, 
        x, y)
    
    print("appWindowHandle, err: ", winHandle, err)

    if not winHandle then
        print("TRIPPING")
        return false, err
    end
    appDC = C.GetDC(winHandle)
    
    return winHandle
end

-- Register UI event handler global functions
-- These are the functions that the user should implement
-- in their code
-- the user implements a global function with the name
-- listed on the 'response' side.
local function setupUIHandlers()
    local handlers = {
        {activity = 'gap_mousemove', response = "mouseMoved"};
        {activity = 'gap_mouseup', response = "mouseReleased"};
        {activity = 'gap_mousedown', response = "mousePressed"};
        {activity = 'gap_mousedrag', response = 'mouseDragged'};
        {activity = 'gap_mousewheel', response = "mouseWheel"};
        {activity = 'gap_mouseclick', response = "mouseClicked"};

        {activity = 'gap_keydown', response = "keyPressed"};
        {activity = 'gap_keyup', response = "keyReleased"};
        {activity = 'gap_keytyped', response = "keyTyped"};

        {activity = 'gap_syskeydown', response = "sysKeyPressed"};
        {activity = 'gap_syskeyup', response = "sysKeyReleased"};
        {activity = 'gap_syskeytyped', response = "sysKeyTyped"};

        {activity = 'gap_joymove', response = "joyMoved"};
        {activity = 'gap_joyzmove', response = "joyZMoved"};
        {activity = 'gap_joyup', response = "joyReleased"};
        {activity = 'gap_joydown', response = "joyPressed"};


        {activity = 'gap_idle', response = "onIdle"};
        --{activity = 'gap_frame', response = "draw"};
    }

    for i, handler in ipairs(handlers) do
        --print("response: ", handler.response, _G[handler.response])
        if _G[handler.response] ~= nil then
            on(handler.activity, _G[handler.response])
        end
    end

end

local function handleFrame()
    if LoopActive and EnvironmentReady then
        if draw then
            redraw();
        end
        frameCount = frameCount + 1;
    end
end

local function showWindow()
    C.ShowWindow(appWindowHandle, C.SW_SHOWNORMAL);
end

local function main(params)

    FrameRate = params.frameRate or 15;

    -- make a local for 'onMessage' global function    
    if onMessage then
        lonMessage = onMessage;
    end

    -- Setup for Blend2D drawing
    surface, err = BLDIBSection(params)
    appImage = surface.Image
    appContext = BLContext(appImage)

    -- Start things rolling
    spawn(msgLoop);

    yield();

    appWindowHandle,err = createWindow(params)
    showWindow();

    setupUIHandlers();

    yield();

    EnvironmentReady = true;

    if setup then
        setup();
    end
    redraw();
    yield();

    -- setup the periodic frame calling
    local framePeriod = math.floor(1000/FrameRate)
    periodic(framePeriod, handleFrame)

    signalAll("gap_ready");
end


function go(params)
    params = params or {
        width = 640;
        height = 480;
        title = "Blend2d App"
    }
    params.width = params.width or 640;
    params.height = params.height or 480;
    params.title = params.title or "Blend2d App";
    params.frameRate = params.frameRate or 15;

    run(main, params)
end

