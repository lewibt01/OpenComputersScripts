r = require("robot")

local gpsMove = {}

--keep track of localized location
gpsMove.pos = {0,0,0} --x and z are the horizontal coordinates, y denotes height
gpsMove.orientation = 0 --0/1/2/3:north/east/south/west

--[[Base Functions]]
function gpsMove.reZero()
	gpsMove.pos = {0,0,0}
	gpsMove.orientation = 0
end

function gpsMove.getPosition()
	return gpsMove.pos
end

function gpsMove.getOrientation()
	return gpsMove.orientation
end

function gpsMove.forward()
	local result = r.forward()
	if(result) then
		if(gpsMove.orientation==0) then
			gpsMove.pos[3] = gpsMove.pos[3] - 1 --decrement z to go north
		elseif(gpsMove.orientation == 1) then
			gpsMove.pos[1] = gpsMove.pos[1] + 1 --increment x to go east
		elseif(gpsMove.orientation == 2) then
			gpsMove.pos[3] = gpsMove.pos[3] + 1 --increment z to go south
		elseif(gpsMove.orientation == 3) then
			gpsMove.pos[1] = gpsMove.pos[1] - 1 --decrement x to go west
		else
			print("Error in gpsMove.forward()")
			return false
		end
	end
	return result
end

function gpsMove.back()
	local result = r.back()
	if(result) then
		if(gpsMove.orientation == 0) then
			gpsMove.pos[3] = gpsMove.pos[3] + 1
		elseif(gpsMove.orientation == 1) then
			gpsMove.pos[1] = gpsMove.pos[1] - 1
		elseif(gpsMove.orientation == 2) then
			gpsMove.pos[3] = gpsMove.pos[3] - 1
		elseif(gpsMove.orientation == 3) then
			gpsMove.pos[1] = gpsMove.pos[1] + 1 
		else
			print("Error in gpsMove.back()")
		end
	end
	return result
end

function gpsMove.up()
	local result = r.up()
	if(result) then
		gpsMove.pos[2] = gpsMove.pos[2] + 1
	end
	return result
end

function gpsMove.down()
	local result = r.down()
	if(result) then
		gpsMove.pos[2] = gpsMove.pos[2] - 1
	end
	return result
end

function gpsMove.turnRight()
	local result = r.turnRight()
	if(result) then
		gpsMove.orientation = gpsMove.orientation + 1
		gpsMove.orientation = gpsMove.orientation % 4
	end
	return result
end

function gpsMove.turnLeft()
	local result = r.turnLeft()
	if(result) then
		gpsMove.orientation = gpsMove.orientation - 1
		gpsMove.orientation = gpsMove.orientation % 4
	end
	return result
end

--[[Compund Functions]]
function gpsMove.turnTo(orient)
	orient = orient % 4
	local result
	local direction = orient-gpsMove.orientation --this will be positive/negative to denote direction of the turn, actual value does not matter, just the parity
	local magnitude = math.abs(direction)--how many turns we will have to make, there should be no more than 2

	while(magnitude > 2) do
		magnitude = magnitude - 2
	end

	local turnFunc --will store a reference to the turn function being called based on <direction> parity
	if(direction > 0) then
		turnFunc = gpsMove.turnRight
	elseif(direction < 0) then
		turnFunc = gpsMove.turnLeft
	elseif(direction = 0) then
		--do nothing, we are 0 turns away from the desired orientation
	else
		print("Error in turnTo()")
	end

	for i=1,magnitude do
		result = turnFunc()
	end
	return result
end

function gpsMove.moveTo(x,y,z)
	--determine oriantation vs new position, do movements 1 axis at a time, y-axis first
	local dX = x-gpsMove.pos[1]
	local dY = y-gpsMove.pos[2]
	local dZ = z-gpsMove.pos[3]
	--print("Delta",dX,dY,dZ)

	local function moveAmnt(func,amnt)
		local result
		for i=1,math.abs(amnt) do
			result = func()
		end
		return result
	end

	local function moveVerticalAmnt(amount)
		local result
		if(amount>=0) then
			result = moveAmnt(gpsMove.up,amount)
		else
			result = moveAmnt(gpsMove.down,amount)
		end
		return result
	end

	local function moveXAmnt(amount)
		if(amount >= 0) then
			gpsMove.turnTo(1)
		else
			gpsMove.turnTo(3)
		end
		return moveAmnt(gpsMove.forward,amount)
	end

	local function moveZAmnt(amount)
		if(amount >= 0) then
			gpsMove.turnTo(2)
		else
			gpsMove.turnTo(0)
		end
		return moveAmnt(gpsMove.forward,amount)
	end

	--vertical axis requires no orientation adjustment
	--print("Before Y:",gpsMove.orientation..":"..gpsMove.orientationStr(),"dY:"..dY,gpsMove.positionStr(),"Positive delta: "..tostring(dY >= 0))
	moveVerticalAmnt(dY)
	--print("After Y:",gpsMove.orientation..":"..gpsMove.orientationStr(),"dY:"..dY,gpsMove.positionStr(),"Positive delta: "..tostring(dY >= 0))

	--East/West axis
	--print("Before X:",gpsMove.orientation..":"..gpsMove.orientationStr(),"dX:"..dX,gpsMove.positionStr(),"Positive delta: "..tostring(dX >= 0))
	moveXAmnt(dX)
	--print("After X:",gpsMove.orientation..":"..gpsMove.orientationStr(),"dX:"..dX,gpsMove.positionStr(),"Positive delta: "..tostring(dX >= 0))
	--print("-----")


	--North/Souch axis
	--print("Before Z:",gpsMove.orientation..":"..gpsMove.orientationStr(),"dZ:"..dZ,gpsMove.positionStr(),"Positive delta: "..tostring(dZ >= 0))
	moveZAmnt(dZ)
	--print("After Z:",gpsMove.orientation..":"..gpsMove.orientationStr(),"dZ:"..dZ,gpsMove.positionStr(),"Positive delta: "..tostring(dZ >= 0))
end

function gpsMove.positionStr()
	return "{"..gpsMove.pos[1]..","..gpsMove.pos[2]..","..gpsMove.pos[3].."}"
end

function gpsMove.printPosition()
	print(gpsMove.positionStr())
end

function gpsMove.orientationStr()
	local switch = {}
	switch[0] = "north"
	switch[1] = "east"
	switch[2] = "south"
	switch[3] = "west"
	return switch[gpsMove.orientation]
end

function gpsMove.printOrientation()
	print(gpsMove.orientationStr())
end

--print("gpsMove Loaded")
return gpsMove