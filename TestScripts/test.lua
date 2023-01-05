package.path = package.path..";C:\\GitRepositories\\OpenComputersScripts\\APIs\\?.lua"
package.path = package.path..";C:\\GitRepositories\\OpenComputersScripts\\Mocks\\?.lua"
--package.path = package.path..";G:\\Users\\Owner\\Documents\\GitHub\\OpenComputersScripts\\TestScripts\\?.lua"

r = require("robot")
g = require("gpsMove")
t = require("commandTranslate")

function testMove(x,y,z)
    g.moveTo(x,y,z)
    print(g.positionStr(),g.orientationStr())
end

testMove(0,0,0)