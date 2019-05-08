--[[
    Take an SVG Path graphic and turn it into a BLPath object
    This just takes the 'd' attribute of an SVG path, ignoring all
    attributes and the like.
--]]

--[[
	given a 'd' attribute of an svg path element
	turn that into a table with each command and
	its arguments represented by their own table.
	Each command entry has the command itself (a single character)
	followed by the arguments for that command in subsequent positions
--]]
local function parseSVGPathCommands(input)
    local out = {};

    for instr, vals in input:gmatch("([a-df-zA-DF-Z])([^a-df-zA-DF-Z]*)") do
        local line = { instr };
        for v in vals:gmatch("([+-]?[%deE.]+)") do
            line[#line+1] = v;
        end
        out[#out+1] = line;
    end

    return out;
end

local GSVGPath = {}
GSVGPath.__index = GSVGPath

function GSVGPath.new(self, obj)
    obj = obj or {}
    obj.mainPath = BLPath()

    setmetatable(obj, GSVGPath)
    if obj.d then
        obj:parseSVG(obj.d)
    end

    return obj
end

function GSVGPath.draw(self, ctx)
    --print("GSVGPath.draw: ", self.mainPath)
    ctx:fillPath(self.mainPath)
    ctx:strokePath(self.mainPath)

end



-- helper functions to deal with relative vs absolute
-- operations
local function pathMoveTo(path, cpx, cpy, args, rel)
    if rel then
        cpx = cpx + tonumber(args[1]);
        cpy = cpy + tonumber(args[2]);
    else
        cpx = tonumber(args[1]);
        cpy = tonumber(args[2]);
    end
    
    path:moveTo(cpx, cpy);
    
    return cpx, cpy;
end


local function pathLineTo(path, cpx, cpy, args, rel)
    if rel then
        cpx = cpx + tonumber(args[1]);
        cpy = cpy + tonumber(args[2]);
    else
        cpx = tonumber(args[1]);
        cpy = tonumber(args[2]);
    end
    
    path:lineTo(cpx, cpy);
    
    return cpx, cpy;
end
    
    
local function pathHLineTo(path, cpx, cpy, args, rel)
    if rel then
        cpx = cpx + args[1];
    else
        cpx = args[1];
    end
    
    path:lineTo(cpx, cpy);
    
    return cpx, cpy;
end
    
local function pathVLineTo(path, cpx, cpy, args, rel)
        if rel then
            cpy = cpy + args[1];
        else
            cpy = args[1];
        end
    
        path:lineTo(cpx, cpy);
    
        return cpx, cpy;
end

function pathCubicBezTo(path, cpx, cpy, cpx2, cpy2, args, rel)

	local x2, y2, cx1, cy1, cx2, cy2 =0,0,0,0,0,0;

	if (rel) then
		cx1 = cpx + args[1];
		cy1 = cpy + args[2];
		cx2 = cpx + args[3];
		cy2 = cpy + args[4];
		x2 = cpx + args[5];
		y2 = cpy + args[6];
	else
		cx1 = args[1];
		cy1 = args[2];
		cx2 = args[3];
		cy2 = args[4];
		x2 = args[5];
		y2 = args[6];
	end

	path:cubicTo(cx1,cy1, cx2,cy2, x2,y2);

	cpx2 = cx2;
	cpy2 = cy2;
	cpx = x2;
	cpy = y2;

	return cpx, cpy, cpx2, cpy2;
end


function GSVGPath.parseSVG(self, input)
    local instructions = parseSVGPathCommands(input)
    if not instructions then
        return nil;
    end


    local cpx = 0; 
    local cpy = 0;
    local cpx2 = 0; 
    local cpy2 = 0;
    local closedFlag = false;

    local wrkPath = BLPath()


    -- what we have in commands is a table of instructions
    -- each line has
    -- instructions[1] == name of instructions
    -- instructions[2..n] == values for instructions
    for _, args in ipairs(instructions) do
        local cmd = args[1];
        table.remove(args,1);
--print("  CMD: ", cmd, #args)

        -- now, we have the instruction in the 'cmd' value
        -- and the arguments in the args table
        if cmd == "m" or cmd == "M" then
            --print("MOVETO:", unpack(args))
            if #args == 0 then
                -- Commit path.
                if (#self.pts > 0) then
                    self:addPath(closedFlag);
                end

                -- Start new subpath.
                wrkPath:reset()
                
                closedFlag = false;
            else
                -- The first set of arguments determine the new current
                -- location.  After we remove them, the remaining args
                -- are treated as lineTo
                cpx, cpy = pathMoveTo(wrkPath, cpx, cpy, args, cmd == 'm');
                table.remove(args)
                table.remove(args)
                
                if #args >=2 then

                    while #args >= 2 do
                        cpx, cpy = pathLineTo(wrkPath, cpx, cpy, args, cmd == 'm');
                        cpx2 = cpx;
                        cpy2 = cpy;
                        table.remove(args)
                        table.remove(args)
                    end
                end
            end
        elseif cmd == "l" or cmd == "L" then
            --print("LINETO: ", unpack(args))
            cpx, cpy = pathLineTo(wrkPath, cpx, cpy, args, cmd == 'l');
            cpx2 = cpx; 
            cpy2 = cpy;
        elseif cmd == "h" or cmd == "H" then
            --print("HLINETO: ", unpack(args))
            cpx, cpy = pathHLineTo(wrkPath, cpx, cpy, args, cmd == 'h');
            cpx2 = cpx; 
            cpy2 = cpy;
        elseif cmd == "v" or cmd == "V" then
            --print("VLINETO: ", unpack(args))
            cpx, cpy = pathVLineTo(wrkPath, cpx, cpy, args, cmd == 'v');
            cpx2 = cpx; 
            cpy2 = cpy;
        elseif cmd == "c" or cmd == "C" then
            --print("CUBICBEZIERTO: ", unpack(args))
            cpx, cpy, cpx2, cpy2 = pathCubicBezTo(wrkPath, cpx, cpy, cpx2, cpy2, args, cmd == 'c');
        elseif cmd == "s" or cmd == "S" then
            --print("CUBICBEZIERSHORTTO: ", unpack(args))
            cpx, cpy, cpx2, cpy2 = pathCubicBezShortTo(wrkPath, cpx, cpy, cpx2, cpy2, args, cmd == 's');
        elseif cmd == "q" or cmd == "Q" then
            --print("QUADBEZIERTO: ", unpack(args))
            cpx, cpy, cpx2, cpy2 = pathQuadBezTo(wrkPath, cpx, cpy, cpx2, cpy2, args, cmd == 'q');
        elseif cmd == "t" or cmd == "T" then
            --print("QUADBEZIERSHORTTO: ", unpack(args))
            cpx, cpy, cpx2, cpy2 = pathQuadBezShortTo(wrkPath, cpx, cpy, cpx2, cpy2, args, cmd == 't');

        elseif cmd == "a" or cmd == "A" then
            cpx, cpy = pathArcTo(wrkPath, cpx, cpy, args, cmd == 'a');
            cpx2 = cpx; 
            cpy2 = cpy;
        elseif cmd == "z" or cmd == "Z" then
            closedFlag = true;
            -- Commit path.
            if (wrkPath:getSize() > 0) then
            -- Move current point to first point
                --cpx = self.pts[1].x;
                --cpy = self.pts[1].y;
                cpx2 = cpx; 
                cpy2 = cpy;
                
                self.mainPath:addPath(wrkPath, nil)
                if closedFlag then
                    self.mainPath:close()
                end
            end

            -- Start new subpath.
            wrkPath = BLPath();
            --wrkPath:reset();
            --workPath:moveTo(cpx, cpy);
            closedFlag = false;
        end
    end

end


return GSVGPath
