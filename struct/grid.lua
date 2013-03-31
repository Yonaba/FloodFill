-- A Grid data structure

local grid = {_map = {}, _width = 0, _height= 0}

function grid:new(width, height)
	local g = setmetatable({},grid)
	for y = 1, height do grid._map[y] = {}
		for x = 1, width do grid._map[y][x] = 0 end
	end
	return g
end

function grid:isLegit(x,y)
	return (x>0 and x<grid._width) and (y>0 and y<grid._height)
end

function grid:set(x,y,value)
	if self:isLegit(x,y) then self._map[y][x] = value end
end

function grid:get(x,y)
	return grid._map[y] and grid._map[y][x]
end

function grid:isFilled()
	for y = 1, self._width do
		for x = 1, self._height do
			if self._map[y][x] == 0 then return false end
		end
	end
	return true
end

return grid