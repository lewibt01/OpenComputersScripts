--gps enabled simple robot commands
local arg = {...}
r = require("robot")
g = require("gpsMove")

--[[
for k,v in pairs(arg) do
    print(k,v)
end
]]

if(arg[1] == "home") then
    g.moveTo(0,0,0)
    g.turnTo(0)
elseif(arg[1] == "zero") then
    g.reZero()
elseif(arg[1] =="move") then
    g.moveTo(arg[2],arg[3],arg[4])
elseif(arg[1] == "turn") then
    if(arg[2] == "left") then
        g.turnLeft()
    elseif(arg[2] == "right") then
        g.turnRight()
    elseif(arg[2] == "around") then
        g.turnRight()
        g.turnRight()
    else
        print("arg 2 expected to be 'left', 'right', or 'around'")
    end

elseif(arg[1] == "get") then
    print("Facing:",g.orientationStr(),"Location:",g.positionStr())
else
    print("Invalid arguments")
end

