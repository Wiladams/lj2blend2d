--[[
    Minimum required to put a window on the screen and do some
    very basic drawing
]]
local ffi = require("ffi")
local C = ffi.C 
local bit = require("bit")
local band, bor = bit.band, bit.bor
local rshift, lshift = bit.rshift, bit.lshift;

local exports = {}

_WIN64 = (ffi.os == "Windows") and ffi.abi("64bit");

ffi.cdef[[
    typedef char                CHAR;
    typedef signed char         INT8;
    typedef unsigned char       UCHAR;
    typedef unsigned char       UINT8;
    typedef unsigned char       BYTE;
    typedef int16_t             SHORT;
    typedef int16_t             INT16;
    typedef uint16_t            USHORT;
    typedef uint16_t            UINT16;
    typedef uint16_t            WORD;
    typedef int                 INT;
    typedef int32_t             INT32;
    typedef unsigned int        UINT;
    typedef unsigned int        UINT32;
    typedef long                LONG;
    typedef unsigned long       ULONG;
    typedef unsigned long       DWORD;
    typedef int64_t             LONGLONG;
    typedef int64_t             LONG64;
    typedef int64_t             INT64;
    typedef uint64_t            ULONGLONG;
    typedef uint64_t            DWORDLONG;
    typedef uint64_t            ULONG64;
    typedef uint64_t            DWORD64;
    typedef uint64_t            UINT64;
]]

if _WIN64 then
    ffi.cdef[[
    typedef int64_t   INT_PTR;
    typedef uint64_t  UINT_PTR;
    typedef int64_t   LONG_PTR;
    typedef uint64_t  ULONG_PTR;
    ]]
    else
    ffi.cdef[[
    typedef int             INT_PTR;
    typedef unsigned int    UINT_PTR;
    typedef long            LONG_PTR;
    typedef unsigned long   ULONG_PTR;
    ]]
end

ffi.cdef[[
/* Types use for passing & returning polymorphic values */
typedef UINT_PTR            WPARAM;
typedef LONG_PTR            LPARAM;
typedef LONG_PTR            LRESULT;
]]

ffi.cdef[[
typedef ULONG_PTR   DWORD_PTR;
typedef LONG_PTR    SSIZE_T;
typedef ULONG_PTR   SIZE_T;
typedef int BOOL;
typedef void *HANDLE;

]]

-- libloaderapi
ffi.cdef[[
typedef HANDLE HMODULE;

HMODULE  GetModuleHandleA(const char * lpModuleName);
]]


-- profileapi
ffi.cdef[[
int QueryPerformanceCounter(int64_t * lpPerformanceCount);
int QueryPerformanceFrequency(int64_t * lpFrequency);
]]

-- windef
ffi.cdef[[
typedef struct tagRECT
{
    LONG    left;
    LONG    top;
    LONG    right;
    LONG    bottom;
} RECT, *PRECT, *NPRECT, *LPRECT;

typedef struct tagPOINT
{
    LONG  x;
    LONG  y;
} POINT, *PPOINT, *NPPOINT, *LPPOINT;

typedef const RECT * LPCRECT;
]]
-- winuser
ffi.cdef[[
// Class styles
static const int CS_VREDRAW         = 0x0001;
static const int CS_HREDRAW         = 0x0002;
static const int CS_OWNDC           = 0x0020;

// Window styles
static const int WS_OVERLAPPED       = 0x00000000;
static const int WS_CAPTION          = 0x00C00000;     /* WS_BORDER | WS_DLGFRAME  */
static const int WS_SYSMENU          = 0x00080000;
static const int WS_THICKFRAME       = 0x00040000;
static const int WS_MINIMIZEBOX      = 0x00020000;
static const int WS_MAXIMIZEBOX      = 0x00010000;

// window showing
static const int SW_HIDE            = 0;
static const int SW_SHOWNORMAL      = 1;
static const int SW_NORMAL          = 1;


// Windows messages
static const int WM_DESTROY = 0x0002;
static const int WM_PAINT   = 0x000F;
static const int WM_QUIT    = 0x0012;

static const int PM_REMOVE  =  0x0001;


static const int WS_OVERLAPPEDWINDOW = WS_OVERLAPPED|WS_CAPTION|WS_SYSMENU|WS_THICKFRAME|WS_MINIMIZEBOX|WS_MAXIMIZEBOX;

static const int CW_USEDEFAULT      = 0x80000000;

// GDI constants
static const int BI_RGB       = 0;
static const int DIB_RGB_COLORS     = 0; /* color table in RGBs */
static const int SRCCOPY           =  0x00CC0020; /* dest = source                   */


// Types
typedef HANDLE HDC;
typedef HANDLE HWND;
typedef HANDLE HICON;
typedef HANDLE HCURSOR;
typedef HANDLE HBRUSH;
typedef HANDLE HINSTANCE;
typedef HANDLE HMENU;
typedef HANDLE HBITMAP;

typedef WORD                ATOM; 

typedef LRESULT (__stdcall* WNDPROC)(HWND, UINT, WPARAM, LPARAM);

typedef struct tagWNDCLASSEXA {
        UINT        cbSize;
        /* Win 3.x */
        UINT        style;
        WNDPROC     lpfnWndProc;
        int         cbClsExtra;
        int         cbWndExtra;
        HINSTANCE   hInstance;
        HICON       hIcon;
        HCURSOR     hCursor;
        HBRUSH      hbrBackground;
        const char *      lpszMenuName;
        const char *      lpszClassName;
        /* Win 4.0 */
        HICON       hIconSm;
} WNDCLASSEXA, *PWNDCLASSEXA, *LPWNDCLASSEXA;

typedef struct tagPAINTSTRUCT {
    HDC         hdc;
    int        fErase;
    RECT        rcPaint;
    int        fRestore;
    int        fIncUpdate;
    uint8_t        rgbReserved[32];
} PAINTSTRUCT, *PPAINTSTRUCT, *NPPAINTSTRUCT, *LPPAINTSTRUCT;

typedef struct tagMSG {
    HWND        hwnd;
    UINT        message;
    WPARAM      wParam;
    LPARAM      lParam;
    DWORD       time;
    POINT       pt;
} MSG, *PMSG, *LPMSG;

typedef struct tagRGBQUAD {
    BYTE    rgbBlue;
    BYTE    rgbGreen;
    BYTE    rgbRed;
    BYTE    rgbReserved;
} RGBQUAD;

typedef struct tagBITMAPINFOHEADER{
    DWORD      biSize;
    LONG       biWidth;
    LONG       biHeight;
    WORD       biPlanes;
    WORD       biBitCount;
    DWORD      biCompression;
    DWORD      biSizeImage;
    LONG       biXPelsPerMeter;
    LONG       biYPelsPerMeter;
    DWORD      biClrUsed;
    DWORD      biClrImportant;
} BITMAPINFOHEADER,  *LPBITMAPINFOHEADER, *PBITMAPINFOHEADER;

typedef struct tagBITMAPINFO {
    BITMAPINFOHEADER    bmiHeader;
    RGBQUAD             bmiColors[1];
} BITMAPINFO,  *LPBITMAPINFO, *PBITMAPINFO;



DWORD __stdcall GetLastError(void);

LRESULT DefWindowProcA(HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam);
ATOM RegisterClassExA(const WNDCLASSEXA *);
HWND CreateWindowExA(DWORD dwExStyle, const char * lpClassName, const char * lpWindowName, DWORD dwStyle,
     int X, int Y, int nWidth, int nHeight,
     HWND hWndParent, HMENU hMenu, HINSTANCE hInstance, void * lpParam);
BOOL DestroyWindow(HWND hWnd);
BOOL ShowWindow(HWND hWnd, int nCmdShow);
BOOL InvalidateRect(HWND hWnd, const RECT *lpRect, BOOL bErase);

void PostQuitMessage(int nExitCode);
int PeekMessageA(LPMSG lpMsg, HWND hWnd, UINT wMsgFilterMin, UINT wMsgFilterMax, UINT wRemoveMsg);
int TranslateMessage(const MSG *lpMsg);
LRESULT DispatchMessageA(const MSG *lpMsg);

HDC BeginPaint(HWND hWnd, LPPAINTSTRUCT lpPaint);
int EndPaint(HWND hWnd, const PAINTSTRUCT *lpPaint);

// wingdi
HDC GetDC(HWND hWnd);
HBITMAP CreateDIBSection(HDC hdc, const BITMAPINFO *pbmi, UINT usage, void **ppvBits, HANDLE hSection, DWORD offset);
int  BitBlt(  HDC hdc,  int x,  int y,  int cx,  int cy,  HDC hdcSrc,  int x1,  int y1,  uint32_t rop);
int  StretchDIBits( HDC hdc,  int xDest,  int yDest,  int DestWidth,  int DestHeight,  
    int xSrc,  int ySrc,  int SrcWidth,  int SrcHeight,
    const void * lpBits,  const BITMAPINFO * lpbmi,  UINT iUsage,  DWORD rop);

BOOL Rectangle( HDC hdc,  int left,  int top,  int right,  int bottom);
]]

ffi.cdef[[
static const int MK_LBUTTON         = 0x0001;
static const int MK_RBUTTON         = 0x0002;
static const int MK_SHIFT           = 0x0004;
static const int MK_CONTROL         = 0x0008;
static const int MK_MBUTTON         = 0x0010;
static const int MK_XBUTTON1        = 0x0020;
static const int MK_XBUTTON2        = 0x0040;
]]

-- Mouse Messages
ffi.cdef[[
static const int WM_MOUSEFIRST                   = 0x0200;
static const int WM_MOUSEMOVE                    = 0x0200;
static const int WM_LBUTTONDOWN                  = 0x0201;
static const int WM_LBUTTONUP                    = 0x0202;
static const int WM_LBUTTONDBLCLK                = 0x0203;
static const int WM_RBUTTONDOWN                  = 0x0204;
static const int WM_RBUTTONUP                    = 0x0205;
static const int WM_RBUTTONDBLCLK                = 0x0206;
static const int WM_MBUTTONDOWN                  = 0x0207;
static const int WM_MBUTTONUP                    = 0x0208;
static const int WM_MBUTTONDBLCLK                = 0x0209;
static const int WM_MOUSEWHEEL                   = 0x020A;
static const int WM_XBUTTONDOWN                  = 0x020B;
static const int WM_XBUTTONUP                    = 0x020C;
static const int WM_XBUTTONDBLCLK                = 0x020D;
static const int WM_MOUSEHWHEEL                  = 0x020E;
static const int WM_MOUSELAST                    = 0x020E;
]]

-- Keyboard messages
ffi.cdef[[
static const int WM_KEYFIRST                     = 0x0100;
static const int WM_KEYDOWN                      = 0x0100;
static const int WM_KEYUP                        = 0x0101;
static const int WM_CHAR                         = 0x0102;
static const int WM_DEADCHAR                     = 0x0103;
static const int WM_SYSKEYDOWN                   = 0x0104;
static const int WM_SYSKEYUP                     = 0x0105;
static const int WM_SYSCHAR                      = 0x0106;
static const int WM_SYSDEADCHAR                  = 0x0107;

static const int WM_UNICHAR                      = 0x0109;
static const int WM_KEYLAST                      = 0x0109;
]]

-- Convenience functions
function exports.RegisterWindowClass(wndclassname, msgproc, style)
	msgproc = msgproc or C.DefWindowProcA;
	style = style or bor(C.CS_HREDRAW,C.CS_VREDRAW, C.CS_OWNDC);

	local hInst = C.GetModuleHandleA(nil);

	local wcex = ffi.new("WNDCLASSEXA");
    wcex.cbSize = ffi.sizeof("WNDCLASSEXA");
    wcex.style          = style;
    wcex.lpfnWndProc    = msgproc;
    wcex.cbClsExtra     = 0;
    wcex.cbWndExtra     = 0;
    wcex.hInstance      = hInst;
    wcex.hIcon          = nil;		-- LoadIcon(hInst, MAKEINTRESOURCE(IDI_APPLICATION));
    wcex.hCursor        = nil;		-- LoadCursor(NULL, IDC_ARROW);
    wcex.hbrBackground  = nil;		-- (HBRUSH)(COLOR_WINDOW+1);
    wcex.lpszMenuName   = nil;		-- NULL;
    wcex.lpszClassName  = wndclassname;
    wcex.hIconSm        = nil;		-- LoadIcon(wcex.hInstance, MAKEINTRESOURCE(IDI_APPLICATION));

	local classAtom = C.RegisterClassExA(wcex);

	if classAtom == nil then
    	return false, "Call to RegistrationClassEx failed."
    end

	return classAtom;
end

-- create a simple window handle
function exports.CreateWindowHandle(winclass, wintitle, width, height, winstyle, x, y)
	wintitle = wintitle or "Window";
	winstyle = winstyle or C.WS_OVERLAPPEDWINDOW;
	x = x or C.CW_USEDEFAULT;
	y = y or C.CW_USEDEFAULT;

	local hInst = C.GetModuleHandleA(nil);
	local hWnd = C.CreateWindowExA(
		0,
		winclass,
		wintitle,
		winstyle,
		x, y,width, height,
		nil,	
		nil,	
		hInst,
		nil);

	if hWnd == nil then
		return false, C.GetLastError()
	end

    ffi.gc(hWnd, C.DestroyWindow)

	return hWnd;
end



return exports
