local function floodStackScanline(x,y,grid,stack)
	stack:clear()
	local y1
	local spanLeft, spanRight
	
	if grid:has(x,y) then stack:push(grid._map[y][x]) end
	while not stack:isEmpty() do
		local p = stack:pop()
		x, y = p.x, p.y
		y1 = y
		while ((y1>=1) and grid:has(x,y1) and grid._map[y1][x].v==0) do
			y1 = y1 - 1
		end
		y1 = y1 + 1
		spanLeft, spanRight = false, false
		
		while (y1<=grid._height and grid:has(x,y1) and grid._map[y1][x].v==0) do
			grid:set(x,y1,1)
			if (not spanLeft and x>0 and grid:has(x-1,y1) and grid._map[y1][x-1].v==0) then
				stack:push(grid._map[y1][x-1])
				spanLeft = true
			elseif (spanLeft and x>0 and grid:has(x-1,y1) and grid._map[y1][x-1].v~=0)then
				spanLeft = false
			end

			if (not spanRight and x<=grid._width and grid:has(x+1,y1) and grid._map[y1][x+1].v==0) then
				stack:push(grid._map[y1][x+1])
				spanRight = true
			elseif (spanRight and x<=grid._width and grid:has(x+1,y1) and grid._map[y1][x+1].v~=0) then
				spanRight = false
			end			
			y1 = y1+1
		end
	end
end

return floodStackScanline