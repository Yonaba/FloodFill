------------------------------------------------------------------------
-- FloodFill algorithms : performance comparison HOG grid maps
------------------------------------------------------------------------

-- Dependencies
local Stack = require 'struct.stack'
local Queue = require 'struct.queue'
local Grid = require 'struct.grid'

local parse = require 'utils.parser'
local getopt = require 'utils.getopt'
local log = require 'utils.log'

local floodFuncs = {
  {name = 'flood4',              func = require 'floodfill.flood4',             struct = nil},
  {name = 'flood8',              func = require 'floodfill.flood8',             struct = nil},
  {name = 'flood4Stack',         func = require 'floodfill.flood4stack',        struct = Stack:new()},
  {name = 'flood4Queue',         func = require 'floodfill.flood4stack',        struct = Queue:new()},
  {name = 'flood8Stack',         func = require 'floodfill.flood8stack',        struct = Stack:new()},
  {name = 'flood8Queue',         func = require 'floodfill.flood8stack',        struct = Queue:new()},
  {name = 'floodScanline',       func = require 'floodfill.floodscanline',      struct = nil},
  {name = 'floodScanlineStack',  func = require 'floodfill.floodstackscanline', struct = Stack:new()},
  {name = 'floodScanlineQueue',  func = require 'floodfill.floodstackscanline', struct = Queue:new()},
  {name = 'floodWestEastStack',  func = require 'floodfill.floodwesteast',     struct = Stack:new()},
  {name = 'floodWestEastQueue',  func = require 'floodfill.floodwesteast',     struct = Queue:new()},
}

-- Listing all maps
local maps = {}
local lfs = require('lfs')
for f in lfs.dir(lfs.currentdir() ..'\\maps') do
	if f~='.' and f~='..' then maps[#maps+1] = ('maps/%s'):format(f) end
end

-- Headers for results pretty-printing
local TEST_HEADER = ('\n\nMap: %s: Grid size: %04dx%04d - (%02d run%s)\n')
local TEST_RSLT   = ('%19s: %10.2f ms - stDev: %10.2f ms')
local TEST_ERR    = ('%19s: %36s')

-- Redefines print function to export to logging
local oldprint = print
local print = function(...)
  oldprint(...)
  log:add(...)
end

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
local format2MapName = function(mapFile)
	local appendExt = mapFile:match('%.map$') and mapFile or mapFile .. '.map'
	return appendExt:match('^maps/.+%.map$') and appendExt or 'maps/'..appendExt
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
	local err = f(...)
	if err then return (os.clock()-init_time)*1000, err end
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
-- Sandboxed, because of possible stack overflows
local function floodGrid(f, grid, stack)
	for y = 1,grid._height do
		for x = 1,grid._width do
			local ok, err = pcall(f,x,y,grid, stack)
			if not ok then return err end
		end
	end
end

-- Main function, run tests
local function main(args)
	local n_times = tonumber(args.n)
	local ignore = args.i~='' and toTable(args.i)
	local use = args.u~= '' and toTable(args.u)
  log:setName(args.o)
	
	-- Flood functions to be used
	local flfuncs
	if use then flfuncs = only(floodFuncs, use)
	elseif ignore then
		flfuncs = diff(floodFuncs, ignore)
	else flfuncs = floodFuncs
	end

	-- Makes a grid
	local maps = args.m == 'all' and maps or {format2MapName(args.m)}
	for i,mapName in ipairs(maps) do
		local map = parse(mapName)

		-- Run tests
		print(TEST_HEADER:format(mapName, #map[1], #map, n_times, n_times>1 and 's' or ''))

		for _,f in ipairs(flfuncs) do
			local times = {}

			local hasErr -- Shortcut for loop in case a flood fails because of overflow
			for i = 1, n_times do
				local cgrid = Grid:new(map)
				collectgarbage()
				local time, err = benchmark(floodGrid, f.func, cgrid, f.struct)
				hasErr = err
				if hasErr then break end
				times[i] = time
				assert(cgrid:isFlooded() or err, ('FloodFill failed on run %d (with %s)'):format(i, f.name))
			end
			
			if hasErr then
				print(TEST_ERR:format(f.name, 'failed: stack overflow'))
			else
				local m = mean(times)
				local sDev = stdDev(times, m)	
				print(TEST_RSLT:format(f.name, m, sDev))
			end
		end
	end
	
	log:export()
	log:clear()
end

-- GetOpt from cmd-line and run
local param = getopt(table.concat(arg,' '))
main(param)

--[[
	Copyright (c) 2012 Roland Yonaba

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
