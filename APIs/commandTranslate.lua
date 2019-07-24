comp = require("computer")
r = require("robot")

cmd = {}

function cmd.translate(input,...)
	-- '...' denotes a special variable called 'arg', it stores an unknown number of arguments
	local arg = {...}

	local c = {} --commands lookup table, in lieu of a switch statement
	--robot api functions
	c["name"] = r.name

	c["detect"] = r.detect
	c["detectUp"] = r.detectUp
	c["detectDown"] = r.detectDown

	c["select"] = r.select
	c["inventorySize"] = r.inventorySize
	c["count"] = r.count
	c["space"] = r.space
	c["transferTo"] = r.transferTo
	c["compareTo"] = r.compareTo

	c["compare"] = r.compare
	c["compareUp"] = r.compareUp
	c["compareDown"] = r.compareDown

	c["drop"] = r.drop
	c["dropUp"] = r.dropUp
	c["dropDown"] = r.dropDown

	c["suck"] = r.suck
	c["suckUp"] = r.suckUp
	c["suckDown"] = r.suckDown

	c["place"] = r.place
	c["placeUp"] = r.placeUp
	c["placeDown"] = r.placeDown

	c["use"] = r.use
	c["useUp"] = r.useUp
	c["useDown"] = r.useDown

	c["forward"] = r.forward
	c["back"] = r.back
	c["up"] = r.up
	c["down"] = r.down
	c["turnLeft"] = r.turnLeft
	c["turnRight"] = r.turnRight

	c["tankCount"] = r.tankCount
	c["tankSpace"] = r.tankSpace
	c["compareFluidTo"] = r.compareFluidTo
	c["transferFluidTo"] = r.transferFluidTo
	c["compareFluid"] = r.compareFluid
	c["compareFluidUp"] = r.compareFluidUp
	c["compareFluidDown"] = r.compareFluidDown

	c["drain"] = r.drain
	c["drainUp"] = r.drainUp
	c["drainDown"] = r.drainDown

	c["fill"] = r.fill
	c["fillUp"] = r.fillUp
	c["fillDown"] = r.fillDown

	--computer api functions
	c["address"] = comp.address
	c["tmpAddress"] = comp.tmpAddress
	c["freeMemory"] = comp.freeMemory
	c["totalMemory"] = comp.totalMemory
	c["energy"] = comp.energy
	c["maxEnergy"] = comp.maxEnergy
	c["uptime"] = comp.uptime
	c["shutdown"] = comp.shutdown
	--c["getBootAddress"] = comp.getBootAddress
	--c["setBootAddress"] = comp.setBootAddress

	--c["runLevel"] = comp.setRunLevel
	--c["users"] = comp.users
	--c["addUser"] = comp.addUser
	--c["removeUser"] = comp.removeUser

	--c["pushSignal"] = comp.pushSignal
	--c["pullSignal"] = comp.pullSignal
	c["beep"] = comp.beep

	
	if c[input] == nil then
		return false
	end
	if(arg ~= nil) then
		for k,v in pairs(arg) do print(k..":"..v) end
		if(#arg > 0) then
			return c[input](table.unpack(arg))
		else
			return c[input]()
		end
	else
		return c[input]()
	end
end

return cmd