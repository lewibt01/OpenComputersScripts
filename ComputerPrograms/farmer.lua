local component = require("component")
local g = require("gpsMove")
local r = require("robot")
local rComp = component.robot

local length=8
local width=8
g.reZero()

function dropAllDown()
    for i=1,16 do
        r.select(i)
        r.dropDown()
    end
end

function dumpResources()
    g.turnRight()
    g.forward()
    g.forward()
    g.forward()
    g.turnLeft()
    dropAllDown()
    g.forward()
    dropAllDown()
    g.back()
    g.turnLeft()
    g.forward()
    g.forward()
    g.forward()
    g.turnRight()
end

function step()
    r.useDown()
    local result
    while(r.suckDown()) do
        print("grabbing seeds")
    end 
end

local oldColor = rComp.getLightColor()
rComp.setLightColor(0x00AAAA)

for i=0,length do
    for j=0,width do
        step()
        g.forward()
        --g.moveTo(i*-1,0,j*-1)
    end
    if(i%2==0) then
        g.turnLeft()
        g.forward()
        g.turnLeft()
    else
        g.turnRight()
        g.forward()
        g.turnRight()
    end
end

--return to home position
g.moveTo(0,0,0)
g.turnTo(0)

--dump resources
dumpResources()
g.turnTo(0)

rComp.setLightColor(oldColor)
