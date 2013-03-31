local function flood8(x, y, grid)
	local actualValue = grid:get(x,y)
	if actualValue and (actualValue == 0) then
		grid:set(x,y,1)
		flood8(x+1,y,grid)
		flood8(x-1,y,grid)
		flood8(x,y+1,grid)
		flood8(x,y-1,grid)
		flood8(x+1,y+1,grid)
		flood8(x+1,y-1,grid)
		flood8(x-1,y+1,grid)
		flood8(x-1,y-1,grid)
	end
end

return flood8