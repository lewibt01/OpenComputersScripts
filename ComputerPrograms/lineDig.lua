local g = require("gpsMoveAPI")
local r = require("robot")
local arg = {...}


if(arg[1] == "") then 
	iterations = 1
end
g.reZero()

depth=0
function stepDown()
	while(g.down() or r.swingDown()) do
		depth = depth + 1
	end
	g.printPosition()
end

function stepUp()
	while(g.pos[2] <= 0) do
		r.swingUp()
		g.up()
		depth = depth - 1
	end
end

for i=1,2 do
	stepDown()
	r.swing()
	g.forward()
	stepUp()
	r.swing()
	g.forward()
end

g.moveTo(0,0,0)