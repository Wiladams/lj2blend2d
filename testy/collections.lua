-- Some convenient standard collections

local setmetatable = setmetatable;

-- The basic list type
-- This will be used to implement queues and other things
local List = {}
local List_mt = {
	__index = List;
}

function List.new(params)
	local obj = params or {first=0, last=-1}

	setmetatable(obj, List_mt)

	return obj
end


function List:PushLeft (value)
	local first = self.first - 1
	self.first = first
	self[first] = value
end

function List:PushRight(value)
	local last = self.last + 1
	self.last = last
	self[last] = value
end

function List:PopLeft()
	local first = self.first

	if first > self.last then
		return nil, "list is empty"
	end
	local value = self[first]
	self[first] = nil        -- to allow garbage collection
	self.first = first + 1

	return value
end

function List:PopRight()
	local last = self.last
	if self.first > last then
		return nil, "list is empty"
	end
	local value = self[last]
	self[last] = nil         -- to allow garbage collection
	self.last = last - 1

	return value
end

--[[
	Stack
--]]
local Stack = {}
setmetatable(Stack,{
	__call = function(self, ...)
		return self:new(...);
	end,
});

local Stack_mt = {
	__len = function(self)
		return self.Impl.last - self.Impl.first+1
	end,

	__index = Stack;
}

function Stack.new(self, ...)
	local obj = {
		Impl = List.new();
	}

	setmetatable(obj, Stack_mt);

	return obj;
end

function Stack.len(self)
	return self.Impl.last - self.Impl.first+1
end

function Stack.push(self, item)
	return self.Impl:PushRight(item);
end

function Stack.pop(self)
	return self.Impl:PopRight();
end


--[[
squeue

The squeue is a simple data structure that represents a 
first in first out behavior.
--]]

local squeue = {}
setmetatable(squeue, {
	__call = function(self, ...)
		return self:new(...);
	end,
});

local squeue_mt = {
	__index = squeue;
}

function squeue.init(self, first, last, name)
	first = first or 1;
	last = last or 0;

	local obj = {
		first=first, 
		last=last, 
		name=name};

	setmetatable(obj, squeue_mt);

	return obj
end

function squeue.new(self, first, last, name)
	first = first or 1
	last = last or 0

	return self:init(first, last, name);
end

function squeue:pushFront(value)
	-- PushLeft
	local first = self.first - 1;
	self.first = first;
	self[first] = value;
end

function squeue:pinsert(value, fcomp)
	binsert(self, value, fcomp)
	self.last = self.last + 1;
end

function squeue:enqueue(value)
	--self.MyList:PushRight(value)
	local last = self.last + 1
	self.last = last
	self[last] = value

	return value
end

function squeue:dequeue()
	-- return self.MyList:PopLeft()
	local first = self.first

	if first > self.last then
		return nil, "list is empty"
	end
	
	local value = self[first]
	self[first] = nil        -- to allow garbage collection
	self.first = first + 1

	return value	
end

function squeue:length()
	return self.last - self.first+1
end

-- Returns an iterator over all the current 
-- values in the queue
function squeue:entries(func, param)
	local starting = self.first-1;
	local len = self:length();

	local closure = function()
		starting = starting + 1;
		return self[starting];
	end

	return closure;
end


return {
	queue = squeue;
	List = List;
	Stack = Stack;
}