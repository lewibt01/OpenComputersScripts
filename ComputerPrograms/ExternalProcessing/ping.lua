local component = require("component")
local netComp = component.internet
local net = require("internet")

print(netComp.isTcpEnabled())
print(netComp.isHttpEnabled())

conn = netComp.connect("172.78.244.59",5555)
print(conn:read(10))