local function floodeast2west(x,y, grid, stack)
	stack:clear()
	local v = grid:get(x,y)
	if v and v==0 then
		stack:push(grid._map[y][x])
	end
	while not stack:isEmpty() do
		local p = stack:pop()
		x, y = p.x, p.y
		if p.v == 0 then
			local w, e = p.x, p.x
			while (grid:has(w-1,y) and grid._map[y][w].v == 0) do w = w - 1 end
			while (grid:has(e+1,y) and grid._map[y][e].v == 0) do e = e + 1 end
			for i = w,e,1 do
				grid:set(i,y,1)
				if grid:has(i, y-1) and grid._map[y-1][i].v == 0 then stack:push(grid._map[y-1][i]) end
				if grid:has(i, y+1) and grid._map[y+1][i].v == 0 then stack:push(grid._map[y+1][i]) end
			end
		end
	end
end

return floodeast2west
