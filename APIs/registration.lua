local modem = require("component").modem
local p = require("properties")
local event = require("event")

local register = {}
register.addresses = {}
register.port = 4321

function register.listen()
    modem.open(register.port)
    while true do
        local eventMsg,localAddress,remoteAddress,port,distance,data = event.pull(timeout,"modem_message")
        if(data == "register") then
            --make sure we don't end up with overwritten keys
            local i = 0
            while (p.get("registrant"..i) ~= nil) do
                i = i+1
            end

            p.add("registrant"..i,remoteAddress)
            --print("Registered "..remoteAddress)
            return remoteAddress
        end
    end
    modem.close(register.port)
    return false
end

function register.announce()
    modem.open(register.port)
    modem.broadcast(register.port,"register")
    modem.close(register.port)
end

return register