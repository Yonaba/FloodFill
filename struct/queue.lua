-- A very minimal (LIFO) queue data structure

local t_remove = table.remove

local queue = {_queue={}, _pointer = 0, _has = {}}
queue.__index = queue

function queue:new()
	return setmetatable({},queue)
end

function queue:push(item)
	if self._has[item] then return end
	self._pointer = self._pointer+1
	self._queue[self._pointer] = item
	self._has[item] = true
	return self
end

function queue:pop()
	local item = self._queue[1]
	self._pointer = self._pointer-1
	t_remove(self._queue,1)
	self._has[item] = nil
	return item
end

function queue:isEmpty()
	return (self._pointer == 0)
end

function queue:clear()
	self._queue = {}
	self._has = {}
	self._pointer = 0
	return self
end

return queue
