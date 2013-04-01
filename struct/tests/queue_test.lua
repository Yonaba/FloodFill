local Queue = require 'struct.queue'
local queue = Queue:new()

for i = 1,10 do queue:push(i) end
while not queue:isEmpty() do
	print('Popped', queue:pop())
	if math.random() > 0.5 then
		local v = math.random(10)
		queue:push(v)
		print(' Pushed',v)		
	end
end