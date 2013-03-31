local function floodStackScanline(x,y,grid,stack)
	stack:clear()
	local y1
	local spanLeft, spanRight
	
	if grid:isLegit(x,y) then stack:push({x,y}) end
	while not stack:isEmpty() do
		local p = stack:pop()
		x, y = p[1], p[2]
		y1 = y
		while ((y1>=1) and grid:isLegit(x,y1) and grid:get(x,y1)==0) do
			y1 = y1 - 1
		end
		y1 = y1 + 1
		spanLeft, spanRight = false, false
		
		while (y1<=grid._height and grid:isLegit(x,y1) and grid:get(x,y1)==0) do
			grid:set(x,y1,1)
			if (not spanLeft and x>0 and grid:isLegit(x-1,y1) and grid:get(x-1,y1)==0) then
				stack:push({x-1,y1})
				spanLeft = true
			elseif (spanLeft and x>0 and grid:isLegit(x-1,y1) and grid:get(x-1,y1)~=0) then
				spanLeft = false
			end

			if (not spanRight and x<=grid._width and grid:isLegit(x+1,y1) and grid:get(x+1,y1)==0) then
				stack:push({x+1,y1})
				spanRight = true
			elseif (spanRight and x<=grid._width and grid:isLegit(x+1,y1) and grid:get(x+1,y1)~=0) then
				spanRight = false
			end			
			y1 = y1+1
		end
	end
end

return floodStackScanline