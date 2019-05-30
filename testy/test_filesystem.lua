-- test_filesystem.lua

local ffi = require("ffi");

local fsys = require("filesystem")
local FileSystem = fsys.FileSystem;
local FileSystemItem = fsys.FileSystemItem;

--[[
local volumes = function(self)
	local cchBufferLength = ffi.C.MAX_PATH;
	local lpszVolumeName = ffi.new("WCHAR[?]", cchBufferLength+1);

	local handle = FsFindVolumeHandle(core_file.FindFirstVolumeW(lpszVolumeName, cchBufferLength));
	local firstone = true;

	local closure = function()
		if not handle:isValid() then 
			return nil;
		end

		if firstone then
			firstone = false;
			return core_string.toAnsi(lpszVolumeName);
		end

		local status = core_file.FindNextVolumeW(handle.Handle, lpszVolumeName, cchBufferLength);

		if status == 0 then
			return nil;
		end

		return core_string.toAnsi(lpszVolumeName);
	end

	return closure;
end
--]]




--[[
	Test Cases
--]]

local function printDriveCount()
	local driveCount = FileSystem:logicalDriveCount();
	print("Logical Drive Count: ", driveCount);
end

local function printVolumes()
	for volume in volumes() do
		print(volume);
	end
end


local function printFileNames(pattern)
	for filename in files(pattern) do
		print(filename);
	end
end




local function printFileItems(startat, filterfunc)
	for item in startat:itemsRecursive() do
		if filterfunc then
			if filterfunc(item) then
				print(item:getFullPath());
			end
		else
			print(item.Name);
		end
	end
end



local function passHidden(item)
	return item:isHidden();
end

local function passLua(item)
	return item.Name:find(".lua", 1, true);
end

local function passTTF(item)
	return item.Name:find(".ttf", 1, true);
end

local function passDirectory(item)
	return item:isDirectory();
end

local function passDevice(item)
	return item:isDevice();
end

local function passReadOnly(item)
	return item:isReadOnly();
end


--depthQuery.traverseItems(FileSystemItem({Name="c:"}), "", passDirectory);
--depthQuery.traverseItems(FileSystemItem({Name="c:"}), "", passLua);
--depthQuery.traverseItems(FileSystemItem({Name="c:"}), "", passHidden);
--depthQuery.traverseItems(FileSystemItem({Name="c:"}), "", passDevice);
--depthQuery.traverseItems(FileSystemItem({Name="c:"}), "", passReadOnly);

--printFileItems(FileSystemItem({Name="c:"}), passHidden);
--printFileItems(FileSystemItem({Name="c:"}), passDirectory);
--printFileItems(FileSystemItem({Name="c:\\tools"}));
printFileItems(FileSystemItem({Name="c:\\windows\\fonts"}), passTTF);



--[=[
local printHtml = function(pattern, filterfunc)
	local fs = FileSystemItem({Name=pattern});

io.write[[
<html>
	<head>
		<title>File Directory</title>
	</head>

	<body>
		<ul>
]]
	for item in fs:items() do
		local goone = true;
		if filterfunc then
			if not filterfunc(item) then
				goone = false;
			end
		end
		local url = item:getFullPath();

		if goone then
			io.write([[<li><a href="]]..url..[[">]]..item.Name..[[</a></li>]]);
			io.write('\n');
		end
	end

io.write[[
		</ul>
	</body>
</html>
]]
end

local nodotdot = function(item)
	return item.Name ~= "." and item.Name ~= "..";
end

--printHtml("c:\\tools", nodotdot);

printVolumes();
--]=]
