--Swarm Quarry Server program

local component = require("component")
local event = require("event")
local computer = require("computer")
local m = component.modem
local p = require("properties")

local comPort = 2000
local responsePort = 2001
local baseSignalStrength = 100
local boostSignalStrength = 400 --signal strength of boosted messages
--local addresses = {"75c263f1-8a52-42ac-aa41-edadef9b5cd2"}
local addresses = {p.get("registrant0")}

m.open(comPort)
m.open(responsePort)

--[[base functions]]
function sendBoosted(address,port,...)
    local oldStrength = m.getStrength()
    m.setStrength(boostSignalStrength)
    local result = m.send(address,port,arg)
    m.setStrength(oldStrength)
    return result
end

function send(address,port,...)
    local oldStrength = m.getStrength()
    m.setStrength(baseSignalStrength)
    local result = m.send(address,port,arg)
    m.setStrength(oldStrength)
    return result
end

function receive()
    
    while true do
        local evnt,_,_,_,_,response = computer.pullSignal()

        if evnt=="modem_message" then
            return response
        end
    end
end

function test(address)
    send(address,comPort,"forward")
    receive()
end

function command(address,...)

end

test(addresses[1])