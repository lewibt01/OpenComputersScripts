local modem = require("component").modem
local p = require("properties")
local event = require("event")

local register = {}
register.addresses = {}
register.port = 4321
register.timeout = 10

function register.getRegistrants()
    props = p.getAll()
    clients = {}
    for _,p in pairs(props) do
        if(string.find(p,"registrant")) then
            table.insert(clients,p)
        end
    end
    return clients
end 

function register.listen()
    modem.open(register.port)
    while true do
        local eventMsg,localAddress,remoteAddress,port,distance,data = event.pull(register.timeout,"modem_message")
        if(data == "register") then
            --make sure we don't end up with duplicate keys
            local i = 0
            while (p.get("registrant"..i) ~= nil) do
                i = i+1
            end

            p.add("registrant"..i,remoteAddress)
            --print("Registered "..remoteAddress)
            modem.send("registered",register.port,localAddress)
            return remoteAddress
        end
    end
    modem.close(register.port)
    return false
end

function register.announce()
    modem.open(register.port)
    modem.broadcast(register.port,"register")
    
    --wait for handshake
    local eventMsg,localAddress,remoteAddress,port,distance,data = event.pull(register.timeout,"modem_message")
    if(data == "registered") then
        p.set("host",remoteAddress)
    end
    
    modem.close(register.port)
end

return register