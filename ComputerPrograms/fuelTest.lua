r = require("robot")
c = require("computer")

--measure and return how much energy a robot action uses
function measure(func)
	local energy = c.energy()
	func()
	return energy - c.energy()
end


print("forward", measure(r.forward))
print("back", measure(r.back))
print("right",measure(r.turnRight))
print("left",measure(r.turnLeft))
print("up",measure(r.up))
print("down",measure(r.down))
r.turnRight()
print("swing",measure(r.swing))
r.turnLeft()