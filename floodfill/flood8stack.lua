local function flood8stack(x, y, stack, grid)
	stack:clear()
	if grid:isLegit(x,y) then stack:push({x,y}) end
	while not stack:isEmpty() do
		local p = stack:pop()
		local actualValue = grid:get(p[1], p[2])
		if actualValue and (actualValue == 0) then
			grid:set(p[1],p[2],1)
			if grid:isLegit(x+1, y) and grid:get(x+1,y)==0 then stack:push({x+1,y}) end
			if grid:isLegit(x-1, y) and grid:get(x-1,y)==0 then stack:push({x-1,y}) end
			if grid:isLegit(x, y+1) and grid:get(x,y+1)==0 then stack:push({x,y+1}) end
			if grid:isLegit(x, y-1) and grid:get(x,y-1)==0 then stack:push({x,y-1}) end
			if grid:isLegit(x+1, y+1) and grid:get(x+1, y+1)==0 then stack:push({x+1, y+1}) end
			if grid:isLegit(x+1, y-1) and grid:get(x+1, y-1)==0 then stack:push({x+1, y-1}) end
			if grid:isLegit(x-1, y+1) and grid:get(x-1, y+1)==0 then stack:push({x-1, y+1}) end
			if grid:isLegit(x-1, y-1) and grid:get(x-1, y-1)==0 then stack:push({x-1, y-1}) end
		end
	end
end

return flood8stack