local c = require("computer")
local r = require("robot")

iterations = 50

for i=1,iterations do
	r.swing()
	r.forward()
end
r.turnRight()
r.turnRight()
for i=1,iterations do
	r.forward()
end
