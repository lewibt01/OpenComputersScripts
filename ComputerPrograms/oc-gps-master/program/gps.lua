local component = require("component")
local gps = require("gps")
local vector = require("vector")
local robot = require("robot")
local serialization = require("serialization")
local event = require("event")
local os = require("os")

local CHANNEL_GPS = 65534

local modem = component.modem
local navigation = component.navigation

local function printUsage()
  print( "Usages:" )
  print( "gps host <x> <y> <z>" )
  print( "gps autohost <x> <y> <z> <i>" )
  print( "gps locate" )
end

local tArgs = { ... }
if #tArgs < 1 then
  printUsage()
  return
end

local function wirelessmodem()
  if modem.isWireless() then
    return true
  else
    print("No wireless network card installed")
    return false
  end
end

local function robot()
  if component.isAvailable("robot") then
    return true
  else
    print("Only robots can run autohost")
    return false
  end
end

local function getfacing()
  local facing = navigation.getFacing()
  if facing >= 4 then
    facing = 2 * facing - 7
  else
    facing = -2 * facing + 6
  end
  return facing
end

local sCommand = tArgs[1]
if sCommand == "locate" then
  if wirelessmodem() then
    gps.locate( 2, true )
  end

elseif sCommand == "host" then
  if wirelessmodem() then
    local pos
    if #tArgs >= 4 then
      pos = vector.new(tArgs[2], tArgs[3], tArgs[4])
      if pos.x == nil or pos.y == nil or pos.z == nil then
        printUsage()
        return
      end
      print( "Position is "..pos.x..","..pos.y..","..pos.z )
    else
      pos = vector.new(gps.locate( 2, true ))
      if x == nil then
        print( "Run \"gps host <x> <y> <z>\" to set position manually" )
        return
      end
    end
    print( "Serving GPS requests" )
    local nServed = 0
    modem.open(CHANNEL_GPS)
    while true do
      _, _, sender, _, distance, message = event.pull("modem_message")
      if message == "PING" then
        modem.send(sender, CHANNEL_GPS, serialization.serialize(pos))
        nServed = nServed + 1
        print( nServed.."GPS Requests served" )
      end
    end
  end

elseif sCommand == "autohost" then
  if wirelessmodem() and robot() then
    local offset
    local pos = vector.new(navigation.getPosition())
    local i
    local diff
    local facing = getfacing()
    local height
    if #tArgs >= 4 then
      offset = vector.new(tArgs[2], 0, tArgs[3])
      pos = pos + offset
      i = tonumber(tArgs[4])
      if pos.x == nil or pos.y == nil or pos.z == nil or i == nil then
        printUsage()
        return
      end
      print( "Position is "..pos.x..","..pos.y..","..pos.z )
    end
    if i % 2 == 0 then
      diff = (1 - i) * 10
      height = 235
      finalpos = vector.new(pos.x, height, pos.z + diff)
    else
      diff = (2 - i) * 10
      height = 255
      finalpos = vector.new(pos.x + diff, height, pos.z)
    end
    for j = pos.y, height do
      while robot.detectUp() do
        print("Path blocked")
        os.sleep(1)
      end
      robot.up()
    end
    for j = 1, (i + facing) % 4 do
      robot.turnLeft()
    end
    for j = 0, 9 do
      while robot.detect() do
        print("Path blocked")
        os.sleep(1)
      end
      robot.forward()
    end
    print(string.format("Serving GPS requests at %d, %d, %d", finalpos.x, finalpos.y, finalpos.z))
    local nServed = 0
    modem.open(CHANNEL_GPS)
    while true do
      _, _, sender, _, distance, message = event.pull("modem_message")
      if message == "PING" then
        
        modem.send(sender, CHANNEL_GPS, serialization.serialize(finalpos))
        
        nServed = nServed + 1

        print( nServed.." GPS Requests served" )
      end
    end
  elseif wirelessmodem() then
    print("Only robots can use autohost")
  end
else
  printUsage()
  return
end