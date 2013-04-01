local Stack = require 'struct.stack'
local stack = Stack:new()

for i = 1,10 do stack:push(i) end
while not stack:isEmpty() do
	print('Popped', stack:pop())
	if math.random() > 0.5 then
		local v = math.random(10)
		stack:push(v)		
		print(' Pushed',v)
	end
end