local component = require("component")
local computer = require("computer")
local term = require("term")

if(not term.isAvailable()) then
	print("Screens/GPUs are required")
	return
end

term.clear()
term.write("Memory: ("..tostring(computer.freeMemory()).."/"..tostring(computer.totalMemory())..")\n")
term.write("Energy: ("..computer.energy().."/"..computer.maxEnergy()..")\n")
term.write("UpTime: "..computer.upTime().."\n")
term.write("Address: "..computer.address().."\n")

