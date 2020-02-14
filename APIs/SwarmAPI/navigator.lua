local cmd = require("commandTranslate")
local math3d = require("math3d")

local navigator = {}
navigator.clients = {}

function navigator.sendCommand()

end

function navigator.buildStep(deltas,deltaIndex,pos,neg)
	local instructions = {}
	local iterations = math.abs(deltas[deltaIndex])

	if(deltas[deltaIndex] > 0) then
		for i=1,iterations do
			table.insert(instructions,pos)
		end
	else
		for i=1,iterations do
			table.insert(instructions,neg)
		end
	end
end

function buildSteps(p1,p2)
	local instructions = {}
	local turnDirection
	local tmp
	local deltas = math3d.deltas(p1,p2)

	local function resolveOrientation(delta,positiveDir,negativeDir)
		if(delta > 0) then
			table.insert(instructions,"T "..positiveDir)
		else
			table.insert(instructions,"T "..negativeDir)
		end
	end

	--y
	tmp = navigator.buildStep(deltas,2,)
end

function navigator.path(point)

end

return navigator