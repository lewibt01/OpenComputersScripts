local component = require("component")
local r = require("robot")
local g = require("gpsMove")
local t = require("commandTranslate")
local m=component.proxy(component.list("modem")())
local computer = require("computer")

local hostAddress = "ec54a72a-1121-4246-82c4-d39212481987"
local comPort = 2000
local responsePort = 2001

print("Address:"..computer.address())
m.open(comPort)
m.open(responsePort)

local function respond(...)
    local args=table.pack(...)
    m.send(hostAddress, responsePort, table.unpack(args))
end

local function broadcast(...)
	local args=table.pack(...)
	m.broadcast(responsePort,table.unpack(args))
end

--[[
local function receive()
    while true do
        local evt,_,_,_,_,cmd=computer.pullSignal()
        if evt=="modem_message" then return load(cmd) end
    end
end
]]

local function receive()
	while true do
		--issue is here, program needs to handle any number of arguments after the first
		local evnt,_,_,_,_,cmd,rawArgs = computer.pullSignal()
		local args = table.pack(rawArgs)

		if evnt=="modem_message" then
			print(cmd)
			--[[if(args ~= nil) then
				for k,v in pairs(args) do print(k,v) end
			end]]
			if(cmd == "handshake") then
				return "handshake"
			else
				return t.translate(cmd,table.unpack(args))
			end
		end
	end
end


while true do
	local result = receive()
	--respond(result)
	broadcast(result)
end
--[[
while true do
    local result,reason=pcall(function()
        local result,reason=receive()
        if not result then return respond(reason) end
        respond(result())
    end)
    if not result then respond(reason) end
end
]]