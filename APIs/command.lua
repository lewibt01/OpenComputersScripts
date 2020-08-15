local component = require("component")
local modem = component.modem
local t = require("commandTranslate")
local computer = require("computer")

local command = {}
command.hostAddress = "ec54a72a-1121-4246-82c4-d39212481987" 
command.comPort = 2000
command.responsePort = 2001

function command.send(address,...)
    local args = table.pack(...)
    if(not modem.isOpen(responsePort)) then
        modem.open(responsePort)
    end
    modem.send(address,comPort,...)
end

function command.receive()
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

return command