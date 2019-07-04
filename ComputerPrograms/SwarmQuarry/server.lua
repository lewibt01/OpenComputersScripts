--Swarm Quarry Server program

local component = require("component")
local event = require("event")
local m = component.modem
local comPort = 2142
local baseSignalStrength = 100
local boostSignalStrength = 400 --signal strength of boosted messages

m.open(comPort)

--[[base functions]]
function sendBoosted(address,port,...)
	local oldStrength = modem.getStrength()
	modem.setStrength(boostSignalStrength)
	local result = modem.send(address,port,arg)
	modem.setStrength(oldStrength)
	return result
end

function sendUnicast(id,cmd)
	
end

function sendMulticast(groupId,cmd)

end

function pollClient(address)
	sendBoosted(address,comPort,"handshake")
end

--get a status update from all listening clients
function pollClients()
	local oldStrength = modem.getStrength()
	modem.setStrength(400)

end

--[[compound functions]]
function arrangeRobots()

end