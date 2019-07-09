package.path = package.path..";I:\\Documents\\GitHub\\OpenComputersScripts\\APIs\\?.lua"
package.path = package.path..";I:\\Users\\Owner\\Documents\\GitHub\\OpenComputersScripts\\TestScripts\\?.lua"

r = require("robot")
g = require("gpsMove")
t = require("commandTranslation")

function testMove(x,y,z)
	g.moveTo(x,y,z)
	print(g.positionStr(),g.orientationStr())
end

