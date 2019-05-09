--[[
    Game of life as a single graphic
       https://p5js.org/examples/simulate-game-of-life.html
--]]

local ffi = require("ffi")

local floor = math.floor
local random = math.random


-- use ffi parameterized type to create 2D array
local function Array2D(rows, columns)
    local arrtype = ffi.typeof("int[$][$]", columns, rows)
    return arrtype()    -- initialized with all 0
end

local GLife = {
    w = 10;     -- size of a cell
}
GLife.__index = GLife;

function GLife.new(self, obj)
    obj = obj or {}

    obj.w = obj.w or GLife.w

    -- Calculate columns and rows
    obj.columns = floor(obj.frame.width/obj.w);
    obj.rows = floor(obj.frame.height/obj.w);

    obj.board = Array2D(obj.rows, obj.columns)
    obj.next = Array2D(obj.rows, obj.columns)

    obj.neighborHood = Array2D(obj.rows-2, obj.columns-2)
    setmetatable(obj, GLife)

    obj:init();

    return obj;
end

-- Fill board randomly
function GLife.init(self) 
    for i = 0,self.columns-1 do
        for j = 0, self.rows-1 do
            -- Lining the edges with 0s
            if (i == 0 or j == 0 or i == self.columns-1 or j == self.rows-1) then
                self.board[i][j] = 0;
            else 
                self.board[i][j] = floor(random(0,1));
            end
            self.next[i][j] = 0;
        end
    end
end

-- The process of creating the new generation
function GLife.generate(self)

    -- Loop through every spot in our 2D array and check spots neighbors
    for x = 1, self.columns - 2 do
        for y = 1, self.rows - 2 do
            -- Add up all the states in a 3x3 surrounding grid
            local neighbors = 0;
            for i = -1, 1 do
                for j = -1, 1 do
                    neighbors = neighbors + self.board[x+i][y+j];
                end
            end

            -- A little trick to subtract the current cell's state since
            -- we added it in the above loop
            neighbors = neighbors - self.board[x][y];
            --neighborHood[x-1][y-1] = neighbors

            -- Rules of Life
            if ((self.board[x][y] == 1) and (neighbors <  2)) then 
                self.next[x][y] = 0;           -- Loneliness
            elseif ((self.board[x][y] == 1) and (neighbors >  3)) then 
                self.next[x][y] = 0;           -- Overpopulation
            elseif ((self.board[x][y] == 0) and (neighbors == 3)) then 
                self.next[x][y] = 1;           -- Reproduction
            else                                           
                self.next[x][y] = self.board[x][y]; -- Stasis
            end
        end
    end

    -- Swap!
    local temp = self.board;
    self.board = self.next;
    self.next = temp;
end


function GLife.draw(self, ctx)
    ctx:background(255);
    self:generate();
    ctx:noStroke();

    for i = 0, self.columns-1 do
        for j = 0, self.rows-1 do
            if (self.board[i][j] == 1) then
                ctx:fill(0);
            else 
                ctx:fill(255); 
            end

            ctx:rect(i*self.w, j*self.w, self.w, self.w);
        end
    end
end


return GLife
