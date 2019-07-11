--Swarm Quarry Server program

local component = require("component")
local event = require("event")
local m = component.modem
local comPort = 2000
local responsePort = 2001
local baseSignalStrength = 100
local boostSignalStrength = 400 --signal strength of boosted messages
local addresses = {}

m.open(comPort)

--[[base functions]]
function sendBoosted(address,port,...)
	local oldStrength = modem.getStrength()
	modem.setStrength(boostSignalStrength)
	local result = modem.send(address,port,arg)
	modem.setStrength(oldStrength)
	return result
end

function send(address,port,...)
	local oldStrength = modem.getSterngth()
	modem.setStrength(baseSignalStrength)
	local result = modem.send(address,port,arg)
	modem.setStrength(oldStrength)
	return result
end

function test(address)
	
end

function command(address,...)

end
