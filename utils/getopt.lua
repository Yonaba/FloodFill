
local fExists = function(file)
	local f = io.open(file)
	return (f~=nil)
end

local keys = function(t)
	local k = {}
	local has = false
	for _,v in pairs(t) do
		has = true
		k[#k+1] = v
	end
	return has and k or false
end

local fSetExists = function(v)
	for alg in v:gmatch('%.*(%w+)%.*') do
		if not fExists(('floodfill/%s.lua'):format(alg):gsub('queue.lua$', 'stack.lua')) then
			return false
		end
	end
	return true
end

local extend = function(dest, source)
	for k,v in pairs(source) do
		if not dest[k] then dest[k] = v.value end
	end
	return dest
end

local defArgs = {
	['n'] = {value = 10, assert = function(v)
		local v = tonumber(v)
		return v and v>0
	end},
	['m'] = {value = 'all', assert = function(v)
		 v = not v:find('%.map$') and v .. '.map' or v
		return fExists(('maps/%s'):format(v)) or v=='all'
	end},
	['i'] = {value = '', assert = function(v)
		return fSetExists(v)
	end},
	['u'] = {value = '', assert = function(v)
		return fSetExists(v)
	end}
}

local function getOpt(str)
	str = str or ''
	local args = {}
	for optArg, value in str:gmatch('%-(%w+)%s*=%s*([%_%-%.%w+]+)') do
		if defArgs[optArg] then
			if value then
				assert(defArgs[optArg].assert(value),
					('Wrong value to option -%s (%s)'):format(optArg, value))
			end
			args[optArg] = value
		else
			error (('Unknown option -%s'):format(optArg))
		end
	end
	return extend(args, defArgs)
end

return getOpt
