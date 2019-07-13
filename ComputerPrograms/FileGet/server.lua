-- # fserv.lua
local shell = require("shell")
local uptime = require("computer").uptime
local modem = require("component").modem
local pull = require("event").pull
local uuid = require("uuid")
local fs = require("filesystem")

local args, opts = shell.parse(...)
local port = 22

-- # handle port options

local srvdir
if args[1] then
  assert(fs.exists(args[1]))
  assert(fs.isDirectory(args[1]))
  srvdir = args[1]
else
  srvdir = shell.getWorkingDirectory()
end

modem.open(port)

while true do
  local ev = {pull("(modem_message)(interrupted)")}
  
  if ev[1] == "interrupted" then
    print "quitting.."
    os.exit()
  elseif ev[1] == "modem_message" and ev[6] == "F_REQUEST" and ev[7] ~= nil then
    local path = srvdir..ev[7]
    
    if fs.exists(path) and (not fs.isDirectory(path)) then
      local chunkSize = modem.maxPacketSize() - 1024
      local res = {pcall(io.open, path, "r")}
      
      if not res[1] then
        io.stderr:write("service error: " .. res[2])
      else
        local fd = res[1]
        local chunk = fd:read(chunkSize)

        if chunk then
          local key = uuid.next()
          
          modem.send(ev[3], ev[4], "F_RESPONSE", key)

          repeat
            modem.send(ev[3], ev[4], key, chunk)
            
            res = {pcall(function()
                chunk = fd:read(chunkSize)
              end)}

            if not res[1] then
              modem.send(ev[3], ev[4], key, nil, 'error') -- # nil, 'error' signals srv failure on client
              break
            end
          until not chunk

          if res[1] then -- ok
            modem.send(ev[3], ev[4], key, nil) -- # eof on client
          else
            io.stderr:write(res[2] or "bad salsa")
          end
        end
      end
    end
  end
end