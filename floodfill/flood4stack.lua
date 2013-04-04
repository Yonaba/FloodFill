-- 4-way custom stack-based recursive floodfill
-- The self made stack can either be a LIFO queue (depth-first search)
-- or a simple queue (breadth-first search)
-- See http://en.wikipedia.org/wiki/Flood_fill#Alternative_implementations

local function flood4stack(x, y, grid, stack)
	stack:clear()
	if grid:has(x,y) and grid._map[y][x].v==0 then
		stack:push(grid._map[y][x])
	end
	while not stack:isEmpty() do
		local p = stack:pop()
		x, y = p.x, p.y
		grid:set(x,y,1)
		if grid:has(x+1, y) and grid._map[y][x+1].v==0 then stack:push(grid._map[y][x+1]) end
		if grid:has(x-1, y) and grid._map[y][x-1].v==0 then stack:push(grid._map[y][x-1]) end
		if grid:has(x, y+1) and grid._map[y+1][x].v==0 then stack:push(grid._map[y+1][x]) end
		if grid:has(x, y-1) and grid._map[y-1][x].v==0 then stack:push(grid._map[y-1][x]) end
	end
end

return flood4stack
