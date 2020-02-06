r = require("robot")
g = require("gpsMove")

g.reZero()

g.printPosition()
g.printOrientation()

g.moveTo(1,0,-3)
g.moveTo(0,0,0)

g.printPosition()
g.printOrientation()