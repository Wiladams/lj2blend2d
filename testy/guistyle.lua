
--[[
    Must be used in the context of DrawingContext
--]]
--[[
/*
* <dt> base
* <dd> The base color is the color that is used as the "dominant" color 
*      for graphical objects. For example, a button's text is drawn on top 
*      of this color when the button is "up".  
* <dt> highlight
* <dd> A lighter rendition of the base color used to create a highlight in 
*      pseudo 3D effects.
* <dt> shadow
* <dd> A darker rendition of the base color used to create a shadow in pseudo
*      3D effects.
* <dt> background
* <dd> The color used for background (or inset) <I>items</I> in a drawing 
*      scheme (rather than as a typical background area per se).  For example,
*      the background of a slider (the "groove" that the thumb slides in)
*      is drawn in this color.  [This name probably needs to be changed.]
* <dt>
* <dd> Note: the colors: base, highlight, shadow, and background are designed 
*      to be related, typically appearing to be the same material but with 
*      different lighting.
* <dt> foreground
* <dd> The color normally drawn over the base color for foreground items such
*      as textual labels.  This color needs to contrast with, but not clash 
*      with the base color.
* <dt> text_background
* <dd> The color that serves as the background for text editing areas.
* <dt> splash
* <dd> A color which is designed to contrast with, and be significantly
*      different from, the base, highlight, shadow, and background color 
*      scheme.  This is used for indicators such as found inside a selected
*      radio button or check box.
* </dl>
*/
--]]

local maths = require("maths")()

local Colorrefs = {
    Black = color(0, 0, 0);
    White = color(0xff, 0xff, 0xff);

    Red = color(0xff, 0, 0);
    Green = color(0, 0xff, 0);
    Cyan = color(0, 0xff, 0xff);
    Blue = color(0, 0, 0xff);
    Yellow = color(255, 255,0);
    Magenta = color(255, 0, 255);
    DarkCyan = color(0, 0x80, 0x80);
    MidGreen = color(0,192,0);
    MidBlue = color(0,0,192);
    MidRed = color(0xC0, 0,0);
    MidMagenta = color(0xC0, 0, 0xC0);
    DarkGreen = color(0,0x7f,0);
    DarkBlue = color(0,0,0x7f);
    DarkRed = color(0x7f, 0, 0);

    Pink = color(0xff, 0xC0, 0xCB);

    -- Grays
    LtGray = color(0xc0);
    MidGray = color(0x7f);
    DarkGray = color(0x40,0x40, 0x40);
}

local function byte(value)
    return math.floor(value+0.5)
end

local function brighter(value)
	local red = byte(clamp(value.r *(1/0.80), 0, 255));
	local green = byte(clamp(value.g * (1.0/0.85), 0, 255));
	local blue = byte(clamp(value.b * (1.0/0.80), 0,25255));

	return color(red, green, blue);
end

local function darker(value)
	local red = byte(value.r *0.60);
	local green = byte(value.g * 0.60);
	local blue = byte(value.b * 0.60);
		
    return color(red, green, blue);
end




local GUIStyle = {
    Colors = Colorrefs;

    FrameStyle = {
        Sunken = 0x01,
        Raised = 0x02
    };
}
local GUIStyle_mt = {
    __index = GUIStyle
}
--		static GUIStyle gDefaultStyle = new GUIStyle();

function GUIStyle.new(self, obj)
    obj = obj or {
        fBorderWidth = 2;
    }
    setmetatable(obj, GUIStyle_mt)

	obj.fBorderWidth = 2;

    obj.fBaseColor = Colorrefs.LtGray;
    obj.fForeground = Colorrefs.LtGray;

    obj.fTextBackground = obj.fBaseColor;

    obj.fHighlightColor = brighter(obj.fBaseColor);

    obj.fShadowColor = darker(obj.fBaseColor);

    obj.fBackground = brighter(obj.fHighlightColor);


    obj.fBottomShadow = darker(obj.fForeground); -- 0x00616161;

    obj.fBottomShadowTopLiner = brighter(obj.fBottomShadow); --fForeground;

    obj.fBottomShadowBottomLiner = obj.fBottomShadow;

    obj.fTopShadow = brighter(obj.fForeground);  -- 0x00cbcbcb;


    obj.fBackground = brighter(Colorrefs.DarkGray); --0x009e9e9e;


    return obj
end



function GUIStyle.SunkenColor(self)
	return self.fForeground;
end

function GUIStyle.RaisedColor(self)
	return self.fForeground;
end

function GUIStyle.Background(self)
	return self.fBackground;
end

function GUIStyle.BaseColor(self, value)
    if not value then
        return self.fBaseColor;
    end

    -- set
	self.fBaseColor = value;
	self.fTextBackground = self.fBaseColor;

    self.fHighlightColor = brighter(self.fBaseColor);
	self.fShadowColor = darker(self.fBaseColor);
	self.fBackground = brighter(self.fHighlightColor); 			
end

function GUIStyle.Foreground(self, value)
    -- get
    if not value then
        return self.fForeground;
    end
    
	-- set
	self.fForeground = value;
end

function GUIStyle.BorderWidth(self, value)
    if not value then
		return self.fBorderWidth;
    end
    
    self.fBorderWidth = value;
end

function GUIStyle.Padding(self)
	return 2;
end

function GUIStyle.DrawFrame(self, ctx, x, y, w, h, style)

	local n;

    if style == GUIStyle.FrameStyle.Sunken then
        ctx:stroke(self.fHighlightColor)
		for n=0, self:BorderWidth()-1 do
			ctx:line(x+n, y+h-n, x+w-n, y+h-n);    -- bottom shadow
            ctx:line(x + w - n, y + n, x + w - n, y + h);	    -- right shadow
        end

        ctx:stroke(self.fShadowColor)
		for n=0, self:BorderWidth()-1 do
			ctx:line(x+n, y+n, x+w-n, y+n);	    -- top edge
			ctx:line(x+n, y+n, x+n, y+h-n);	    -- left edge
        end				

    elseif style == GUIStyle.FrameStyle.Raised then	

        ctx:stroke(self.fShadowColor)
		for n=0, self:BorderWidth()-1 do
			ctx:line(x+n, y+h-n, x+w-n, y+h-n);      -- bottom shadow
			ctx:line(x+w-n, y+n, x+w-n, y+h);	    -- right shadow
        end

		if self:BorderWidth() > 0 then				
            ctx:stroke(self.fBottomShadowBottomLiner)
            ctx:line(x, y + h, x + w, y + h);				-- bottom shadow
            ctx:line(x + w, y, x + w, y + h);				-- right shadow
        end

        ctx:stroke(self.fHighlightColor)
		for n=0, self:BorderWidth()-1 do
			ctx:line(x+n,y+n, x+w-n, y+n);	    -- top edge
			ctx:line(x+n, y+n, x+n, y+h-n);	    -- left edge
        end

    end

end

function GUIStyle.DrawSunkenRect(self, ctx, x, y, w, h)
    ctx:fill(self.fBaseColor)
    ctx:fillRect(x,y,w,h)

	self:DrawFrame(ctx, x, y, w, h, GUIStyle.FrameStyle.Sunken);
end

function GUIStyle.DrawRaisedRect(self, ctx, x, y, w, h)
    ctx:fill(self.fBaseColor)
    ctx:fillRect(x,y,w,h)
	self:DrawFrame(ctx, x, y, w, h, GUIStyle.FrameStyle.Raised);
end

--[[
        public virtual void DrawLine(IGraphPort aPort, int x1, int y1, int x2, int y2, int border_width)
		{
            // Vertical line
			if (x1 == x2)
			{
				for (int n=0; n<BorderWidth; n++) 
					aPort.DrawLine(fShadowPen, new Point2I(x1-n, y1+n), new Point2I(x1-n, y2-n));  // left part
	    
				for (int n=1; n<BorderWidth; n++) 
					aPort.DrawLine(fHighlightPen, new Point2I(x1+n, y1+n), new Point2I(x1+n, y2-n));  // right part
			} 
			else if (y1 == y2)  // Horizontal line
			{
				for (int n=0; n<BorderWidth; n++) 
					aPort.DrawLine(fShadowPen, new Point2I(x1+n, y1-n), new Point2I(x2-n, y1-n));  // top part

				for (int n=1; n<BorderWidth; n++) 
					aPort.DrawLine(fHighlightPen, new Point2I(x1+n, y1+n), new Point2I(x2-n, y1+n));  // bottom part
			}
		}
	}
}
--]]

return GUIStyle
