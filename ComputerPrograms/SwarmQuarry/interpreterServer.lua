--this program will be run on a server containing 2 tunnel cards. 
--It will receive high-level commands from a master server and interpret 
--those commands into steps for the robot to follow

component = require("component")
tunnels = {}
for address,name in component.list("tunnel") do
    table.insert(tunnels,component.proxy(address))
end

comp = require("computer")


local timeout = 3

function send(tunnel,...)
    local result = tunnel.send(arg)
    return result
end

function receive()
    local eventMsg,localAddress,remoteAddress,port,distance,result = event.pull(timeout,"modem_message")
    return result
end

local function command(...)
    send(...)
    return receive()
end

function moveTo(x,y,z)
    print(x,y,z) --implement later
end

function quarryStep(tunnel)
    local function digColumnDown()
        while(tunnel.send("digDown") and tunnel.send("down")) do
            print("stepDown")
        end
        print("done")
    end

    local function digColunnUp()
        while(command("detectUp") and command("digUp") and command("up")) do
            print("stepUp")
        end
        print("done")
    end


end



function translate(input,...)
    -- '...' denotes a special variable called 'arg', it stores an unknown number of arguments
    local arg = {...}

    local c = {} --commands lookup table, in lieu of a switch statement
    
    --robot api functions
    c["beep"] = comp.beep
    c["digColumnUp"] = digColumnUp
    c["digColumnDown"] = digColumnDown
    c["dig"] = dig

    
    if c[input] == nil then
        return false
    end
    if(arg ~= nil) then
        --for k,v in pairs(arg) do print(k..":"..v) end
        if(#arg > 0) then
            return c[input](table.unpack(arg))
        else
            return c[input]()
        end
    end
end