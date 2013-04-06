-- Minimal logging utility

local log = {_logs = {}}

function log:setName(name)
  self._handleName = name
end

function log:add(message)
  self._logs[#self._logs+1] = message
end

function log:clear()
  self._logs = {}
  self._handleName = ''
end

function log:export(fileName)
	local file = fileName or self._handleName
	if not file then
		error('No file handle set. Use setName() or pass a fileName to export()')
	end
  local f= io.open(file,'w')
  for k,v in ipairs(self._logs) do
    f:write(v..'\n')
  end
  f:close()
end

return log