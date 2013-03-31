local function flood4(x, y, grid)
	local actualValue = grid:get(x,y)
	if actualValue and (actualValue == 0) then
		grid:set(x,y,1)		
		flood4(x+1,y,grid)
		flood4(x-1,y,grid)
		flood4(x,y+1,grid)
		flood4(x,y-1,grid)
	end
end

return flood4
