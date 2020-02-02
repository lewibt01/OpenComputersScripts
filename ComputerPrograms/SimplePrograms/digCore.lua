r = require("robot")

iterations = 90

for i=1,iterations do
	r.swingDown()
	r.down()
end

r.back()

for i=1,iterations do
	r.up()
end

r.back()
