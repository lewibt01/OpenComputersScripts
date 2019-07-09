local r = require("robot")
local g = require("gpsMove")
local t = require("commandTranslation")
local m=component.proxy(component.list("modem")())

local hostAddress = ""
local comPort = 2000
local responsePort = 2001


m.open(comPort)
m.open(responsePort)

local function respond(...)
    local args=table.pack(...)
    m.send(hostAddress, responsePort, table.unpack(args))
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
		local evnt,_,_,_,_,cmd = computer.pullSignal()
		if evnt=="modem_message" then return t.translate(cmd) end
	end
end


while true do
	local result = receive()
	respond(result)
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