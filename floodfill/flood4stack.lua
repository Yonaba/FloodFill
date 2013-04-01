local function flood4stack(x, y, grid, stack)
	stack:clear()
	if grid:has(x,y) then
		stack:push(grid._map[y][x]) 
	end
	while not stack:isEmpty() do
		local p = stack:pop()	
		local actualValue = p.v
		if (actualValue == 0) then
			x, y = p.x, p.y
			p.v = 1
			if grid:has(x+1, y) and grid._map[y][x+1].v==0 then stack:push(grid._map[y][x+1]) end
			if grid:has(x-1, y) and grid._map[y][x-1].v==0 then stack:push(grid._map[y][x-1]) end
			if grid:has(x, y+1) and grid._map[y+1][x].v==0 then stack:push(grid._map[y+1][x]) end
			if grid:has(x, y-1) and grid._map[y-1][x].v==0 then stack:push(grid._map[y-1][x]) end
		end
	end
end

return flood4stack