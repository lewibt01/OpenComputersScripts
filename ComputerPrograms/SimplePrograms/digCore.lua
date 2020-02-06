r = require("robot")

function goDown(x)
	for i=1,x do
		r.swingDown()
		r.down()
	end
end

function goUp(x)
	for i=1,x do
		r.up()
	end
end

function emptyInventory()
	for i=1,16 do
		r.select(i)
		r.drop()
	end
	r.select(1)
end

startDepth = 64
cycleLength = 20
cycles = math.ceil(startDepth/cycleLength)

--clear work area to start
r.swing()
r.forward()

--start coring
for i=1,cycles do
	goDown(cycleLength*i)
	goUp(cycleLength*i) --this causes problems

	--drop off items
	r.back()
	r.turnRight()
	r.turnRight()
	emptyInventory()

	--return to neutral position
	r.turnRight()
	r.turnRight()
	r.forward()
end

r.back()