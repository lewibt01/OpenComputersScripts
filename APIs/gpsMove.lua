r = require("robot")

local debugFlag = false

local function debug(...)
	if(debugFlag) then
		print(...)
	end
end

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
			debug("Error in gpsMove.forward()")
			return false
		end
	end
	return result
end

--[[
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
]]

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
--[[
function gpsMove.turnTo(orient)
	if((orient < 4) and (orient > 0)) then
		while(gpsMove.orientation ~= orient) do
			gpsMove.turnRight()
		end
	else
		print("orientation must be < 4")
	end
end
]]

function gpsMove.turnTo(orient)
	debug("///////////////////////////////")
	debug("/	raw orient = "..orient)
	orient = orient % 4
	debug("/	orient start: "..gpsMove.orientation.." target: "..orient)
	--print("/	orienting to "..orient)
	local direction = orient-gpsMove.orientation --this will be positive/negative to denote direction of the turn, actual value does not matter, just the parity
	if(direction > 2) then
		direction = (direction*-1) % -2
	end
	debug("/	direction raw: "..orient-gpsMove.orientation.." adjusted: "..direction)
	debug("/	turning "..direction)

	local magnitude = math.abs(direction)--how many turns we will have to make, there should be no more than 2
	debug("/	magnitude raw: "..math.abs(direction).." adjusted: "..magnitude)

	local turnFunc --will store a reference to the turn function being called based on <direction> parity
	if(direction > 0) then
		turnFunc = gpsMove.turnRight
		debug("/	turnRight "..magnitude)
	elseif(direction < 0) then
		turnFunc = gpsMove.turnLeft
		debug("/	turnLeft "..magnitude)
	elseif(direction == 0) then
		--do nothing, we are 0 turns away from the desired orientation
		debug("/	No turn necessary")
	else
		debug("/	Error in turnTo()")
	end

	local result
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
	debug("Delta",dX,dY,dZ)

	local function moveAmnt(func,amnt)
		local result
		for i=1,math.abs(amnt) do
			result = func()
		end
		return result
	end

	local function moveVerticalAmnt(amount)
		local result
		if(amount > 0) then
			result = moveAmnt(gpsMove.up,amount)
			debug("up "..amount)
		elseif(amount < 0) then
			result = moveAmnt(gpsMove.down,amount)
			debug("down "..amount)
		end
		return result
	end

	--x coordinates: + = right, - = left
	local function moveXAmnt(amount)
		if(amount > 0) then
			gpsMove.turnTo(1)
			debug("X+ "..amount)
		elseif(amount < 0) then
			gpsMove.turnTo(3)
			debug("X- "..amount)
		end
		return moveAmnt(gpsMove.forward,amount)
	end

	--z coordinates: + = south, - = north
	local function moveZAmnt(amount)
		if(amount > 0) then
			gpsMove.turnTo(2)
			debug("Z+ "..amount)
		elseif(amount < 0) then
			gpsMove.turnTo(0)
			debug("Z- "..amount)
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