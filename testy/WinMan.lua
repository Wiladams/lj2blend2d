--[[
    This single file represents the guts of a desktop windowing environment

    

    Typical usage:

    -- This first line MUST come before any user code
    require("WinMan")

    -- This MUST be the last line of the user code
    go {width=700, height=400}


    This will essentially create a desktop environment ready for windows and other 
    graphics to be created.


    window:new()

    A note about Drawing 'out of band'
    Since we draw based on a framerate, it's important to draw when we want to.
    In that case, we use the user32 call: RedrawWindow, and all our drawing
    happens inside the WM_ERASEBKGND message.

    We do this instead of relying on WM_PAINT, because that one is posted and proessed 
    in a non-deterministic way.  Using Redraw and the background, we can ensure an sync
    call to drawing, which gets us closer to our frame rate.

    Useful for the future
    https://blog.getpaint.net/2017/08/12/win32-how-to-get-the-refresh-rate-for-a-window/
]]
local ffi = require("ffi")
local C = ffi.C 

local bit = require("bit")
local band, bor = bit.band, bit.bor
local rshift, lshift = bit.rshift, bit.lshift;

local win32 = require("win32")
local sched = require("scheduler")


local BLDIBSection = require("BLDIBSection")
local GraphicGroup = require("GraphicGroup")
local Window = require("Window")
local CheckerGraphic = require("CheckerGraphic")
local DrawingContext = require("DrawingContext")

DrawingContext:exportConstants()



local LOWORD = win32.LOWORD
local HIWORD = win32.HIWORD

local SWatch = StopWatch();

--[[
    Global state for applications
]]
frameCount = 0;
FrameRate = 30;

mouseX = 0;
mouseY = 0;


-- Internal State
local appSurface = nil;
local appContext = nil;
local appBackground = nil;
local appImage = nil;
local appWindowHandle = nil;
local appWindowDC = nil;
local EnvironmentReady = false;
local appDC = nil;



-- The GraphicGroup representing subsequent windows that
-- are added to the environment
local windowGroup = {}
local wmFocusWindow = nil;
local wmLastMouseWindow = nil;


-- Raw input utility functions
local HID_MOUSE    = 2;
local HID_KEYBOARD = 6;

-- Register for mouse and keyboard
local function HID_RegisterDevice(hTarget, usage, onlyWindow)
    
    local hid = ffi.new("RAWINPUTDEVICE");
    hid.usUsagePage = 1;
    hid.usUsage = usage;
    hid.dwFlags = bor(C.RIDEV_DEVNOTIFY , C.RIDEV_INPUTSINK);
    hid.hwndTarget = hTarget;

    local bResult = C.RegisterRawInputDevices(hid, 1, ffi.sizeof("RAWINPUTDEVICE"));
    print("HID_RegisterDevice: ", hTarget, bResult, C.GetLastError())
end

local function HID_UnregisterDevice(usage)
    local hid = ffi.new("RAWINPUTDEVICE");
    hid.usUsagePage = 1;
    hid.usUsage = usage;
    hid.dwFlags = C.RIDEV_REMOVE;
    hid.hwndTarget = nil;

    C.RegisterRawInputDevices(hid, 1, ffi.sizeof("RAWINPUTDEVICE"));
end

function WMSetWallpaper(bkgnd)
    appBackground = bkgnd
end

function WMScreenToWin(win, x, y)
    return x-win.frame.x, y-win.frame.y
end

function WMSetFocus(win)
    if win then
        if wmFocusWindow then
            wmFocusWindow:loseFocus()
        end
        win:setFocus()
    else
        if wmFocusWindow then
            wmFocusWindow:loseFocus()
        end
    end

    wmFocusWindow = win
end

function WMWindowAt(x, y)
    local function contains(frame, x, y)
        return x >= frame.x and x < frame.x+frame.width and
            y >= frame.y and y < frame.y+frame.height
    end

    for i = #windowGroup, 1, -1 do
        win = windowGroup[i]
        if contains(win.frame, x, y) then
            return win
        end
    end

    return nil;
end


-- Global Functions
-- Create a WinMan window
function WMCreateWindow(params)
    local win = Window:new (params)

    table.insert(windowGroup, win)
    --windowGroup:add(win)

    return win
end


-- Internal functions
function refreshWindow()

    -- doing the RedrawWindow() method, with RDW_ERASENOW ensures that the 
    -- WM_ERASEBKGND message is sent and dealt with synchronously, so we make
    -- sure we're not waiting for WM_PAINT messages, which can show up at random
    -- times, not based on our animation clock.
    local lprcUpdate = nil;	-- const RECT *
	local hrgnUpdate = nil; -- HRGN
	local flags = flags or bor(C.RDW_ERASE, C.RDW_INVALIDATE, C.RDW_ERASENOW);

    -- force an immediate redraw of the window
	local success = C.RedrawWindow(
  		appWindowHandle,
  		lprcUpdate,
   		hrgnUpdate,
        flags)~= 0;

    -- Using the UpdateLayeredWindow approach can be even more useful as we can
    -- create a bitmap that represents the backing store of the window, and just
    -- allow windows to compose that.  This would save us one Blt of the appImage
    -- to the Window DC, because the AppImage would just be handed to the window
    -- compositor directly.
    -- We can extend the appImage to contain the complete
    -- size of the window plus chrome, and then it can be this bitmap.
--[[
    local hdcDst = nil;     -- default palette is fine
    local pptDst = nil;     -- we're not changing position
    local psize  = nil;     -- we're not repositioning the window
    local hdcSrc = nil;     -- we're doing drawing, so this should be set
    local pptSrc = nil;
    local crKey = 0;
    local pblend = ffi.new("BLENDFUNCTION");
    pblend.BlendOp = C.AC_SRC_OVER;
    pblend.BlendFlags = 0
    pblend.SourceConstantAlpha = 255;
    pblend.AlphaFormat = C.AC_SRC_ALPHA;

    local dwFlags = C.ULW_ALPHA;

    local success = C.UpdateLayeredWindow(appWindowHandle, hdcDst,
        pptDst, psize, hdcSrc, pptSrc,
        crKey,
        pblend,
        dwFlags) ~= 0;
    
--]]
    return success;
end


--[[
    WinMan is a drawing environment based on the concept of a frame.
    There is a system clock that will periodically call handleFrame() 
    at a specified period.

    Within handleFrame, we readraw the entire desktop, by compositing
    the individual windows and various and sundry other drawing tasks
    that are appropriate to the desktop.
]]
local function handleFrame()
    if not EnvironmentReady then return end

    frameCount = frameCount + 1;
    --print("handleFrame: ", frameCount, #windowGroup.children)



    -- Clear the app context so we start with a clean slate
    appContext:clear()

    if appBackground then
        appBackground:draw(appContext)
    end

    -- iterate through the windows
    -- compositing each one
    for _, win in ipairs(windowGroup) do
        -- if we don't want transparent windows
        -- then src_copy
        -- there can be a per-window attribute for this
        -- and other composite operations
        --appContext:setCompOp(C.BL_COMP_OP_SRC_COPY)
        appContext:setCompOp(C.BL_COMP_OP_SRC_OVER)

        local readyBuff = win:getReadyBuffer()
        if readyBuff then
            appContext:blit(readyBuff, win.frame.x, win.frame.y)
        end
    end

    -- force a redraw to the screen
    refreshWindow()
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
        screenX = mouseX;
        screenY = mouseY;
        parentX = mouseX;
        parentY = mouseY;

        control = band(wparam, C.MK_CONTROL) ~= 0;
        shift = band(wparam, C.MK_SHIFT) ~= 0;
        lbutton = band(wparam, C.MK_LBUTTON) ~= 0;
        rbutton = band(wparam, C.MK_RBUTTON) ~= 0;
        mbutton = band(wparam, C.MK_MBUTTON) ~= 0;
        xbutton1 = band(wparam, C.MK_XBUTTON1) ~= 0;
        xbutton2 = band(wparam, C.MK_XBUTTON2) ~= 0;
    }

    mousePressed = event.lbutton or event.rbutton or event.mbutton;

    if msg == C.WM_MOUSEMOVE  then
        event.activity = 'mousemove'
        if mousePressed then
            event.isDragging = true;
        end
    elseif msg == C.WM_LBUTTONDOWN or 
        msg == C.WM_RBUTTONDOWN or
        msg == C.WM_MBUTTONDOWN or
        msg == C.WM_XBUTTONDOWN then
        event.activity = 'mousedown';
    elseif msg == C.WM_LBUTTONUP or
        msg == C.WM_RBUTTONUP or
        msg == C.WM_MBUTTONUP or
        msg == C.WM_XBUTTONUP then
        event.activity = 'mouseup'
    elseif msg == C.WM_MOUSEWHEEL then
        event.activity = 'mousewheel';
    elseif msg == C.WM_MOUSELEAVE then
        event.activity = "mouseleave"
    else
        res = C.DefWindowProcA(hwnd, msg, wparam, lparam);
        return false, res
    end

    return event;
end

--[[
    Here in MouseActivity, we're concerned with dealing with event
    propagation.  Here we decide which window has 'focus', where events
    are sent to, when they are used to change focus, etc.

    One key operation is to turn the mouse eventfrom 'screen' coordinates
    to window coordinates.  That way the window can deal with the mouse
    actvity in their own coordinate space.
--]]
function MouseActivity(hwnd, msg, wparam, lparam)
    local res = 0;

    local event, res = wm_mouse_event(hwnd, msg, wparam, lparam)

    if not event then
        return res;
    end

    -- find topmost window for mouse
    local win = WMWindowAt(mouseX, mouseY)
    --print("mouse: ", mouseX, mouseY, win)
    
    if win then
        local x, y = WMScreenToWin(win, event.parentX, event.parentY)
        event.x = x;
        event.y = y;
    end

    if event.activity == "mousemove" then
        if win then
            if win == wmFocusWindow then
                win:mouseEvent(event)
            else
                event.activity = "mousehover"
                win:mouseEvent(event)
            end
        end
    elseif event.activity == "mousedown" then
        if win then
            if win ~= wmFocusWindow then
                WMSetFocus(win)
            end
            win:mouseEvent(event)
        else
            WMSetFocus(nil)
        end
    elseif event.activity == "mouseup" then
        if win then
            if win == wmFocusWindow then
                win:mouseEvent(event)
            else
                WMSetFocus(win)
            end
        else
            WMSetFocus(nil)
        end
    else
        if win and win == wmFocusWindow then
            win:mouseEvent(event)
        end
    end

    wmLastMouseWindow = win;

    return 0;
end

function KeyboardActivity(hwnd, msg, wparam, lparam)
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
    
    
    --print("onKeyboardActivity")
    local res = 0;

    local event = wm_keyboard_event(hwnd, msg, wparam, lparam)

    --print("event.keyCode: ", string.format("0x%x",event.keyCode), event.activity)

    if msg == C.WM_KEYDOWN or 
        msg == C.WM_SYSKEYDOWN then
        event.activity = "keydown"
        if wmFocusWindow then
            wmFocusWindow:keyEvent(event)
        end
    elseif msg == C.WM_KEYUP or
        msg == C.WM_SYSKEYUP then
        event.activity = "keyup"
        if wmFocusWindow then
            wmFocusWindow:keyEvent(event)
        end
    elseif msg == C.WM_CHAR or
        msg == C.WM_SYSCHAR then
        event.activity = "keytyped"
        event.keyChar = wparam
        if wmFocusWindow then
            wmFocusWindow:keyEvent(event)
        end
    else 
        res = C.DefWindowProcA(hwnd, msg, wparam, lparam);
    end

    --print("event.keyCode: ", msg, string.format("0x%x",event.keyCode), event.activity)

    return res;
end


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
    local res = 0;

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

function CommandActivity(hwnd, msg, wparam, lparam)
    if onCommand then
        onCommand({source = tonumber(HIWORD(wparam)), id=tonumber(LOWORD(wparam))})
    end

    return 0
end

function TouchActivity(hwnd, msg, wparam, lparam)
    --print("TouchActivity - 1.0")
    local function wm_touch_event()
        -- cInputs could be set to a maximum value (10) and
        -- we could reuse the same allocated array each time
        -- rather than allocating a new one each time.
        --print("wm_touch_event 0.0: ", wparam)
        local cInputs = tonumber(LOWORD(wparam))
        --print("wm_touch_event 1.0: ", cInputs)
        local pInputs = ffi.new("TOUCHINPUT[?]", cInputs)
        local cbSize = ffi.sizeof("TOUCHINPUT")
        --print("wm_touch_event 2.0: ", pInputs, cbSize)
        local bResult = C.GetTouchInputInfo(ffi.cast("HTOUCHINPUT",lparam), cInputs, pInputs,cbSize);
        --print("wm_touch_event 3.0: ", bResult)

        if bResult == 0 then
            return nil, C.GetLastError()
        end
        --print("wm_touch_event 4.0: ", bResult)

        -- Construct an event with all the given information
        local events = {}
        local PT = ffi.new("POINT")
        for i=0,cInputs-1 do
            PT.x = pInputs[i].x/100;
            PT.y = pInputs[i].y/100;
            --print("wm_touch_event 4.1: ", PT.x, PT.y)
            local bResult = C.ScreenToClient(hwnd, PT)
            --print("wm_touch_event 4.2: ", bResult, PT.x, PT.y)
            local event = {
                ID = pInputs[i].dwID;
                x = PT.x;
                y = PT.y;
                rawX = pInputs[i].x;
                rawY = pInputs[i].y;
            }

            if band(pInputs[i].dwMask, C.TOUCHINPUTMASKF_CONTACTAREA) ~= 0 then
                event.rawWidth = pInputs[i].cxContact;
                event.rawHeight = pInputs[i].cyContact;
                event.width = event.rawWidth/100;
                event.height = event.rawHeight/100;
            end

            table.insert(events, event)
        end
        --print("wm_touch_event 5.0: ", bResult)

        return events
    end

    --print("TouchActivity - 2.0")
    local events, err = wm_touch_event()
    --print("TouchActivity - 3.0")
    if events then
        signalAll("gap_touch", events)
    end

    --print("TouchActivity - 4.0")
    local bResult = C.CloseTouchInputHandle(ffi.cast("HTOUCHINPUT",lparam))
    --print("TouchActivity - 5.0")
    
    return 0
end


function GestureActivity(hwnd, msg, wparam, lparam)

    local pGestureInfo = ffi.new("GESTUREINFO")
    pGestureInfo.cbSize = ffi.sizeof("GESTUREINFO")

    local bResult = C.GetGestureInfo(ffi.cast("HGESTUREINFO",lparam), pGestureInfo);

    print("GestureActivity: ", pGestureInfo.dwID)

    if bResult == 0 then
        -- error getting gestureinfo, so just pass through 
        -- to default and return that result
        return C.DefWindowProcA(hwnd, msg, wparam, lparam);
    end

    -- Pass these through for default handling
    if pGestureInfo.dwID == C.GID_BEGIN or pGestureInfo.dwID == C.GID_END then
        res = C.DefWindowProcA(hwnd, msg, wparam, lparam);
        return res;
    end

    local event = {
        ID = pGestureInfo.dwID;
        x = pGestureInfo.ptsLocation.x;
        y = pGestureInfo.ptsLocation.y;
        instance = pGestureInfo.dwInstanceID;
        sequence = pGestureInfo.dwSequenceID;
        arguments = pGestureInfo.ullArguments;
        flags = pGestureInfo.dwFlags;
    }

    local bResult = C.CloseGestureInfoHandle(ffi.cast("HGESTUREINFO",lparam))
    
    signalAll("gap_gesture", event)

    return 0
end


local ps = ffi.new("PAINTSTRUCT");

local function WindowProc(hwnd, msg, wparam, lparam)
    --print(string.format("WindowProc: msg: 0x%x, %s", msg, wmmsgs[msg]), wparam, lparam)

    local res = 0;

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
    elseif msg == C.WM_TOUCH then
        res = TouchActivity(hwnd, msg, wparam, lparam)
    elseif msg == C.WM_GESTURE then
        res = GestureActivity(hwnd, msg, wparam, lparam)
    elseif msg == C.WM_INPUT then
        -- do stuff with raw input
        print("WM_INPUT")
    elseif msg == C.WM_ERASEBKGND then
        --print("WM_ERASEBKGND: ", frameCount)
        --local hdc = ffi.cast("HDC", wparam); 
        if appSurface then
            local imgSize = appImage:size()
            --print("Size: ", imgSize.w, imgSize.h)

            -- BitBlt is probably hardware accelerated
            -- StretchDIBits might also be hardware accelerated
            -- but, we don't need stretching, so we'll go with the slightly
            -- easier bitblt
            local bResult  C.BitBlt(  appWindowDC,  0,  0,  imgSize.w,  imgSize.h,  
                appSurface.DC,  0,  0,  C.SRCCOPY);
        end
        res = 0; 
    elseif msg == C.WM_PAINT then
        -- multiple WM_PAINT commands can be issued
        -- while dragging the window around, but the msgLoop
        -- is not involved as windowProc is called directly
        -- in order to properly update the framecount, we need
        -- to use a system timer, and handle WM_TIMER messages
        --print("WindowProc.WM_PAINT:", frameCount, wparam, lparam)

        local ps = ffi.new("PAINTSTRUCT");
		local hdc = C.BeginPaint(hwnd, ps);

        C.EndPaint(hwnd, ps);
        res = 0
    else
        res = C.DefWindowProcA(hwnd, msg, wparam, lparam);
    end

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
        --while (C.PeekMessageA(msg, nil, 0, 0, C.PM_REMOVE) ~= 0) do
        local haveMessage = C.PeekMessageA(msg, nil, 0, 0, C.PM_REMOVE) ~= 0
        if haveMessage then
            -- If we see a quit message, it's time to stop the program
            -- ideally we'd call an 'onQuit' and wait for that to return
            -- before actually halting.  That will give the app a chance
            -- to do some cleanup
            if msg.message == C.WM_QUIT then
                --print("msgLoop - QUIT")
                halt();
            end

            res = C.TranslateMessage(msg)
            res = C.DispatchMessageA(msg)
        end

        yield();
        -- ideally this routine would be a coroutine
        -- at the scheduler level, switching between 
        -- normal scheduled tasks, and windows message looping
        -- then message processing would be better interspersed
        -- with tasks, rather than being scheduled at the end
        -- of the ready list
        --coroutine.yield(true)
    end   
end

--[[
-- From NewTOAPIA
function WMSetWindowAlpha(hwnd, alpha)

    int res1;

    local res1 = C.GetWindowLong(hwnd, C.GWL_EXSTYLE);

    -- If the alpha is == 255, then turn off layered window
    if 255 == alpha then
        C.SetWindowLong(hwnd, C.GWL_EXSTYLE, band(res1, bnot(~C.WS_EX_LAYERED));
        return true;
    end

    -- If we are here, then opacity is less than 255 (opaque), so
    -- we need to first ensure the window is a layered window.
    C.SetWindowLong(hwnd, C.GWL_EXSTYLE, bor(res1 , C.WS_EX_LAYERED));

    -- Next we setup the alpha value.
    local res2 = C.SetLayeredWindowAttributes(hwnd, 0, alpha, C.LWA_ALPHA);

    return true;
end
--]]

local function createWin32Window(params)
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
    params.winclass = params.class or winclassname
    params.winstyle = params.winstyle or winstyle
    params.winxstyle = params.winxstyle or 0
    params.x = params.x or 0
    params.y = params.y or 0
    winHandle, err = win32.CreateWindowHandle(params)

    if not winHandle then
        print("NO WINDOW HANDLE: ", err)
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

        -- Touch events
        {activity = 'gap_touch', response = "touchEvent"};
        
        -- Gesture activity
        {activity = 'gap_gesture', response = "gestureEvent"};


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

local function showWindow()
    C.ShowWindow(appWindowHandle, C.SW_SHOWNORMAL);
end

--[[
    https://docs.microsoft.com/en-us/windows/desktop/inputdev/using-raw-input
]]
function rawInputOn(kind, localWindow)
    if kind then
        -- if a specific kind is named, then only register for that kind
        return HID_RegisterDevice(appWindowHandle, HID_MOUSE, localWindow)
    end

    -- if no kind is named,then register for all kinds
    HID_RegisterDevice(appWindowHandle, HID_MOUSE, localWindow)
    HID_RegisterDevice(appWindowHandle, HID_KEYBOARD, localWindow)
    
    return true;
end

function rawInputOff(kind)
    if kind then
        return HID_UnregisterDevice(HID_MOUSE);
    end
    
    HID_UnregisterDevice(HID_MOUSE);
    HID_UnregisterDevice(HID_KEYBOARD);
end

--[[
    static const int TWF_FINETOUCH      = 0x00000001;
static const int TWF_WANTPALM       = 0x00000002;
]]
function touchOn(flags)
    flags = flags or 0
    local bResult = C.RegisterTouchWindow(appWindowHandle, flags);
    if bResult ~= 0 then
        touchIsOn = true;
        return true;
    end

    return false
end

function touchOff()
    local bResult = C.UnregisterTouchWindow(appWindowHandle);
    touchIsOff = true;

    if bResult ~= 0 then
        return true;
    end
    return false;
end



local function main(params)

    -- We can create the app Surface from the beginning
    -- as it's fairly independent
    appSurface, err = BLDIBSection(params)
    appImage = appSurface.Image
    --appContext = BLContext(appImage)
    params.BackingBuffer = appImage
    appContext = DrawingContext(params)
    --appImage = appContext:getReadyBuffer()

    -- Fill context with background color to start
    appContext:clear()
    appContext:setFillStyle(BLRgba32(0xffcccccc))
    appContext:fillAll()



    FrameRate = params.frameRate or 30;

    -- Start the message loop going so window
    -- creation can occur
    spawn(msgLoop);
    yield();


    -- Create the actual Window which will represent
    -- the Managed window UI Surface
    appWindowHandle,err = createWin32Window(params)
 
    showWindow();
    appWindowDC = C.GetDC(appWindowHandle)

    -- Setup to deal with user inputs
    --setupUIHandlers();
    --yield();

    EnvironmentReady = true;

    yield();

    if params.startup then
        spawn(params.startup)
    end
    --yield()

    -- setup the periodic frame calling
    local framePeriod = math.floor(1000/FrameRate)
    periodic(framePeriod, handleFrame)

    --signalAll("gap_ready");
end


local function start(params)
    if not params then
        return nil, "creation parameters must be specified"
    end

    if not params.width or not params.height then
        return nil, "must specify width and height"
    end

    -- First thing to do is let the system know we are
    -- going to be DPI aware
    --local oldContext = C.SetThreadDpiAwarenessContext(DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2);

    params.title = params.title or "WinMan";
    params.frameRate = params.frameRate or 15;

    run(main, params)
end

return start