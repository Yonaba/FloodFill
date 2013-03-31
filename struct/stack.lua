-- A very minimal (LIFO) stack data structure

local t_remove = table.remove

local stack = {_stack={}, _pointer = 0}
stack.__index = stack

function stack:new()
	return setmetatable({},stack)
end

function stack:push(item)
	self._pointer = self._pointer+1
	self._stack[self._pointer] = item
	return self
end

function stack:pop()
	local item = self._stack[self._pointer]
	self._pointer = self._pointer-1
	t_remove(self._stack)
	return item
end

function stack:isEmpty()
	return (self._pointer == 0)
end

return stack