local component = require("component")
local computer = require("computer")
local term = require("term")

if(not term.isAvailable()) then
	print("Screens/GPUs are required")
	return
end

local maxMem = computer.totalMemory()
local freeMem = computer.freeMemory()

local energy = computer.energy()
local maxEnergy = computer.maxEnergy()

local uptime = computer.uptime()
local address = computer.address()

term.clear()
term.write("Memory: ("..freeMem.."/"..maxMem..")("..math.floor((freeMem/maxMem)*100).."%)\n")
term.write("Energy: ("..energy.."/"..maxEnergy..")("..math.floor((energy/maxEnergy)*100).."%)\n")
term.write("UpTime: "..uptime.."\n")
term.write("Address: "..address.."\n")
