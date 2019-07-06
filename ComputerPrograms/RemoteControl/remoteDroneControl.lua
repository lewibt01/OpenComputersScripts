local component = require("component")
local event = require("event")
local modem = component.modem
local comPort = 2412


local function compProxyStr(varName,componentName)
	return varName.."=component.proxy(component.list('"..componentName.."')())"
end

local function funcStr()
	local funcs = {}
	funcs[1] = [[function moveZ(amnt) drone.move(0,0,amnt) end]]
	funcs[2] = [[function moveX(amnt) drone.move(amnt,0,0) end]]
	funcs[3] = [[function moveY(amnt) drone.move(0,amnt,0) end]]
	funcs[4] = [[function quickLeash() return leash.leash(sides.bottom) end]]
	funcs[5] = [[function ground() moveY(-10) while(drone.getAcceleration() > 0) do moveY(-1) end return true end]]
	return table.concat(funcs,"\n")
end

local function varStr()
	local vars = {}
	vars[1] = "sides={bottom=0,down=0,top=1,up=1,back=2,front=3,forward=3,right=4,left=5}"
	return table.concat(vars,"\n")
end

local function sendStr(cmdStr)
	modem.broadcast(comPort,cmdStr)
end

modem.open(comPort)
modem.broadcast(comPort, "drone=component.proxy(component.list('drone')())")
modem.broadcast(comPort, compProxyStr("robot","robot"))
modem.broadcast(comPort, compProxyStr("leash","leash"))
sendStr(compProxyStr("navigation","navigation"))
sendStr(varStr())
sendStr(funcStr())

while true do
  local cmd=io.read()
  if not cmd then return end
  modem.broadcast(2412, cmd)
  print(select(6, event.pull(5, "modem_message")))
end