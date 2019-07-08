local component = require("component")
local event = require("event")
local modem = component.modem
local comPort = 2412


local function compProxyStr(varName,componentName)
	return varName.."=component.proxy(component.list('"..componentName.."')())"
end

local function funcStr()
	local funcs = {}
	funcs[1] = [[function forward() return robot.move(sides.forward) end]]
	funcs[2] = [[function back() return robot.move(sides.back) end]]
	funcs[3] = [[function up() return robot.move(sides.up) end]]
	funcs[4] = [[function down() return robot.move(sides.down) end]]
	funcs[5] = [[function turnLeft() return robot.turn(false) end]]
	funcs[6] = [[function turnRight() return robot.turn(true) end]]
	funcs[7] = [[function swing() return robot.swing(sides.front) end]]
	funcs[8] = [[function swingUp() return robot.swing(sides.up) end]]
	funcs[9] = [[function swingDown() return robot.swing(sides.down) end]]
	funcs[10] = [[function place() return robot.place(sides.front) end]]
	funcs[11] = [[function placeUp() return robot.place(sides.up) end]]
	funcs[12] = [[function placeDown() return robot.place(sides.down) end]]
	funcs[13] = [[function test() return 'true' end]]

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

--load libraries/code
modem.open(comPort)
sendStr(compProxyStr("robot","robot"))
sentStr(compProxyStr("g","gpsMove"))
sendStr(varStr())
sendStr(funcStr())

while true do
  local cmd=io.read()
  if not cmd then return end
  modem.broadcast(2412, cmd)
  print(select(6, event.pull(5, "modem_message")))
end