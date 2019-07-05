local component = require("component")
local magnet = component.tractor_beam
local event = require("event")


for i=1,10 do
	magnet.suck()
	os.sleep(0.5)
end

