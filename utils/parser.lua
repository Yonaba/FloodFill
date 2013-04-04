-- HOG Mapfile (version 1.0) parser
-- See http://movingai.com/benchmarks/formats.html

local tonumber, assert, io = tonumber, assert, io

-- Gets a file contents
local function getFileContents(file)
  local f = io.open(file,'r')
  local contents = f:read('*a')
  f:close()
  return contents
end

--[[
  Map file description
    Header:
      type octile
      height (int)
      width (int)
      map

  (ASCII) String data , '[\n\r]' line-endings, containing the following characters)
    . terrain (passable)
    G terrain (passable)
    @ void (out of map bounds)
    O void (out of map bounds)
    T tree (unpassable)
    S swamp (passable from terrain)
    W water (traversable, but not passable from terrain)

  Implementation note
    We will only consider '[.G]' as passable
--]]

-- Parses a map file
local function parseMap(mapFile)
  local map_data = getFileContents(mapFile)
  local map_type = map_data:match('^type (%w+)[\n\r]')
  local map_height = tonumber(map_data:match('height (%d+)[\n\r]'))
  local map_width = tonumber(map_data:match('width (%d+)[\n\r]'))
  local _,map_offset = map_data:find('map[\n\r]')
  map_data = map_data:sub(map_offset+1)
  local map = {}
  local row_count = 1
  repeat
    local EOS = map_data:find('[\n\r]')
    if EOS then
      local line = map_data:sub(1,EOS-1)
      map_data = map_data:sub(EOS+1)
      map[row_count] = {}
      local row = map[#map]
	    local col_count = 1
        for char in line:gmatch('.') do
          row[col_count] = char:match('[.G]') and 0 or 1
					col_count = col_count+1
        end
    end
	row_count = row_count+1
  until not EOS
  assert(#map == map_height,'Error parsing map')
  assert(#map[1] == map_width,'Error parsing map')
  return map
end

return parseMap
