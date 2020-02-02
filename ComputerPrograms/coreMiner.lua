r = require("robot")

defaultDepth = 40

function core(depth)
	for i=1,depth do
		r.swingDown()
		r.down()
	end
	for i=1,depth+1 do
		r.up()
	end
end

function main(n)
	for i=1,n do
		core(defaultDepth)
		r.swing()
		r.forward()
	end
end

function orient(dir)
	if(dir=="left") then
		r.turnLeft()
		r.swing()
		r.forward()
		r.turnLeft()
	else
		r.turnRight()
		r.swing()
		r.forward()
		r.turnRight()
	end
end

main(4)
orient("right")
main(4)
r.forward()

