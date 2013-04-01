local fExists = function(file)
	local f = io.open(file)
	return (f~=nil)
end

local extend = function(dest, source)
	for k,v in pairs(source) do
		if not dest[k] then dest[k] = v.value end
	end
	return dest
end

local defArgs = {
	['repeat'] = {value = 10, assert = function(v)
		local v = tonumber(v)
		return v and v>0
	end},
	['map'] = {value = 'orz203d', assert = function(v)
		 v = not v:find('%.map$') and v .. '.map' or v
		return fExists(('maps/%s'):format(v))
	end}
}

local function getOpt(str)
	str = str or ''
	local args = {}
	for optArg, value in str:gmatch('%-(%w+)=(.+)%s*') do
		if defArgs[optArg] then
			if value then
				assert(defArgs[optArg].assert(value),
					('Wrong value to option -%s'):format(optArg))
			end
			args[optArg] = value
		else
			error (('Unknown option -%s'):format(optArg))
		end
	end
	return extend(args, defArgs)
end