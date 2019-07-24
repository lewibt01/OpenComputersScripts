package.path = package.path..";I:\\Documents\\GitHub\\OpenComputersScripts\\APIs\\?.lua"
package.path = package.path..";I:\\Users\\Owner\\Documents\\GitHub\\OpenComputersScripts\\TestScripts\\?.lua"
v = require("vector")

--https://math.stackexchange.com/questions/2344536/finding-coordinates-of-a-point-in-3d-with-known-distances-from-3-other-points

origin = v.new(0,0,0)
pts = {
	v.new(0,10,0),
	v.new(10,0,0),
	v.new(0,0,10),
	v.new(0,-10,0)
}

rads = {}
for i=1,#pts do
	rads[i] = v.distance(origin,pts[i])
end

--radii should be provided in their squared form
--gives 2 possible coordinates
function trilaterate(radii,knownPoints)
	local function sum(t)
		local s = 0
		for i=1,#t do
			s = s+t[i]
		end
		return s
	end	

	local function findErr(g)
		findAccuracy(knownPoints,radii,g)
	end

	local guess = v.new(0,0,0) 
	local xMover = 1
	local yMover = 1
	local zMover = 1

	local startError = sum(findErr())

	--find the x direction
	local oldGuess = guess
	guess = v.new(1,0,0)
	if(findErr(guess) > startEror) then
		xMover = xMover * -1
	end

	

end

--find out if a number fits within a range +- the error
--error should be typically small
function isWithin(number,target,err)
	if(number <= target+err and number >= target-err) then
		return true
	else
		return false
	end
end

function findAccuracy(knownPoints,distances,targetPoint)
	local accuracy = 0.01
	local i=1
	local differences = {}
	for i=1,#knownPoints do
		differences[i] = v.distance(knownPoints[i], targetPoint) - distances[i]
	end

	return differences
end

function isPointValid(knownPoints,distances,targetPoint)
	local accuracy = 0.01
	local i=1
	local differences = {}
	for i=1,#knownPoints do
		local tmpDist = v.distance(knownPoints[i], targetPoint)
		
		if not isWithin(tmpDist,distances[i],accuracy) then
			return false
		end
	end

	return true
end



--print(isPointValid(pts,rads,v.new(0,0,0)))
diffs = findAccuracy(pts,rads,v.new(0,0,0))
for k,v in pairs(diffs) do print(v) end

--pick a point, then solve system of equations against other 3 points

print("done")