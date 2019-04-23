package.path = "../?.lua;"..package.path;

require("p5")

local MouseTarget = require("p5ui.MouseTarget")
local stats = require("p5ui.P5Status")

local face
local font
local fontDir = "c:\\windows\\fonts\\"
local fontName = "calibri.ttf"

local black = color(0)
local white = color(255)
local blue = color(0,0,255)

local labelColumn = 10
local dataColumn = 120
local rowHeight = 20;

local target

-- Convenient drawing routines
local function display(params)
    if not params then return false end

    local txt = params.text or ''
    local c = params.color or black
    local x = params.x or 0
    local y
    if not params.y then
        if params.row then
            y = params.row*rowHeight
        else
            y = rowHeight;
        end
    end

    fill(c)
    text(txt, x, y)

end

local function displayLabeledData(txt, data, row)
    display {text = txt, color = black, x = labelColumn, row = row}
    display {text = tostring(data), x = dataColumn, row = row, color = blue}
end

-- Font specific details
-- from BLFontMetrics
local detailArea = {
    Frame = {
        x = 240;
        y = 80;
        width = 360;
        height = 360;
    };
}

function detailArea.drawBegin(self)
    strokeWeight(2)
    stroke(0)
    fill(0xdd)
    rect(0, 0, self.Frame.width, self.Frame.height)
end

function detailArea.drawBody(self)
    displayLabeledData("Size:", font.impl.metrics.size , 1)
    displayLabeledData("Line Gap:", font.impl.metrics.lineGap , 2)
    displayLabeledData("X Height:", font.impl.metrics.xHeight , 3)
    displayLabeledData("Cap Height:", font.impl.metrics.capHeight , 4)
end

function detailArea.drawEnd(self)
end

function detailArea.draw(self)
    push()
    translate(self.Frame.x, self.Frame.y)

    self:drawBegin()
    self:drawBody()
    self:drawEnd()
    
    pop()
end

function setup()
    --target = MouseTarget:new({color = 0, weight=0.5})
    target = MouseTarget:new({weight=0.5})

    face, err = BLFontFace:createFromFile(fontDir..fontName)
    if not face then
        error("could not load font face")
    end

    font,err = face:createFont(16)
    if not font then
        error("could not create font: ", err)
    end

    --noLoop()
end



function draw()
    background(0x70)

    -- Font Face information
    local weight = face.impl.weight;
    local stretch = face.impl.stretch;
    local style = face.impl.style;
    local fullName = face.impl.fullName     -- BLStringCore
    local familyName = face.impl.familyName -- BLStringCore
    local subfamilyName = face.impl.subfamilyName;


    displayLabeledData ("File Name: ", fontName, 1)
    displayLabeledData("Full Name:", fullName, 2)
    displayLabeledData("Family:", familyName, 3)
    displayLabeledData("Sub Family:", subfamilyName, 4)



    detailArea:draw()
    target:draw()
    stats:draw()
end

--[[
    
ffi.cdef[[
//! Scaled `BLFontDesignMetrics` based on font size and other properties.
struct BLFontMetrics {
  //! Font size.
  float size;

  union {
    struct {
      //! Font ascent (horizontal orientation).
      float ascent;
      //! Font ascent (vertical orientation).
      float vAscent;
      //! Font descent (horizontal orientation).
      float descent;
      //! Font descent (vertical orientation).
      float vDescent;
    };

    struct {
      float ascentByOrientation[2];
      float descentByOrientation[2];
    };
  };

  //! Line gap.
  float lineGap;
  //! Distance between the baseline and the mean line of lower-case letters.
  float xHeight;
  //! Maximum height of a capital letter above the baseline.
  float capHeight;

  //! Text underline position.
  float underlinePosition;
  //! Text underline thickness.
  float underlineThickness;
  //! Text strikethrough position.
  float strikethroughPosition;
  //! Text strikethrough thickness.
  float strikethroughThickness;

};
]]

go()