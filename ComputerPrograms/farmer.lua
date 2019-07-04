local g = require("gpsMoveAPI")
local r = require("robot")

local length=8
local width=8
g.reZero()

function step()
	r.useDown()
	local result
	while(r.suckDown()) do
		print("grabbing seeds")
	end	
end

for i=0,length do
	for j=0,width do
		step()
		g.forward()
		--g.moveTo(i*-1,0,j*-1)
	end
	if(i%2==0) then
		g.turnLeft()
		g.forward()
		g.turnLeft()
	else
		g.turnRight()
		g.forward()
		g.turnRight()
	end
end

g.moveTo(0,0,0)
g.turnTo(0)
print("Done")