package.path = package.path..";I:\\Documents\\GitHub\\OpenComputersScripts\\APIs\\?.lua"
package.path = package.path..";I:\\Users\\Owner\\Documents\\GitHub\\OpenComputersScripts\\TestScripts\\?.lua"
r  = require("robot")
g = require("gpsMove")

function printInfo()
	io.write("#	")
	g.printPosition()
	io.write("#	")
	g.printOrientation()
end

function test(x,y,z)
	print("#######################")
	print("#	"..g.positionStr().." -> {"..x..","..y..","..z.."}")
	g.moveTo(x,y,z)
	printInfo()
end

g.reZero()
--printInfo()

test(0,1,3)
test(3,1,0)
test(8,2,4)
test(4,1,2)
test(0,0,0)
