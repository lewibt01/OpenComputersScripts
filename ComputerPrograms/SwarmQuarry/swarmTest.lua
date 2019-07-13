--local arg = {...}

local component = require("component")
local modem = component.modem
local event = require("event")

local comPort = 2000
local respPort = 2001
local timeout = 3


modem.open(comPort)
modem.open(respPort)

local function command(...)
	modem.broadcast(comPort,...)
	local eventMsg,localAddress,remoteAddress,port,distance,data = event.pull(timeout,"modem_message")
	return data
	--[[
	print(localAddress,remoteAddress)
	print(port,distance)
	print(data)
	]]
end


print(command("select",1))
