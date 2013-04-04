-- Scanline floodfill, stack-based recursive
-- See http://en.wikipedia.org/wiki/Flood_fill#Scanline_fill

local function floodScanline(x,y,grid)
	local v = grid:get(x,y)
	if v and v~=0 then return end
	
	local y1 = y
	while (y1<=grid._height) and grid:has(x,y1) and grid:get(x,y1)==0 do
		grid:set(x,y1,1)
		y1 = y1+1
	end
	y1 = y - 1
	while (y1>0) and grid:has(x,y1) and grid:get(x,y1)==0 do
		grid:set(x,y1,1)
		y1 = y1-1
	end
	
	y1 = y
	while (y1<=grid._height) and grid:has(x,y1) and grid:get(x,y1)~=0 do
		if (x>0) and grid:has(x-1,y1) and grid:get(x-1,y1)==0 then
			floodScanline(x-1,y1,grid)
		end
		y1 = y1+1
	end	
	y1 = y - 1
	while (y1>0) and grid:has(x,y1) and grid:get(x,y1)~=0 do
		if (x>0) and grid:has(x-1,y1) and grid:get(x-1,y1) == 0 then
			floodScanline(x-1,y1,grid)
		end
		y1 = y1-1
	end
	
	y1 = y
	while (y1<=grid._height) and grid:has(x,y1) and grid:get(x,y1)~=0 do
		if (x<=grid._width) and grid:has(x+1,y1) and grid:get(x+1,y1) == 0 then
			floodScanline(x+1,y1,grid)
		end
		y1 = y1+1
	end
	y1 = y - 1
	while (y1>0) and grid:has(x,y1) and grid:get(x,y1)~=0 do
		if (x<=grid._width) and grid:has(x+1,y1) and grid:get(x+1,y1) == 0 then
			floodScanline(x+1,y1,grid)
		end
		y1 = y1-1
	end	
end

return floodScanline