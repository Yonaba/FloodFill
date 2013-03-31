-- A Grid data structure

local grid = {_map = {}, _width = 0, _height = 0}
grid.__index = grid

function grid:new(width, height)
	local g = setmetatable({},grid)
	g._width, g._height = width, height
	for y = 1, g._height do g._map[y] = {}
		for x = 1, g._width do g._map[y][x] = 0 end
	end
	return g
end

function grid:isLegit(x,y)
	return (x>0 and x<=self._width) and (y>0 and y<=self._height)
end

function grid:set(x,y,value)
	self._map[y][x] = value
	return self
end

function grid:get(x,y)
	return self._map[y] and self._map[y][x]
end

function grid:isFilled()
	for y = 1, self._width do
		for x = 1, self._height do
			if self._map[y][x] == 0 then return false end
		end
	end
	return true
end

function grid:reset()
	for y = 1, self._height do
		for x = 1, self._width do self._map[y][x] = 0 end
	end
	return self
end

return grid
