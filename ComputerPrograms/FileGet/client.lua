-- # fget.lua
local args, opts = require("shell").parse(...)
local uptime = require("computer").uptime
local modem = require("component").modem
local pull = require("event").pull

local filename = assert(args[1], "Usage: fget filename [port] [timeout]")
local port = 22
local timeout = 5

if opts.port then
  local pnum = assert(tonumber(opts.port), "option 'port' must be a number!")
  port = assert(pnum > 0 and pnum <= 65535)
end

if opts.timeout then
  timeout = assert(tonumber(opts.timeout),"option 'timeout(seconds)' must be number. [~3 sec recommended]")
end

modem.open(port)

modem.broadcast(port, "F_REQUEST", filename) -- crude and will allow just about anybody to fulfill this request :/

local response, key
local stime = uptime()

repeat
  local ev = {pull((stime + timeout - uptime()), "(modem_message)(interrupted)")}

  if ev[1] == "interrupted" then
  	print(ev[1])
  	os.exit()
  elseif ev[1] == "modem_message" and ev[6] == "F_RESPONSE" then
    key = ev[7]
    response = true
    break
  end
until uptime() >= (stime + timeout)

if not response then
  print "timed out. no response"
  os.exit()
end

local _error
stime = uptime() -- # refresh timeout

repeat
  local ev = {pull((stime + timeout - uptime()), "(modem_message)(interrupted)")}

  if ev[1] == "interrupted" then
  	print(ev[1])
  	os.exit()
  elseif ev[1] == "modem_message" and ev[6] == key then
    stime = uptime() -- # refresh the timeout
    
    if not ev[7] then
      if ev[8] and ev[8] == "error" then
        _error = true
        io.stderr:write("error occured. '*drops pizza on the floor*'")
      end
      
      break
    end
    
    io.stdout:write(ev[7])
  end
until uptime() >= (stime + timeout)

if _error then
  os.exit(1)
end

-- # Disclaimer: this hasn't been tested :3