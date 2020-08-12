--local arg = {...}

local component = require("component")
local tunnel = component.tunnel
local event = require("event")

local timeout = 3

local function command(...)
    tunnel.send(...)
    local eventMsg,localAddress,remoteAddress,port,distance,data = event.pull(timeout,"modem_message")
    return data
    --[[
    print(localAddress,remoteAddress)
    print(port,distance)
    print(data)
    ]]
end

print(command("select",1))
