------------------------------------------------------------------------
-- FloodFill algorithms : comparison and speed-tests on HOG grid maps --
------------------------------------------------------------------------

-- Dependencies
local Stack = require 'struct.stack'
local Queue = require 'struct.queue'
local Grid = require 'struct.grid'

local parse = require 'utils.parser'
local getopt = require 'utils.getopt'

local floodFuncs = {
  {name = 'flood4',              func = require 'floodfill.flood4',             struct = nil},
  {name = 'flood8',              func = require 'floodfill.flood8',             struct = nil},
  {name = 'flood4stack',         func = require 'floodfill.flood4stack',        struct = Stack:new()},
  {name = 'flood4queue',         func = require 'floodfill.flood4stack',        struct = Queue:new()},
  {name = 'flood8stack',         func = require 'floodfill.flood8stack',        struct = Stack:new()},
  {name = 'flood8queue',         func = require 'floodfill.flood8stack',        struct = Queue:new()},
  {name = 'floodScanline',       func = require 'floodfill.floodscanline',      struct = nil},
  {name = 'floodStackScanline',  func = require 'floodfill.floodstackscanline', struct = Stack:new()},
  {name = 'floodQueueScanline',  func = require 'floodfill.floodstackscanline', struct = Queue:new()},
  {name = 'floodStackEast2West', func = require 'floodfill.floodeast2west',     struct = Stack:new()},
  {name = 'floodQueueEast2West', func = require 'floodfill.floodeast2west',     struct = Queue:new()},
}

-- Headers for pretty-printing of results
local TEST_HEADER = ('Map: %s: Grid size: %04dx%04d - (%02d runs)\n')
local TEST_RSLT   = ('%19s: %07.2f ms - stDev: %07.2f ms')

-- Filters entries both in source and some
local function only(source, some)
	local ret = {}
	for k,v in ipairs(some) do
		for _,f in pairs(source) do
			if v == f.name:lower() then ret[#ret+1] = f end
		end
	end
	return ret
end

-- Filters entries in source and not in some
local function diff(source, some)
	local ret = {}
	for _,f in ipairs(source) do
		local found = false
		for __,k in ipairs(some) do
			if k == f.name:lower() then
				found = true
				break
			end
		end
		if not found then ret[#ret+1] = f end
	end
	return ret
end

-- Appends .map if needed on a mapfile name
local getMapName = function(mapFile)
	return mapFile:match('%.map$') and mapFile or mapFile .. '.map'
end

-- Collect keys as an array from a dict-like table
local keys = function(t)
	local k = {}
	for v in pairs(t) do k[#k+1] = v end
	return k
end

-- Parses string to table, using "%." as entry delimiter 
local toTable = function(str)
	local no_dup = {}
	for w in str:gmatch('%.*(%w+)%.*') do no_dup[w] = true end
	return keys(no_dup)
end

-- Evaluates the amount of time to perform f(...), uses os.clock
local function benchmark(f,...)
	local init_time = os.clock()
	f(...)
	return (os.clock()-init_time)*1000
end

-- Evaluates the mean value from a dataset
local function mean(t)
	local count
	for i in ipairs(t) do count = (count or 0) + t[i] end
	return count/#t
end

-- Evaluates the standard deviatiom from a dataset
local function stdDev(t, m)
	m = m or mean(t)
	local accum
	for i in ipairs(t) do accum = (accum or 0) + ((t[i]-m)*(t[i]-m)) end
	return math.sqrt(accum/#t)
end

-- Performs floodfill on an entire grid
local function floodGrid(f, grid, stack)
	for y = 1,grid._height do
		for x = 1,grid._width do f(x,y,grid, stack) end
	end
end

-- Main function, run tests
local function main(args)
	local n_times = args.r
	local mapName = getMapName(args.m)
	local ignore = args.i~='' and toTable(args.i)
  local use = args.u~= '' and toTable(args.u)
	
	-- Flood functions to be used
	local flfuncs
	if use then flfuncs = only(floodFuncs, use)
	elseif ignore then
		flfuncs = diff(floodFuncs, ignore)
	else flfuncs = floodFuncs
	end

	-- Makes a grid
	local map = parse(mapName)
	local grid = Grid:new(map)
	
	-- Run tests
	print(TEST_HEADER:format(mapName, grid._width, grid._height, n_times))

	for _,f in ipairs(flfuncs) do
		local times = {}

		for i = 1, n_times do
			local cgrid = grid:clone()
			collectgarbage()
			local time = benchmark(floodGrid, f.func, cgrid, f.struct)
			times[i] = time
			assert(cgrid:isFlooded(), ('FloodFill failed on run %d (with %s)'):format(i, f.name))
		end

		local m = mean(times)
		local sDev = stdDev(times, m)
		print(TEST_RSLT:format(f.name, m, sDev))
	end

end

-- GetOpt from cmd-line and run
local param = getopt(table.concat(arg,' '))
main(param)

--[[
	Copyright (c) 2013 Roland Yonaba

	Permission is hereby granted, free of charge, to any person obtaining a
	copy of this software and associated documentation files (the
	"Software"), to deal in the Software without restriction, including
	without limitation the rights to use, copy, modify, merge, publish,
	distribute, sublicense, and/or sell copies of the Software, and to
	permit persons to whom the Software is furnished to do so, subject to
	the following conditions:

	The above copyright notice and this permission notice shall be included
	in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
	IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
	CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
	TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
	SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]