-- A Grid data structure

local grid = {_map = {}, _width = 0, _height = 0}
grid.__index = grid

function grid:new(map)
	local g = setmetatable({},grid)
	g._width, g._height = #map[1], #map
	g._map = map
	return g
end

function grid:has(x,y)
	return self._map[y] and self._map[y][x]
end

function grid:set(x,y,value)
	self._map[y][x].v = value
	return self
end

function grid:get(x,y)
	return self._map[y][x].v
end

function grid:isFlooded()
	for y = 1, self._width do
		for x = 1, self._height do
			if self._map[y][x].v == 0 then return false end
		end
	end
	return true
end

function grid:reset()
	for y = 1, self._height do
		for x = 1, self._width do self._map[y][x].v = 0 end
	end
	return self
end

return grid
