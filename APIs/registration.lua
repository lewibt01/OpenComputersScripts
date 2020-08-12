local modem = require("component").modem
local p = require("properties")
local event = require("event")

register  = {}
register.addresses = {}

function register.listen()
    modem.open(4321)
    while true do
        local eventMsg,localAddress,remoteAddress,port,distance,data = event.pull(timeout,"modem_message")
        if(data == "register") then
            --make sure we don't end up with duplicate keys
            local i = 0
            while (p.get("registrant"..i) ~= nil) do
                i = i+1
            end

            p.add("registrant"..i,remoteAddress)
            --print("Registered "..remoteAddress)
            return remoteAddress
        end
    end
    modem.close(4321)
    return false
end

function register.announce()
    modem.open(4321)
    modem.broadcast(4321,"register")
    modem.close(4321)
end

return register