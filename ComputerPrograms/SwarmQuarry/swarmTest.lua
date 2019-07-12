local arg = {...}

local component = require("component")
local modem = component.modem
local event = require("event")

local comPort = 2000
local respPort = 2001
local timeout = 3


modem.open(comPort)
modem.open(respPort)

local args = table.pack(arg)
modem.broadcast(comPort,table.unpack(args))

local kind,localAddress,remoteAddress,port,distance,data = event.pull(timeout,"modem_message")


print(localAddress,remoteAddress)
print(port,distance)
print(data)

