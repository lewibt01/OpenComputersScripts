--drone remote control client demo
local component = require("component")
local event = require(event)
local modem = component.modem
local id = 2412

modem.open(id)
modem.broadcast(id, "drone=component.proxy(component.list(\"drone\")()")
while true do
	local cmd = io.read()
	if not cmd then return end
	modem.broadcast(id,cmd)
	print(select(6,event.pull(5,"modem_message")))
end